param(
  [string]$DeviceId = "",
  [string]$Package = "com.metaguru.smartxdrip",
  [double]$Glucose = 121,
  [string]$Unit = "mg/dL",
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
  "glucodata.Minute",
  "-n",
  $receiver,
  "--el",
  "timestamp",
  "$timestampMs",
  "--ef",
  "glucose",
  $glucoseText,
  "--ef",
  "glucodata.Minute.mgdl",
  $glucoseText,
  "--es",
  "unit",
  $Unit
) | Out-Null

[ordered]@{
  path = "juggluco.glucodata.Minute"
  device = $device
  glucose = $glucoseText
  timestampMs = $timestampMs
} | ConvertTo-Json -Compress
