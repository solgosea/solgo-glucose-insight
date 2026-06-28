param(
  [string]$DeviceId = "",
  [string]$Package = "com.metaguru.smartxdrip",
  [string[]]$ProbeIds = @(),
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
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$artifactRoot = Join-Path (Resolve-Path ".").Path "build\probe-test-artifacts\controls-$stamp"
New-Item -ItemType Directory -Force -Path $artifactRoot | Out-Null

if (-not $ProbeIds) {
  $ProbeIds = (Get-ProbeInventory | ForEach-Object { $_.id })
} else {
  $resolvedProbeIds = @()
  foreach ($item in $ProbeIds) {
    $resolvedProbeIds += ($item -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ })
  }
  $ProbeIds = $resolvedProbeIds
}

Write-Host "[probe-controls] device=$device artifacts=$artifactRoot probes=$($ProbeIds.Count)" -ForegroundColor Cyan

Restore-ProbeDeviceBaseline -DeviceId $device -Package $Package

Open-ProbeChecklistRoute `
  -DeviceId $device `
  -ArtifactDir $artifactRoot `
  -Package $Package `
  -TimeoutSeconds $ManualNavigationTimeoutSeconds

function Invoke-ControlCase {
  param(
    [string]$ProbeId,
    [ValidateSet("available", "unavailable")] [string]$State
  )

  $safeName = ($ProbeId -replace '[^A-Za-z0-9_.-]', '_') + "-$State"
  $caseDir = Join-Path $artifactRoot $safeName
  New-Item -ItemType Directory -Force -Path $caseDir | Out-Null

  $control = Set-ProbeControlledState `
    -ProbeId $ProbeId `
    -State $State `
    -DeviceId $device `
    -Package $Package `
    -Root $root `
    -NightscoutPort $NightscoutPort `
    -ArtifactDir $caseDir `
    -AllowSystemMutation:$AllowSystemMutation `
    -EnableExternalAppControl:$EnableExternalAppControl `
    -BuildExternalApps:$BuildExternalApps `
    -ExternalRoot $ExternalRoot
  $control | ConvertTo-Json -Depth 8 | Set-Content -Path (Join-Path $caseDir "control.json") -Encoding UTF8

  if (-not $control.controlled) {
    return [ordered]@{
      probeId = $ProbeId
      state = $State
      controlled = $false
      reason = $control.reason
      artifactDir = $caseDir
    }
  }

  $caseNightscoutBaseUrl = ""
  if ($ProbeId.StartsWith("nightscout.")) {
    $caseNightscoutBaseUrl = "http://127.0.0.1:$NightscoutPort"
  }

  Open-ProbeChecklistRoute `
    -DeviceId $device `
    -ArtifactDir $caseDir `
    -Package $Package `
    -TimeoutSeconds $ManualNavigationTimeoutSeconds `
    -NightscoutBaseUrl $caseNightscoutBaseUrl

  Invoke-ProbeRunChecks -DeviceId $device -ArtifactDir $caseDir -TimeoutSeconds 90 | Out-Null
  $xml = Get-ProbeChecklistExpandedXml -DeviceId $device -ArtifactDir $caseDir
  Save-AdbScreenshot -DeviceId $device -OutputPath (Join-Path $caseDir "probe-checklist.png")
  Save-AdbUiDump -DeviceId $device -OutputPath (Join-Path $caseDir "probe-checklist.xml")
  $visibleText = Convert-UiXmlToVisibleText -UiXml $xml
  $visibleText | Set-Content -Path (Join-Path $caseDir "probe-visible-text.txt") -Encoding UTF8
  $inventory = New-ProbeInventoryResult -VisibleText $visibleText
  $item = $inventory.items | Where-Object { $_.id -eq $ProbeId } | Select-Object -First 1

  $expectedGood = $State -eq "available"
  $passed = if ($expectedGood) {
    $item.status -eq "yes"
  } else {
    $item.status -ne "yes"
  }

  return [ordered]@{
    probeId = $ProbeId
    state = $State
    controlled = $true
    passed = $passed
    observedStatus = $item.status
    observedSummary = $item.summary
    artifactDir = $caseDir
  }
}

$results = @()
foreach ($probeId in $ProbeIds) {
  Write-Host ""
  Write-Host "[probe-controls] $probeId available" -ForegroundColor Green
  try {
    Restore-ProbeDeviceBaseline -DeviceId $device -Package $Package
    $result = Invoke-ControlCase -ProbeId $probeId -State available
    $results += $result
    Write-Host "  status=$($result.observedStatus) controlled=$($result.controlled) pass=$($result.passed) $($result.reason)" -ForegroundColor Yellow
  } catch {
    $results += [ordered]@{ probeId = $probeId; state = "available"; controlled = $false; passed = $false; error = $_.Exception.Message }
    Write-Host "  ERROR $($_.Exception.Message)" -ForegroundColor Red
  } finally {
    Restore-ProbeDeviceBaseline -DeviceId $device -Package $Package
  }

  Write-Host "[probe-controls] $probeId unavailable" -ForegroundColor DarkYellow
  try {
    Restore-ProbeDeviceBaseline -DeviceId $device -Package $Package
    $result = Invoke-ControlCase -ProbeId $probeId -State unavailable
    $results += $result
    Write-Host "  status=$($result.observedStatus) controlled=$($result.controlled) pass=$($result.passed) $($result.reason)" -ForegroundColor Yellow
  } catch {
    $results += [ordered]@{ probeId = $probeId; state = "unavailable"; controlled = $false; passed = $false; error = $_.Exception.Message }
    Write-Host "  ERROR $($_.Exception.Message)" -ForegroundColor Red
  } finally {
    Restore-ProbeDeviceBaseline -DeviceId $device -Package $Package
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
  notes = @(
    "Each probe is tested as available and unavailable when a scriptable control exists.",
    "External package/config/derived probes are reported as not controlled unless real dependencies are installed/configured."
  )
}

Save-ProbeSummary -Summary $summary -OutputPath (Join-Path $artifactRoot "probe-control-summary.json")
Write-Host ""
Write-Host "[probe-controls] summary: $(Join-Path $artifactRoot 'probe-control-summary.json')" -ForegroundColor Cyan
