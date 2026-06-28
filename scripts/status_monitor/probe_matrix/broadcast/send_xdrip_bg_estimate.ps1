param(
  [string]$DeviceId = "",
  [string]$Package = "com.metaguru.smartxdrip",
  [double]$Glucose = 118,
  [string]$Unit = "mg/dL",
  [string]$SlopeName = "Flat",
  [double]$Slope = 0,
  [int]$TimestampOffsetMinutes = 0
)

$ErrorActionPreference = "Stop"
$lib = Join-Path (Split-Path -Parent $PSScriptRoot) "lib\adb_device.ps1"
. $lib

$device = Resolve-AdbDevice -DeviceId $DeviceId
$receiver = "$Package/.statusmonitor.xdrip.XdripBroadcastReceiver"
$timestampMs = [DateTimeOffset]::UtcNow.AddMinutes($TimestampOffsetMinutes).ToUnixTimeMilliseconds()
$glucoseText = [string]::Format([Globalization.CultureInfo]::InvariantCulture, "{0:0.0}", $Glucose)
$slopeText = [string]::Format([Globalization.CultureInfo]::InvariantCulture, "{0:0.0}", $Slope)

Invoke-Adb -DeviceId $device -Arguments @(
  "shell",
  "am",
  "broadcast",
  "--include-stopped-packages",
  "-a",
  "com.eveningoutpost.dexdrip.BgEstimate",
  "-n",
  $receiver,
  "--el",
  "timestamp",
  "$timestampMs",
  "--ef",
  "glucose",
  $glucoseText,
  "--es",
  "units",
  $Unit,
  "--es",
  "slopeName",
  $SlopeName,
  "--ef",
  "slope",
  $slopeText
) | Out-Null

[ordered]@{
  path = "xdrip.BgEstimate"
  device = $device
  glucose = $glucoseText
  timestampMs = $timestampMs
} | ConvertTo-Json -Compress
