param(
  [string]$DeviceId = "",
  [string]$Package = "com.metaguru.smartxdrip",
  [double]$Glucose = 124,
  [int]$TimestampOffsetMinutes = 0
)

$ErrorActionPreference = "Stop"
$lib = Join-Path (Split-Path -Parent $PSScriptRoot) "lib\adb_device.ps1"
. $lib

$device = Resolve-AdbDevice -DeviceId $DeviceId
$receiver = "$Package/.statusmonitor.juggluco.JugglucoBroadcastReceiver"
$timestampMs = [DateTimeOffset]::UtcNow.AddMinutes($TimestampOffsetMinutes).ToUnixTimeMilliseconds()
$glucoseText = [string]::Format([Globalization.CultureInfo]::InvariantCulture, "{0:0.0}", $Glucose)

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
  "com.eveningoutpost.dexdrip.Extras.Time",
  "$timestampMs",
  "--ef",
  "com.eveningoutpost.dexdrip.Extras.BgEstimate",
  $glucoseText,
  "--el",
  "timestamp",
  "$timestampMs",
  "--ef",
  "glucose",
  $glucoseText
) | Out-Null

[ordered]@{
  path = "juggluco.xdripCompatible.BgEstimate"
  device = $device
  glucose = $glucoseText
  timestampMs = $timestampMs
} | ConvertTo-Json -Compress
