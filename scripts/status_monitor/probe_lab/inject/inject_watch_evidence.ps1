param(
  [string]$DeviceId = "",
  [ValidateSet("fixture")]
  [string]$Mode = "fixture",
  [string]$BridgeName = "Watch bridge",
  [bool]$DisplayObserved = $true,
  [int]$TimestampOffsetMinutes = 0
)

$ErrorActionPreference = "Stop"
$labRoot = Split-Path $PSScriptRoot -Parent
. (Join-Path $labRoot "lib\probe_lab_paths.ps1")
$matrixRoot = Get-ProbeMatrixRoot
. (Join-Path $matrixRoot "lib\adb_device.ps1")
. (Join-Path $matrixRoot "lib\external_probe_apps.ps1")

$device = Resolve-AdbDevice -DeviceId $DeviceId
$app = Get-ExternalProbeApp -AppId "watch"
$externalPackage = Get-InstalledExternalProbePackage -DeviceId $device -App $app
if (-not $externalPackage) {
  throw "No installed Watchdrip debug app package found. Build/install Watchdrip first, then rerun fixture injection."
}
Invoke-Adb -DeviceId $device -Arguments @("shell", "monkey", "-p", $externalPackage, "-c", "android.intent.category.LAUNCHER", "1") | Out-Null
Start-Sleep -Milliseconds 800
Invoke-Adb -DeviceId $device -Arguments @("shell", "input", "keyevent", "3") | Out-Null
Start-Sleep -Milliseconds 300
$timestampMs = [DateTimeOffset]::UtcNow.AddMinutes($TimestampOffsetMinutes).ToUnixTimeMilliseconds()
Invoke-Adb -DeviceId $device -Arguments @(
  "shell", "am", "broadcast",
  "--include-stopped-packages",
  "-a", "com.metaguru.probe.WATCHDRIP_SEND_DISPLAY",
  "-n", "$externalPackage/com.thatguysservice.huami_xdrip.probe.WatchdripProbeFixtureReceiver",
  "--el", "timestamp", "$timestampMs",
  "--es", "bridgeName", $BridgeName,
  "--ez", "displayObserved", $(if ($DisplayObserved) { "true" } else { "false" })
) | Out-Null

[ordered]@{
  path = "watch.fixture.display"
  device = $device
  externalPackage = $externalPackage
  bridgeName = $BridgeName
  displayObserved = $DisplayObserved
  timestampMs = $timestampMs
} | ConvertTo-Json -Compress
