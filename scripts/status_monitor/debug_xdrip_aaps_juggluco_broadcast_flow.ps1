param(
  [string]$Package = "com.metaguru.smartxdrip",
  [int]$Count = 6,
  [int]$IntervalSeconds = 5,
  [double]$StartGlucose = 118,
  [int]$Jitter = 5,
  [ValidateSet("all", "xdripCompatible", "jugglucoDirect")]
  [string]$Mode = "all",
  [switch]$Continuous,
  [switch]$ClearPrefs,
  [switch]$ForceStopForCleanState
)

$ErrorActionPreference = "Stop"

$xdripReceiver = "$Package/.statusmonitor.xdrip.XdripBroadcastReceiver"
$jugglucoReceiver = "$Package/.statusmonitor.juggluco.JugglucoBroadcastReceiver"
$random = [System.Random]::new()

function Assert-AdbDevice {
  $devices = adb devices | Select-String "`tdevice$"
  if (-not $devices) {
    throw "No adb device is connected. Connect a phone first, then rerun this script."
  }
}

function Clear-StatusPrefs {
  Write-Host "Clearing debug receiver shared preferences..." -ForegroundColor DarkGray
  if ($ForceStopForCleanState) {
    Write-Host "Force-stopping app for a clean SharedPreferences state." -ForegroundColor DarkGray
    adb shell am force-stop $Package | Out-Null
    Start-Sleep -Milliseconds 400
  } else {
    Write-Host "Not force-stopping the app. Live SharedPreferences cache may keep older timeline rows." -ForegroundColor DarkGray
  }
  adb shell run-as $Package rm -f "shared_prefs/xdrip_broadcast_status.xml" | Out-Null
  adb shell run-as $Package rm -f "shared_prefs/juggluco_broadcast_status.xml" | Out-Null
}

