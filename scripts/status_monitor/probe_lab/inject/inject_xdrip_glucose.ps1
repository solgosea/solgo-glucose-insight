param(
  [string]$DeviceId = "",
  [string]$Package = "com.metaguru.smartxdrip",
  [ValidateSet("directReceiver", "systemBroadcast", "fixture")]
  [string]$Mode = "directReceiver",
  [double]$Glucose = 118,
  [string]$Unit = "mg/dL",
  [string]$SlopeName = "Flat",
  [double]$Slope = 0,
  [int]$TimestampOffsetMinutes = 0
)

$ErrorActionPreference = "Stop"
$labRoot = Split-Path $PSScriptRoot -Parent
. (Join-Path $labRoot "lib\probe_lab_paths.ps1")
$matrixRoot = Get-ProbeMatrixRoot

if ($Mode -eq "fixture") {
  . (Join-Path $matrixRoot "lib\adb_device.ps1")
  . (Join-Path $matrixRoot "lib\external_probe_apps.ps1")
  $device = Resolve-AdbDevice -DeviceId $DeviceId
  $app = Get-ExternalProbeApp -AppId "xdrip"
  $externalPackage = Get-InstalledExternalProbePackage -DeviceId $device -App $app
  if (-not $externalPackage) {
    throw "No installed xDrip debug app package found. Build/install xDrip first, then rerun fixture injection."
  }
  Invoke-Adb -DeviceId $device -Arguments @("shell", "monkey", "-p", $externalPackage, "-c", "android.intent.category.LAUNCHER", "1") | Out-Null
  Start-Sleep -Milliseconds 800
  Invoke-Adb -DeviceId $device -Arguments @("shell", "input", "keyevent", "3") | Out-Null
  Start-Sleep -Milliseconds 300
  $timestampMs = [DateTimeOffset]::UtcNow.AddMinutes($TimestampOffsetMinutes).ToUnixTimeMilliseconds()
  $glucoseText = [string]::Format([Globalization.CultureInfo]::InvariantCulture, "{0:0.0}", $Glucose)
  $slopeText = [string]::Format([Globalization.CultureInfo]::InvariantCulture, "{0:0.0}", $Slope)
  Invoke-Adb -DeviceId $device -Arguments @(
    "shell", "am", "broadcast",
    "--include-stopped-packages",
    "-a", "com.metaguru.probe.XDRIP_SEND_BG",
    "-n", "$externalPackage/com.eveningoutpost.dexdrip.probe.XdripProbeFixtureReceiver",
    "--el", "timestamp", "$timestampMs",
    "--ef", "glucose", $glucoseText,
    "--ef", "slope", $slopeText,
    "--es", "slopeName", $SlopeName
  ) | Out-Null
  [ordered]@{
    path = "xdrip.fixture.BgEstimate"
    device = $device
    externalPackage = $externalPackage
    glucose = $glucoseText
    timestampMs = $timestampMs
  } | ConvertTo-Json -Compress
  return
}

if ($Mode -eq "directReceiver") {
  & (Join-Path $matrixRoot "broadcast\send_xdrip_bg_estimate.ps1") `
    -DeviceId $DeviceId `
    -Package $Package `
    -Glucose $Glucose `
    -Unit $Unit `
    -SlopeName $SlopeName `
    -Slope $Slope `
    -TimestampOffsetMinutes $TimestampOffsetMinutes
  return
}

$matrixRoot = Get-ProbeMatrixRoot
. (Join-Path $matrixRoot "lib\adb_device.ps1")
$device = Resolve-AdbDevice -DeviceId $DeviceId
$timestampMs = [DateTimeOffset]::UtcNow.AddMinutes($TimestampOffsetMinutes).ToUnixTimeMilliseconds()
$glucoseText = [string]::Format([Globalization.CultureInfo]::InvariantCulture, "{0:0.0}", $Glucose)
$slopeText = [string]::Format([Globalization.CultureInfo]::InvariantCulture, "{0:0.0}", $Slope)
Invoke-Adb -DeviceId $device -Arguments @(
  "shell", "am", "broadcast",
  "--include-stopped-packages",
  "-a", "com.eveningoutpost.dexdrip.BgEstimate",
  "--el", "timestamp", "$timestampMs",
  "--ef", "glucose", $glucoseText,
  "--es", "units", $Unit,
  "--es", "slopeName", $SlopeName,
  "--ef", "slope", $slopeText
) | Out-Null

[ordered]@{
  path = "xdrip.BgEstimate.systemBroadcast"
  device = $device
  glucose = $glucoseText
  timestampMs = $timestampMs
} | ConvertTo-Json -Compress
