param(
  [string]$DeviceId = "",
  [string]$Package = "com.metaguru.smartxdrip",
  [int]$NightscoutPort = 14120,
  [int]$ManualNavigationTimeoutSeconds = 45,
  [switch]$SkipAppStart,
  [switch]$AllowSystemMutation,
  [switch]$EnableExternalAppControl,
  [switch]$BuildExternalApps,
  [string]$ExternalRoot = "",
  [switch]$KeepNightscout
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
$artifactRoot = Join-Path (Resolve-Path ".").Path "build\probe-test-artifacts\full-chain-$stamp"
New-Item -ItemType Directory -Force -Path $artifactRoot | Out-Null

Write-Host "[probe-full-chain] device=$device artifacts=$artifactRoot" -ForegroundColor Cyan

$logPath = Join-Path $artifactRoot "probe-logcat.txt"
$logcat = Start-ProbeLogcatCapture -DeviceId $device -OutputPath $logPath

try {
  Open-ProbeChecklistRoute `
    -DeviceId $device `
    -ArtifactDir $artifactRoot `
    -Package $Package `
    -TimeoutSeconds $ManualNavigationTimeoutSeconds

  $arrangeDir = Join-Path $artifactRoot "arrange"
  New-Item -ItemType Directory -Force -Path $arrangeDir | Out-Null
  $arrangements = @()

  & (Join-Path $root "device\grant_probe_runtime_permissions.ps1") -DeviceId $device -Package $Package |
    Set-Content -Path (Join-Path $arrangeDir "grant-runtime-permissions.json") -Encoding UTF8
  & (Join-Path $root "device\clear_probe_evidence.ps1") -DeviceId $device -Package $Package |
    Set-Content -Path (Join-Path $arrangeDir "clear-evidence.json") -Encoding UTF8

  $availableProbeIds = @(
    "common.network.connectivity",
    "common.internet.validated",
    "common.bluetooth.enabled",
    "common.bluetooth.permission",
    "common.notification.permission",
    "common.battery.optimization",
    "common.runtime.background",
    "xdrip.package.visible",
    "xdrip.broadcast.bg_estimate",
    "xdrip.broadcast.freshness",
    "xdrip.web_service.reachable",
    "xdrip.web_service.entries",
    "xdrip.aaps.output_evidence",
    "juggluco.package.visible",
    "juggluco.broadcast.glucodata_minute",
    "juggluco.broadcast.xdrip_compatible",
    "juggluco.broadcast.freshness",
    "nightscout.status.reachable",
    "nightscout.entries.freshness",
    "nightscout.devicestatus.visible",
    "nightscout.response_time",
    "aaps.package.visible",
    "aaps.bg_source.xdrip_evidence",
    "aaps.devicestatus.evidence",
    "aaps.loop.context_evidence",
    "watch.bridge.package",
    "watch.display.evidence"
  )

  foreach ($probeId in $availableProbeIds) {
    $result = Set-ProbeControlledState `
      -ProbeId $probeId `
      -State available `
      -DeviceId $device `
      -Package $Package `
      -Root $root `
      -NightscoutPort $NightscoutPort `
      -ArtifactDir $arrangeDir `
      -AllowSystemMutation:$AllowSystemMutation `
      -EnableExternalAppControl:$EnableExternalAppControl `
      -BuildExternalApps:$BuildExternalApps `
      -ExternalRoot $ExternalRoot
    $arrangements += $result
  }
  $arrangements | ConvertTo-Json -Depth 8 | Set-Content -Path (Join-Path $arrangeDir "arrangements.json") -Encoding UTF8

  Open-ProbeChecklistRoute `
    -DeviceId $device `
    -ArtifactDir $artifactRoot `
    -Package $Package `
    -TimeoutSeconds $ManualNavigationTimeoutSeconds `
    -NightscoutBaseUrl "http://127.0.0.1:$NightscoutPort"

  $xml = Invoke-ProbeRunChecks -DeviceId $device -ArtifactDir $artifactRoot -TimeoutSeconds 90
  Save-AdbScreenshot -DeviceId $device -OutputPath (Join-Path $artifactRoot "probe-checklist.png")
  Save-AdbUiDump -DeviceId $device -OutputPath (Join-Path $artifactRoot "probe-checklist.xml")
  $visibleText = Convert-UiXmlToVisibleText -UiXml $xml
  $visibleText | Set-Content -Path (Join-Path $artifactRoot "probe-visible-text.txt") -Encoding UTF8
  $inventory = New-ProbeInventoryResult -VisibleText $visibleText

  $summary = [ordered]@{
    device = $device
    package = $Package
    generatedAt = (Get-Date).ToString("o")
    artifactRoot = $artifactRoot
    allowSystemMutation = [bool]$AllowSystemMutation
    enableExternalAppControl = [bool]$EnableExternalAppControl
    buildExternalApps = [bool]$BuildExternalApps
    nightscoutPort = $NightscoutPort
    arrangements = $arrangements
    inventory = $inventory
    notes = @(
      "This full-chain run composes scriptable phone, broadcast, Nightscout, and optional external package evidence.",
      "Nightscout probes still depend on the app's configured Nightscout target; this script exposes the mock via adb reverse.",
      "AAPS/watch downstream evidence probes require real or dedicated simulator evidence and are not faked."
    )
  }
  Save-ProbeSummary -Summary $summary -OutputPath (Join-Path $artifactRoot "probe-full-chain-summary.json")
  Write-Host "[probe-full-chain] found=$($inventory.found)/$($inventory.total) yes=$($inventory.yes) no=$($inventory.no) unknown=$($inventory.unknown)" -ForegroundColor Yellow
} finally {
  Stop-ProbeLogcatCapture -Process $logcat
  if (-not $KeepNightscout) {
    $connection = Get-NetTCPConnection -LocalPort $NightscoutPort -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($connection) {
      Stop-Process -Id $connection.OwningProcess -Force -ErrorAction SilentlyContinue
    }
  }
}

Write-Host "[probe-full-chain] summary: $(Join-Path $artifactRoot 'probe-full-chain-summary.json')" -ForegroundColor Cyan
