param(
  [string]$DeviceId = "",
  [ValidateSet("fixture")]
  [string]$Mode = "fixture",
  [string]$BgSource = "xdrip",
  [bool]$DevicestatusObserved = $true,
  [bool]$LoopContextObserved = $true,
  [string]$LoopState = "visible",
  [int]$TimestampOffsetMinutes = 0
)

$ErrorActionPreference = "Stop"
$labRoot = Split-Path $PSScriptRoot -Parent
. (Join-Path $labRoot "lib\probe_lab_paths.ps1")
$matrixRoot = Get-ProbeMatrixRoot
. (Join-Path $matrixRoot "lib\adb_device.ps1")
. (Join-Path $matrixRoot "lib\external_probe_apps.ps1")

$device = Resolve-AdbDevice -DeviceId $DeviceId
$app = Get-ExternalProbeApp -AppId "aaps"
$externalPackage = Get-InstalledExternalProbePackage -DeviceId $device -App $app
if (-not $externalPackage) {
  throw "No installed AAPS debug app package found. Build/install AAPS first, then rerun fixture injection."
}
Invoke-Adb -DeviceId $device -Arguments @("shell", "monkey", "-p", $externalPackage, "-c", "android.intent.category.LAUNCHER", "1") | Out-Null
Start-Sleep -Milliseconds 800
Invoke-Adb -DeviceId $device -Arguments @("shell", "input", "keyevent", "3") | Out-Null
Start-Sleep -Milliseconds 300
$timestampMs = [DateTimeOffset]::UtcNow.AddMinutes($TimestampOffsetMinutes).ToUnixTimeMilliseconds()
Invoke-Adb -DeviceId $device -Arguments @(
  "shell", "am", "broadcast",
  "--include-stopped-packages",
  "-a", "com.metaguru.probe.AAPS_SEND_CONTEXT",
  "-n", "$externalPackage/app.aaps.probe.AapsProbeFixtureReceiver",
  "--el", "timestamp", "$timestampMs",
  "--es", "bgSource", $BgSource,
  "--ez", "devicestatusObserved", $(if ($DevicestatusObserved) { "true" } else { "false" }),
  "--ez", "loopContextObserved", $(if ($LoopContextObserved) { "true" } else { "false" }),
  "--es", "loopState", $LoopState
) | Out-Null

[ordered]@{
  path = "aaps.fixture.context"
  device = $device
  externalPackage = $externalPackage
  bgSource = $BgSource
  devicestatusObserved = $DevicestatusObserved
  loopContextObserved = $LoopContextObserved
  timestampMs = $timestampMs
} | ConvertTo-Json -Compress
