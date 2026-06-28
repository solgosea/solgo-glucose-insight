param(
  [string]$DeviceId = "",
  [string]$Package = "com.metaguru.smartxdrip",
  [string[]]$Suites = @("common", "xdrip", "juggluco", "nightscout", "aaps", "watch"),
  [int]$NightscoutPort = 14120,
  [int]$ManualNavigationTimeoutSeconds = 45,
  [switch]$SkipAppStart,
  [switch]$AllowSystemMutation,
  [switch]$EnableExternalAppControl,
  [switch]$BuildExternalApps,
  [string]$ExternalRoot = ""
)

$ErrorActionPreference = "Stop"

$root = $PSScriptRoot
. (Join-Path $root "lib\adb_device.ps1")
. (Join-Path $root "lib\probe_ui.ps1")
. (Join-Path $root "lib\probe_assertions.ps1")
. (Join-Path $root "lib\probe_inventory.ps1")
. (Join-Path $root "lib\probe_controls.ps1")

$device = Resolve-AdbDevice -DeviceId $DeviceId
$resolvedSuites = @()
foreach ($item in $Suites) {
  $resolvedSuites += ($item -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ })
}

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$artifactRoot = Join-Path (Resolve-Path ".").Path "build\probe-test-artifacts\suites-$stamp"
New-Item -ItemType Directory -Force -Path $artifactRoot | Out-Null

Write-Host "[probe-suites] device=$device artifacts=$artifactRoot suites=$($resolvedSuites -join ',')" -ForegroundColor Cyan

Open-ProbeChecklistRoute `
  -DeviceId $device `
  -ArtifactDir $artifactRoot `
  -Package $Package `
  -TimeoutSeconds $ManualNavigationTimeoutSeconds

function Invoke-SuiteState {
  param(
    [Parameter(Mandatory = $true)][string]$Suite,
    [Parameter(Mandatory = $true)][ValidateSet("available", "unavailable")] [string]$State
  )

  $suiteDir = Join-Path $artifactRoot "$Suite-$State"
  New-Item -ItemType Directory -Force -Path $suiteDir | Out-Null
  $probes = @(Get-ProbeInventory | Where-Object { $_.suite -eq $Suite })
  if (-not $probes) {
    throw "Unknown probe suite '$Suite'."
  }

  $controls = @()
  foreach ($probe in $probes) {
    $control = Set-ProbeControlledState `
      -ProbeId $probe.id `
      -State $State `
      -DeviceId $device `
      -Package $Package `
      -Root $root `
      -NightscoutPort $NightscoutPort `
      -ArtifactDir $suiteDir `
      -AllowSystemMutation:$AllowSystemMutation `
      -EnableExternalAppControl:$EnableExternalAppControl `
      -BuildExternalApps:$BuildExternalApps `
      -ExternalRoot $ExternalRoot
    $controls += $control
  }

  $controls | ConvertTo-Json -Depth 8 | Set-Content -Path (Join-Path $suiteDir "suite-controls.json") -Encoding UTF8

  $suiteNightscoutBaseUrl = if ($Suite -eq "nightscout") { "http://127.0.0.1:$NightscoutPort" } else { "" }
  Open-ProbeChecklistRoute `
    -DeviceId $device `
    -ArtifactDir $suiteDir `
    -Package $Package `
    -TimeoutSeconds $ManualNavigationTimeoutSeconds `
    -NightscoutBaseUrl $suiteNightscoutBaseUrl

  Invoke-ProbeRunChecks -DeviceId $device -ArtifactDir $suiteDir -TimeoutSeconds 75 | Out-Null
  $xml = Get-ProbeChecklistExpandedXml -DeviceId $device -ArtifactDir $suiteDir
  Save-AdbScreenshot -DeviceId $device -OutputPath (Join-Path $suiteDir "probe-checklist.png")
  Save-AdbUiDump -DeviceId $device -OutputPath (Join-Path $suiteDir "probe-checklist.xml")
  $visibleText = Convert-UiXmlToVisibleText -UiXml $xml
  $visibleText | Set-Content -Path (Join-Path $suiteDir "probe-visible-text.txt") -Encoding UTF8
  $inventory = New-ProbeInventoryResult -VisibleText $visibleText
  $items = @($inventory.items | Where-Object { $_.suite -eq $Suite })
  $controlled = @($controls | Where-Object { $_.controlled }).Count

  return [ordered]@{
    suite = $Suite
    state = $State
    artifactDir = $suiteDir
    probeCount = $probes.Count
    controlledCount = $controlled
    yes = @($items | Where-Object { $_.status -eq "yes" }).Count
    no = @($items | Where-Object { $_.status -eq "no" }).Count
    unknown = @($items | Where-Object { $_.status -eq "unknown" }).Count
    items = $items
    controls = $controls
  }
}

$results = @()
foreach ($suite in $resolvedSuites) {
  Write-Host ""
  Write-Host "[probe-suites] $suite available" -ForegroundColor Green
  try {
    $results += Invoke-SuiteState -Suite $suite -State available
  } catch {
    $results += [ordered]@{ suite = $suite; state = "available"; error = $_.Exception.Message }
    Write-Host "  ERROR $($_.Exception.Message)" -ForegroundColor Red
  }

  Write-Host "[probe-suites] $suite unavailable" -ForegroundColor DarkYellow
  try {
    $results += Invoke-SuiteState -Suite $suite -State unavailable
  } catch {
    $results += [ordered]@{ suite = $suite; state = "unavailable"; error = $_.Exception.Message }
    Write-Host "  ERROR $($_.Exception.Message)" -ForegroundColor Red
  }
}

$summary = [ordered]@{
  device = $device
  package = $Package
  generatedAt = (Get-Date).ToString("o")
  artifactRoot = $artifactRoot
  allowSystemMutation = [bool]$AllowSystemMutation
  enableExternalAppControl = [bool]$EnableExternalAppControl
  buildExternalApps = [bool]$BuildExternalApps
  results = $results
}
Save-ProbeSummary -Summary $summary -OutputPath (Join-Path $artifactRoot "probe-suite-summary.json")

Write-Host ""
Write-Host "[probe-suites] summary: $(Join-Path $artifactRoot 'probe-suite-summary.json')" -ForegroundColor Cyan
