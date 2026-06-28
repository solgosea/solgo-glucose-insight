param(
  [string]$DeviceId = "",
  [string]$Package = "com.metaguru.smartxdrip"
)

$ErrorActionPreference = "Stop"
$lib = Join-Path (Split-Path -Parent $PSScriptRoot) "lib\adb_device.ps1"
. $lib

$device = Resolve-AdbDevice -DeviceId $DeviceId
$xdripReceiver = "$Package/.statusmonitor.xdrip.XdripBroadcastReceiver"
$jugglucoReceiver = "$Package/.statusmonitor.juggluco.JugglucoBroadcastReceiver"
$aapsReceiver = "$Package/.statusmonitor.aaps.AapsEvidenceReceiver"
$watchReceiver = "$Package/.statusmonitor.watch.WatchEvidenceReceiver"

Invoke-Adb -DeviceId $device -Arguments @(
  "shell",
  "am",
  "broadcast",
  "-a",
  "com.metaguru.smartxdrip.statusmonitor.CLEAR_XDRIP_PROBE",
  "-n",
  $xdripReceiver
) | Out-Null

Invoke-Adb -DeviceId $device -Arguments @(
  "shell",
  "am",
  "broadcast",
  "-a",
  "com.metaguru.smartxdrip.statusmonitor.CLEAR_AAPS_PROBE",
  "-n",
  $aapsReceiver
) | Out-Null

Invoke-Adb -DeviceId $device -Arguments @(
  "shell",
  "am",
  "broadcast",
  "-a",
  "com.metaguru.smartxdrip.statusmonitor.CLEAR_WATCH_PROBE",
  "-n",
  $watchReceiver
) | Out-Null

Invoke-Adb -DeviceId $device -Arguments @(
  "shell",
  "am",
  "broadcast",
  "-a",
  "com.metaguru.smartxdrip.statusmonitor.CLEAR_JUGGLUCO_PROBE",
  "-n",
  $jugglucoReceiver
) | Out-Null

Clear-StatusMonitorBroadcastPrefs -DeviceId $device -Package $Package

[ordered]@{
  device = $device
  package = $Package
  cleared = @(
    "CLEAR_XDRIP_PROBE",
    "CLEAR_JUGGLUCO_PROBE",
    "CLEAR_AAPS_PROBE",
    "CLEAR_WATCH_PROBE",
    "shared_prefs/xdrip_broadcast_status.xml",
    "shared_prefs/juggluco_broadcast_status.xml",
    "shared_prefs/aaps_evidence_status.xml",
    "shared_prefs/watch_evidence_status.xml"
  )
} | ConvertTo-Json -Compress
