param(
  [string]$DeviceId = "",
  [string]$Package = "com.metaguru.smartxdrip",
  [ValidateSet("directReceiver", "systemBroadcast", "fixture")]
  [string]$Mode = "directReceiver",
  [double]$Glucose = 121,
  [switch]$XdripCompatible,
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
  $app = Get-ExternalProbeApp -AppId "juggluco"
  $externalPackage = Get-InstalledExternalProbePackage -DeviceId $device -App $app
  if (-not $externalPackage) {
    throw "No installed Juggluco debug app package found. Build/install Juggluco first, then rerun fixture injection."
  }
  Invoke-Adb -DeviceId $device -Arguments @("shell", "monkey", "-p", $externalPackage, "-c", "android.intent.category.LAUNCHER", "1") | Out-Null
  Start-Sleep -Milliseconds 800
  Invoke-Adb -DeviceId $device -Arguments @("shell", "input", "keyevent", "3") | Out-Null
  Start-Sleep -Milliseconds 300
  $timestampMs = [DateTimeOffset]::UtcNow.AddMinutes($TimestampOffsetMinutes).ToUnixTimeMilliseconds()
  $glucoseText = [string]::Format([Globalization.CultureInfo]::InvariantCulture, "{0:0.0}", $Glucose)
  Invoke-Adb -DeviceId $device -Arguments @(
    "shell", "am", "broadcast",
    "--include-stopped-packages",
    "-a", "com.metaguru.probe.JUGGLUCO_SEND_GLUCOSE",
    "-n", "$externalPackage/tk.glucodata.probe.JugglucoProbeFixtureReceiver",
    "--el", "timestamp", "$timestampMs",
    "--ef", "glucose", $glucoseText,
    "--ez", "xdripCompatible", $(if ($XdripCompatible) { "true" } else { "false" })
  ) | Out-Null
  [ordered]@{
    path = if ($XdripCompatible) { "juggluco.fixture.xdripCompatible" } else { "juggluco.fixture.glucodataMinute" }
    device = $device
    externalPackage = $externalPackage
    glucose = $glucoseText
    timestampMs = $timestampMs
  } | ConvertTo-Json -Compress
  return
}

if ($Mode -eq "directReceiver") {
  $script = if ($XdripCompatible) {
    Join-Path $matrixRoot "broadcast\send_juggluco_xdrip_compatible.ps1"
  } else {
    Join-Path $matrixRoot "broadcast\send_juggluco_glucodata.ps1"
  }
  & $script -DeviceId $DeviceId -Package $Package -Glucose $Glucose -TimestampOffsetMinutes $TimestampOffsetMinutes
  return
}

$matrixRoot = Get-ProbeMatrixRoot
. (Join-Path $matrixRoot "lib\adb_device.ps1")
$device = Resolve-AdbDevice -DeviceId $DeviceId
$timestampMs = [DateTimeOffset]::UtcNow.AddMinutes($TimestampOffsetMinutes).ToUnixTimeMilliseconds()
$glucoseText = [string]::Format([Globalization.CultureInfo]::InvariantCulture, "{0:0.0}", $Glucose)
if ($XdripCompatible) {
  Invoke-Adb -DeviceId $device -Arguments @(
    "shell", "am", "broadcast",
    "--include-stopped-packages",
    "-a", "com.eveningoutpost.dexdrip.BgEstimate",
    "--el", "com.eveningoutpost.dexdrip.Extras.Time", "$timestampMs",
    "--ef", "com.eveningoutpost.dexdrip.Extras.BgEstimate", $glucoseText,
    "--el", "timestamp", "$timestampMs",
    "--ef", "glucose", $glucoseText
  ) | Out-Null
} else {
  Invoke-Adb -DeviceId $device -Arguments @(
    "shell", "am", "broadcast",
    "--include-stopped-packages",
    "-a", "glucodata.Minute",
    "--el", "timestamp", "$timestampMs",
    "--ef", "glucose", $glucoseText,
    "--ef", "glucodata.Minute.mgdl", $glucoseText,
    "--es", "unit", "mg/dL"
  ) | Out-Null
}

[ordered]@{
  path = if ($XdripCompatible) { "juggluco.xdripCompatible.systemBroadcast" } else { "juggluco.glucodata.Minute.systemBroadcast" }
  device = $device
  glucose = $glucoseText
  timestampMs = $timestampMs
} | ConvertTo-Json -Compress
