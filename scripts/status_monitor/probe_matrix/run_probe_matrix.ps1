param(
  [string]$DeviceId = "",
  [string]$Package = "com.metaguru.smartxdrip",
  [string[]]$Cases = @("baseline", "xdripFresh", "jugglucoFresh", "nightscoutFresh", "xdripStale"),
  [int]$NightscoutPort = 14120,
  [int]$ManualNavigationTimeoutSeconds = 45,
  [switch]$ClearBroadcastPrefs,
  [switch]$SkipAppStart,
  [switch]$KeepNightscout
)

$ErrorActionPreference = "Stop"

$root = $PSScriptRoot
. (Join-Path $root "lib\adb_device.ps1")
. (Join-Path $root "lib\probe_ui.ps1")
. (Join-Path $root "lib\probe_assertions.ps1")
. (Join-Path $root "lib\probe_inventory.ps1")

$device = Resolve-AdbDevice -DeviceId $DeviceId
$resolvedCases = @()
foreach ($caseItem in $Cases) {
  $resolvedCases += ($caseItem -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ })
}
if (-not $resolvedCases) {
  throw "No probe matrix cases were provided."
}

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$artifactRoot = Join-Path (Resolve-Path ".").Path "build\probe-test-artifacts\$stamp"
New-Item -ItemType Directory -Force -Path $artifactRoot | Out-Null

Write-Host "[probe-matrix] device=$device artifacts=$artifactRoot" -ForegroundColor Cyan

Set-AdbReversePort -DeviceId $device -Port $NightscoutPort
if ($ClearBroadcastPrefs) {
  Clear-StatusMonitorBroadcastPrefs -DeviceId $device -Package $Package
}
if (-not $SkipAppStart) {
  Start-ProbeApp -DeviceId $device -Package $Package
}

$logPath = Join-Path $artifactRoot "probe-logcat.txt"
$logcat = Start-ProbeLogcatCapture -DeviceId $device -OutputPath $logPath
$nightscoutProcessIds = @()
$caseResults = @()