function Send-XdripCompatibleBroadcast([double]$glucose, [int64]$timestampMs, [string]$slopeName, [double]$slope) {
  $glucoseText = [string]::Format([Globalization.CultureInfo]::InvariantCulture, "{0:0.0}", $glucose)
  $slopeText = [string]::Format([Globalization.CultureInfo]::InvariantCulture, "{0:0.0}", $slope)

  Write-Host "  -> xDrip receiver BgEstimate glucose=$glucoseText slope=$slopeName" -ForegroundColor Cyan
  adb shell am broadcast `
    -a "com.eveningoutpost.dexdrip.BgEstimate" `
    -n $xdripReceiver `
    --el timestamp $timestampMs `
    --ef glucose $glucoseText `
    --es units "mg/dL" `
    --es slopeName $slopeName `
    --ef slope $slopeText | Out-Null

  Write-Host "  -> Juggluco receiver xDrip-compatible BgEstimate glucose=$glucoseText" -ForegroundColor Cyan
  adb shell am broadcast `
    -a "com.eveningoutpost.dexdrip.BgEstimate" `
    -n $jugglucoReceiver `
    --el "com.eveningoutpost.dexdrip.Extras.Time" $timestampMs `
    --ef "com.eveningoutpost.dexdrip.Extras.BgEstimate" $glucoseText `
    --el timestamp $timestampMs `
    --ef glucose $glucoseText | Out-Null
}

function Send-JugglucoDirectBroadcast([double]$glucose, [int64]$timestampMs) {
  $glucoseText = [string]::Format([Globalization.CultureInfo]::InvariantCulture, "{0:0.0}", $glucose)
  Write-Host "  -> Juggluco receiver glucodata.Minute glucose=$glucoseText" -ForegroundColor Magenta
  adb shell am broadcast `
    -a "glucodata.Minute" `
    -n $jugglucoReceiver `
    --el timestamp $timestampMs `
    --ef glucose $glucoseText `
    --ef "glucodata.Minute.mgdl" $glucoseText `
    --es unit "mg/dL" | Out-Null
}

function Dump-Prefs([string]$name) {
  Write-Host ""
  Write-Host "==== $name ====" -ForegroundColor Yellow
  adb shell run-as $Package cat "shared_prefs/$name.xml"
}

function Base-GlucoseForStep([int]$step, [double]$baseline) {
  $phase = $step % 48
  if ($phase -lt 6) {
    # Stable starting range.
    return $baseline + ($phase * 0.8)
  }
  if ($phase -lt 14) {
    # Meal/stress rise.
    return $baseline + 6 + (($phase - 6) * 9.5)
  }
  if ($phase -lt 20) {
    # High plateau with gentle drift.
    return 185 - (($phase - 14) * 1.8)
  }
  if ($phase -lt 30) {
    # Correction / activity fall.
    return 176 - (($phase - 20) * 11)
  }
  if ($phase -lt 36) {
    # Low pocket.
    return 68 - (($phase - 30) * 1.7)
  }
  if ($phase -lt 44) {
    # Recovery.
    return 62 + (($phase - 36) * 8)
  }
  # Back to baseline.
  return 126 - (($phase - 44) * 4.5)
}

function Get-TrendName([double]$delta) {
  if ($delta -ge 18) { return "DoubleUp" }
  if ($delta -ge 10) { return "SingleUp" }
  if ($delta -ge 4) { return "FortyFiveUp" }
  if ($delta -le -18) { return "DoubleDown" }
  if ($delta -le -10) { return "SingleDown" }
  if ($delta -le -4) { return "FortyFiveDown" }
  return "Flat"
}

function Get-SimulatedReading([int]$step, [int64]$timestampMs) {
  $minuteBucket = [int]([Math]::Floor($timestampMs / 60000) % 8)
  $withinMinuteStep = [int]([Math]::Floor(($timestampMs % 60000) / 6000))
  $profiles = @(
    @{ glucose = 95.0; trend = "Flat"; slope = 0.0; label = "in-range stable" },
    @{ glucose = 140.0; trend = "SingleUp"; slope = 2.0; label = "rising" },
    @{ glucose = 185.0; trend = "DoubleUp"; slope = 3.4; label = "high rising" },
    @{ glucose = 158.0; trend = "FortyFiveDown"; slope = -1.1; label = "high falling" },
    @{ glucose = 72.0; trend = "SingleDown"; slope = -2.4; label = "near low falling" },
    @{ glucose = 61.0; trend = "Flat"; slope = 0.0; label = "low stable" },
    @{ glucose = 104.0; trend = "SingleUp"; slope = 2.1; label = "recovery" },
    @{ glucose = 126.0; trend = "Flat"; slope = 0.0; label = "back to range" }
  )
  $profile = $profiles[$minuteBucket]
  $base = [double]$profile.glucose
  $microDrift = ($withinMinuteStep - 4) * 1.4
  $noise = if ($Jitter -gt 0) { $random.Next(-1 * $Jitter, $Jitter + 1) } else { 0 }
  $glucose = [Math]::Round([Math]::Max(48, [Math]::Min(220, $base + $microDrift + $noise)), 1)
  $slopeName = [string]$profile.trend
  $slope = [double]$profile.slope
  return @{
    glucose = $glucose
    slopeName = $slopeName
    slope = $slope
    phase = $minuteBucket
    label = $profile.label
  }
}

Assert-AdbDevice

Write-Warning @"
This script verifies SolgoInsight receivers by sending Android broadcasts with adb.
It is useful for checking:
  xDrip+ local broadcast receiver
  Juggluco xDrip-compatible receiver path
  Juggluco direct glucodata receiver path

It does NOT prove a real CGM -> Juggluco -> xDrip+ chain is configured.
AAPS health also needs Nightscout devicestatus/openaps context in addition to the xDrip+ broadcast.
"@

if ($ClearPrefs) {
  Clear-StatusPrefs
}

$i = 0
while ($Continuous -or $i -lt $Count) {
  $timestampMs = [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()
  $reading = Get-SimulatedReading -step $i -timestampMs $timestampMs
  $glucose = $reading.glucose
  $slopeName = $reading.slopeName
  $slope = $reading.slope

  Write-Host ""
  $progressLabel = if ($Continuous) { "continuous #$($i + 1)" } else { "$($i + 1)/$Count" }
  Write-Host "[$progressLabel] minuteBucket=$($reading.phase) $($reading.label) timestampMs=$timestampMs" -ForegroundColor Green
  if ($Mode -eq "all" -or $Mode -eq "xdripCompatible") {
    Send-XdripCompatibleBroadcast -glucose $glucose -timestampMs $timestampMs -slopeName $slopeName -slope $slope
  }
  if ($Mode -eq "all" -or $Mode -eq "jugglucoDirect") {
    Send-JugglucoDirectBroadcast -glucose ($glucose + 3) -timestampMs $timestampMs
  }
  $i++
  if ($Continuous -or $i -lt $Count) {
    Start-Sleep -Seconds $IntervalSeconds
  }
}

Start-Sleep -Milliseconds 600
Dump-Prefs "xdrip_broadcast_status"
Dump-Prefs "juggluco_broadcast_status"

Write-Host ""
Write-Host "Open Status Monitor -> xDrip+ and Juggluco. Expected: latest broadcast is fresh." -ForegroundColor Green
Write-Host "Open Status Monitor -> AAPS Loop after Nightscout has OpenAPS/devicestatus context. Expected: xDrip+ BG source improves." -ForegroundColor Green
