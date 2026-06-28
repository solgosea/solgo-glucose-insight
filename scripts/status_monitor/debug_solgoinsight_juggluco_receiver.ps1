param(
  [double]$Glucose = 126,
  [string]$Unit = "mg/dL",
  [ValidateSet("glucodata", "xdripLocal", "patchedLibre", "eversense")]
  [string]$Path = "glucodata",
  [string]$Package = "com.metaguru.smartxdrip"
)

$ErrorActionPreference = "Stop"

Write-Warning @"
This script only verifies the SolgoInsight Juggluco broadcast receiver.
It does NOT simulate a CGM sending data into Juggluco.

For an end-to-end CGM -> Juggluco -> SolgoInsight test, use Juggluco's
official Mirror / command-line Juggluco server path instead.
"@

$timestampMs = [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()
$receiver = "$Package/.statusmonitor.juggluco.JugglucoBroadcastReceiver"

switch ($Path) {
  "glucodata" {
    adb shell am broadcast `
      -a "glucodata.Minute" `
      -n $receiver `
      --el timestamp $timestampMs `
      --ef glucose ([float]$Glucose) `
      --ef glucodata.Minute.mgdl ([float]$Glucose) `
      --es unit $Unit
  }
  "xdripLocal" {
    adb shell am broadcast `
      -a "com.eveningoutpost.dexdrip.BgEstimate" `
      -n $receiver `
      --el com.eveningoutpost.dexdrip.Extras.Time $timestampMs `
      --ef com.eveningoutpost.dexdrip.Extras.BgEstimate ([float]$Glucose)
  }
  "patchedLibre" {
    adb shell am broadcast `
      -a "com.librelink.app.ThirdPartyIntegration.GLUCOSE_READING" `
      -n $receiver `
      --el timestamp $timestampMs `
      --ef glucose ([float]$Glucose) `
      --es bleManager "debug"
  }
  "eversense" {
    $json = "[{`"type`":`"sgv`",`"date`":$timestampMs,`"sgv`":$Glucose}]"
    $cmd = "am broadcast -a com.eveningoutpost.dexdrip.NS_EMULATOR -n $receiver --es collection entries --es data '$json'"
    adb shell $cmd
  }
}

Write-Host "Debug receiver broadcast sent: path=$Path glucose=$Glucose $Unit timestampMs=$timestampMs"