try {
  Open-ProbeChecklistRoute `
    -DeviceId $device `
    -ArtifactDir $artifactRoot `
    -Package $Package `
    -TimeoutSeconds $ManualNavigationTimeoutSeconds

  foreach ($case in $resolvedCases) {
    $caseDir = Join-Path $artifactRoot $case
    New-Item -ItemType Directory -Force -Path $caseDir | Out-Null
    Write-Host ""
    Write-Host "[probe-matrix] case=$case" -ForegroundColor Green

    try {
      switch ($case) {
        "baseline" {
          Write-Host "  arrange: no extra probe evidence injected"
        }
        "xdripFresh" {
          & (Join-Path $root "broadcast\send_xdrip_bg_estimate.ps1") `
            -DeviceId $device `
            -Package $Package `
            -Glucose 118 `
            -SlopeName Flat | Tee-Object -FilePath (Join-Path $caseDir "arrange-xdrip.json") | Out-Null
        }
        "xdripStale" {
          & (Join-Path $root "broadcast\send_xdrip_bg_estimate.ps1") `
            -DeviceId $device `
            -Package $Package `
            -Glucose 119 `
            -SlopeName Flat `
            -TimestampOffsetMinutes -25 | Tee-Object -FilePath (Join-Path $caseDir "arrange-xdrip-stale.json") | Out-Null
        }
        "jugglucoFresh" {
          & (Join-Path $root "broadcast\send_juggluco_glucodata.ps1") `
            -DeviceId $device `
            -Package $Package `
            -Glucose 122 | Tee-Object -FilePath (Join-Path $caseDir "arrange-juggluco-direct.json") | Out-Null
          & (Join-Path $root "broadcast\send_juggluco_xdrip_compatible.ps1") `
            -DeviceId $device `
            -Package $Package `
            -Glucose 123 | Tee-Object -FilePath (Join-Path $caseDir "arrange-juggluco-compatible.json") | Out-Null
        }
        "nightscoutFresh" {
          $nsJson = & (Join-Path $root "nightscout\start_probe_nightscout.ps1") `
            -Port $NightscoutPort `
            -Scenario fresh `
            -ArtifactDir $caseDir `
            -StopExisting
          $ns = $nsJson | ConvertFrom-Json
          $nightscoutProcessIds += [int]$ns.pid
          Set-AdbReversePort -DeviceId $device -Port $NightscoutPort
          $nsJson | Set-Content -Path (Join-Path $caseDir "arrange-nightscout.json") -Encoding UTF8
          Write-Host "  mock Nightscout ready at $($ns.baseUrl). Configure app target to this URL for Nightscout probes."
        }
        default {
          throw "Unknown probe matrix case '$case'."
        }
      }

      $caseNightscoutBaseUrl = if ($case.StartsWith("nightscout")) { "http://127.0.0.1:$NightscoutPort" } else { "" }
      if ($case -eq "nightscoutFresh") {
        Start-ProbeApp -DeviceId $device -Package $Package
        Open-ProbeChecklistRoute `
          -DeviceId $device `
          -ArtifactDir $caseDir `
          -Package $Package `
          -TimeoutSeconds $ManualNavigationTimeoutSeconds `
          -NightscoutBaseUrl $caseNightscoutBaseUrl
      }

      $finalXml = Invoke-ProbeRunChecks `
        -DeviceId $device `
        -ArtifactDir $caseDir `
        -TimeoutSeconds 60

      Save-AdbScreenshot `
        -DeviceId $device `
        -OutputPath (Join-Path $caseDir "probe-checklist.png")
      Save-AdbUiDump `
        -DeviceId $device `
        -OutputPath (Join-Path $caseDir "probe-checklist.xml")

      $required = @("Phone environment", "xDrip+", "Juggluco", "Nightscout", "AAPS", "Watch")
      $result = New-ProbeCaseResult `
        -Name $case `
        -ArtifactDir $caseDir `
        -UiXml $finalXml `
        -RequiredTexts $required
      $visibleText = Convert-UiXmlToVisibleText -UiXml $finalXml
      $visibleText | Set-Content -Path (Join-Path $caseDir "probe-visible-text.txt") -Encoding UTF8
      $inventory = New-ProbeInventoryResult -VisibleText $visibleText
      $result.inventory = $inventory
      $caseResults += $result

      $status = if ($result.passed) { "PASS" } else { "CHECK" }
      Write-Host "  $status rows=$($inventory.found)/$($inventory.total) yes=$($inventory.yes) no=$($inventory.no) unknown=$($inventory.unknown)" -ForegroundColor Yellow
      if (-not $result.passed) {
        Write-Host "  missing: $($result.missingTexts -join ', ')" -ForegroundColor Red
      }
    } catch {
      $errorResult = [ordered]@{
        name = $case
        passed = $false
        error = $_.Exception.Message
        artifactDir = $caseDir
      }
      $caseResults += $errorResult
      Write-Host "  ERROR $($_.Exception.Message)" -ForegroundColor Red
    }
  }
} finally {
  Stop-ProbeLogcatCapture -Process $logcat
  if (-not $KeepNightscout) {
    foreach ($pid in $nightscoutProcessIds) {
      Stop-Process -Id $pid -Force -ErrorAction SilentlyContinue
    }
  }
}

$summary = [ordered]@{
  device = $device
  package = $Package
  nightscoutPort = $NightscoutPort
  generatedAt = (Get-Date).ToString("o")
  artifactRoot = $artifactRoot
  cases = $caseResults
  notes = @(
    "Nightscout probes use the app's configured Nightscout target; adb reverse only exposes the mock endpoint to the phone.",
    "Broadcast cases verify SolgoInsight receivers and freshness handling, not that a real third-party app is installed or configured."
  )
}

Save-ProbeSummary -Summary $summary -OutputPath (Join-Path $artifactRoot "probe-summary.json")

Write-Host ""
Write-Host "[probe-matrix] done: $artifactRoot" -ForegroundColor Cyan
Write-Host "[probe-matrix] summary: $(Join-Path $artifactRoot 'probe-summary.json')" -ForegroundColor Cyan
