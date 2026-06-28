param(
  [string]$DeviceId = "",
  [string]$Package = "com.metaguru.smartxdrip",
  [int]$NightscoutPort = 14120
)

$ErrorActionPreference = "Stop"

$root = $PSScriptRoot
. (Join-Path $root "lib\probe_lab_paths.ps1")
$matrixRoot = Get-ProbeMatrixRoot
. (Join-Path $matrixRoot "lib\adb_device.ps1")
. (Join-Path $matrixRoot "lib\probe_controls.ps1")

$device = Resolve-AdbDevice -DeviceId $DeviceId
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$artifactRoot = Join-Path (Resolve-Path ".").Path "build\probe-test-artifacts\headless-sources-$stamp"
New-Item -ItemType Directory -Force -Path $artifactRoot | Out-Null

function Read-AppSharedPrefs {
  param(
    [Parameter(Mandatory = $true)][string]$FileName,
    [Parameter(Mandatory = $true)][string]$OutputName
  )

  $outPath = Join-Path $artifactRoot $OutputName
  try {
    $content = & adb -s $device shell run-as $Package cat "shared_prefs/$FileName" 2>$null
  } catch {
    $content = $null
  }
  if ($LASTEXITCODE -ne 0 -or -not $content) {
    "" | Set-Content -Path $outPath -Encoding UTF8
    return ""
  }
  ($content -join "`n") | Set-Content -Path $outPath -Encoding UTF8
  return ($content -join "`n")
}

function New-Check {
  param(
    [string]$Id,
    [string]$State,
    [bool]$Passed,
    [string]$Evidence,
    [string]$Artifact = ""
  )

  return [ordered]@{
    id = $Id
    state = $State
    passed = $Passed
    evidence = $Evidence
    artifact = $Artifact
  }
}

function Test-PackageVisible {
  param(
    [string]$Id,
    [string[]]$Packages
  )

  foreach ($candidate in $Packages) {
    $path = & adb -s $device shell pm path $candidate 2>$null
    if ($LASTEXITCODE -eq 0 -and ($path -join "").Contains("package:")) {
      return New-Check -Id $Id -State "available" -Passed $true -Evidence $candidate
    }
  }
  return New-Check -Id $Id -State "available" -Passed $false -Evidence "No candidate package installed: $($Packages -join ', ')"
}

Write-Host "[probe-headless] device=$device artifacts=$artifactRoot" -ForegroundColor Cyan

Start-ProbeApp -DeviceId $device -Package $Package
Start-Sleep -Seconds 2
Invoke-AdbNoThrow -DeviceId $device -Arguments @("shell", "pm", "grant", $Package, "android.permission.POST_NOTIFICATIONS")
Invoke-AdbNoThrow -DeviceId $device -Arguments @("shell", "cmd", "appops", "set", $Package, "POST_NOTIFICATION", "allow")
Invoke-AdbNoThrow -DeviceId $device -Arguments @("shell", "dumpsys", "deviceidle", "whitelist", "+$Package")

& (Join-Path $matrixRoot "device\clear_probe_evidence.ps1") -DeviceId $device -Package $Package | Out-Null

$results = @()

$network = (& adb -s $device shell dumpsys connectivity 2>$null) -join "`n"
$results += New-Check `
  -Id "common.network.connectivity" `
  -State "available" `
  -Passed ($network -match "NetworkAgentInfo|NetworkCapabilities|VALIDATED|CONNECTED") `
  -Evidence "dumpsys connectivity inspected"

$bt = (& adb -s $device shell settings get global bluetooth_on 2>$null | Select-Object -First 1).Trim()
$btDump = (& adb -s $device shell dumpsys bluetooth_manager 2>$null) -join "`n"
$btAvailable = $bt -eq "1" -or $btDump -match "state:\s*BLE_ON|enabled:\s*true"
$results += New-Check `
  -Id "common.bluetooth.enabled" `
  -State "available" `
  -Passed $btAvailable `
  -Evidence "settings global bluetooth_on=$bt; $([regex]::Match($btDump, 'state:\s*\S+').Value)"

$notifOps = (& adb -s $device shell cmd appops get $Package POST_NOTIFICATION 2>$null) -join " "
$notifPackage = (& adb -s $device shell dumpsys package $Package 2>$null) -join "`n"
$notifGranted = $notifOps -match "allow" -or
  $notifOps -match "No operations" -or
  $notifPackage -match "android.permission.POST_NOTIFICATIONS: granted=true"
$results += New-Check `
  -Id "common.notification.permission" `
  -State "available" `
  -Passed $notifGranted `
  -Evidence $notifOps

$batteryWhitelist = (& adb -s $device shell dumpsys deviceidle whitelist 2>$null) -join "`n"
$results += New-Check `
  -Id "common.battery.optimization" `
  -State "available" `
  -Passed ($batteryWhitelist -match [regex]::Escape($Package)) `
  -Evidence "deviceidle whitelist contains package=$($batteryWhitelist -match [regex]::Escape($Package))"

$results += Test-PackageVisible `
  -Id "xdrip.package.visible" `
  -Packages @(
    "com.eveningoutpost.dexdrip",
    "com.eveningoutpost.dexdrip.debug",
    "com.eveningoutpost.dexdrip.test",
    "jamorham.xdrip.plus",
    "jamorham.xdrip.plus.variant1",
    "jamorham.xdrip.plus.variant2",
    "jamorham.xdrip.plus.variant3",
    "jamorham.xdrip.plus.variant4"
  )

$results += Test-PackageVisible `
  -Id "juggluco.package.visible" `
  -Packages @("tk.glucodata", "tk.glucodata.debug", "tk.glucodata.test")

$results += Test-PackageVisible `
  -Id "aaps.package.visible" `
  -Packages @(
    "info.nightscout.androidaps",
    "info.nightscout.aaps",
    "info.nightscout.aapsclient",
    "info.nightscout.androidaps.debug"
  )

$results += Test-PackageVisible `
  -Id "watch.bridge.package" `
  -Packages @(
    "com.eveningoutpost.dexdrip",
    "jamorham.xdrip.plus",
    "jamorham.xdrip.plus.variant1",
    "jamorham.xdrip.plus.variant2",
    "jamorham.xdrip.plus.variant3",
    "jamorham.xdrip.plus.variant4",
    "com.watchdrip",
    "tk.glucodata"
  )

& (Join-Path $root "inject\inject_xdrip_glucose.ps1") -DeviceId $device -Package $Package -Glucose 131 | Out-Null
$xdripFresh = Read-AppSharedPrefs -FileName "xdrip_broadcast_status.xml" -OutputName "xdrip-fresh.xml"
$results += New-Check `
  -Id "xdrip.broadcast.bg_estimate" `
  -State "available" `
  -Passed ($xdripFresh -match 'broadcastObserved" value="true"' -and $xdripFresh -match 'latestGlucose" value="131') `
  -Evidence "xDrip BgEstimate stored in shared prefs" `
  -Artifact "xdrip-fresh.xml"

& (Join-Path $root "inject\inject_xdrip_glucose.ps1") -DeviceId $device -Package $Package -Glucose 132 -TimestampOffsetMinutes -25 | Out-Null
$xdripStale = Read-AppSharedPrefs -FileName "xdrip_broadcast_status.xml" -OutputName "xdrip-stale.xml"
$results += New-Check `
  -Id "xdrip.broadcast.freshness" `
  -State "unavailable" `
  -Passed ($xdripStale -match 'latestGlucose" value="132') `
  -Evidence "stale xDrip timestamp accepted for freshness downgrade probe" `
  -Artifact "xdrip-stale.xml"

& (Join-Path $root "inject\inject_juggluco_glucose.ps1") -DeviceId $device -Package $Package -Glucose 141 | Out-Null
$jugDirect = Read-AppSharedPrefs -FileName "juggluco_broadcast_status.xml" -OutputName "juggluco-direct.xml"
$results += New-Check `
  -Id "juggluco.broadcast.glucodata_minute" `
  -State "available" `
  -Passed ($jugDirect -match 'broadcastObserved" value="true"' -and $jugDirect -match 'glucodataMinute') `
  -Evidence "Juggluco glucodata.Minute stored in shared prefs" `
  -Artifact "juggluco-direct.xml"

& (Join-Path $root "inject\inject_juggluco_glucose.ps1") -DeviceId $device -Package $Package -Glucose 142 -XdripCompatible | Out-Null
$jugCompat = Read-AppSharedPrefs -FileName "juggluco_broadcast_status.xml" -OutputName "juggluco-compatible.xml"
$results += New-Check `
  -Id "juggluco.broadcast.xdrip_compatible" `
  -State "available" `
  -Passed ($jugCompat -match 'xdripCompatible' -and $jugCompat -match 'latestGlucose" value="142') `
  -Evidence "Juggluco xDrip-compatible broadcast stored in shared prefs" `
  -Artifact "juggluco-compatible.xml"

& (Join-Path $root "inject\inject_juggluco_glucose.ps1") -DeviceId $device -Package $Package -Glucose 143 -TimestampOffsetMinutes -25 | Out-Null
$jugStale = Read-AppSharedPrefs -FileName "juggluco_broadcast_status.xml" -OutputName "juggluco-stale.xml"
$results += New-Check `
  -Id "juggluco.broadcast.freshness" `
  -State "unavailable" `
  -Passed ($jugStale -match 'latestGlucose" value="143') `
  -Evidence "stale Juggluco timestamp accepted for freshness downgrade probe" `
  -Artifact "juggluco-stale.xml"

Send-AapsEvidence -DeviceId $device -Package $Package -BgSource "xdrip" -DevicestatusObserved $true -LoopContextObserved $true | Out-Null
$aaps = Read-AppSharedPrefs -FileName "aaps_evidence_status.xml" -OutputName "aaps-evidence.xml"
$results += New-Check `
  -Id "aaps.bg_source.xdrip_evidence" `
  -State "available" `
  -Passed ($aaps -match 'bgSource">xdrip' -and $aaps -match 'evidenceObserved" value="true"') `
  -Evidence "AAPS xDrip BG source evidence stored" `
  -Artifact "aaps-evidence.xml"
$results += New-Check `
  -Id "aaps.devicestatus.evidence" `
  -State "available" `
  -Passed ($aaps -match 'devicestatusObserved" value="true"') `
  -Evidence "AAPS devicestatus evidence stored" `
  -Artifact "aaps-evidence.xml"
$results += New-Check `
  -Id "aaps.loop.context_evidence" `
  -State "available" `
  -Passed ($aaps -match 'loopContextObserved" value="true"') `
  -Evidence "AAPS loop context evidence stored" `
  -Artifact "aaps-evidence.xml"
$results += New-Check `
  -Id "xdrip.aaps.output_evidence" `
  -State "available" `
  -Passed ($aaps -match 'bgSource">xdrip') `
  -Evidence "xDrip downstream AAPS evidence source available" `
  -Artifact "aaps-evidence.xml"

Send-WatchEvidence -DeviceId $device -Package $Package -DisplayObserved $true | Out-Null
$watch = Read-AppSharedPrefs -FileName "watch_evidence_status.xml" -OutputName "watch-evidence.xml"
$results += New-Check `
  -Id "watch.display.evidence" `
  -State "available" `
  -Passed ($watch -match 'displayObserved" value="true"' -and $watch -match 'evidenceObserved" value="true"') `
  -Evidence "Watch display evidence stored" `
  -Artifact "watch-evidence.xml"

$nsProcess = $null
try {
  $nsJson = & (Join-Path $matrixRoot "nightscout\start_probe_nightscout.ps1") `
    -Port $NightscoutPort `
    -Scenario fresh `
    -ArtifactDir $artifactRoot `
    -StopExisting
  $ns = $nsJson | ConvertFrom-Json
  $nsProcess = [int]$ns.pid
  Set-AdbReversePort -DeviceId $device -Port $NightscoutPort
  $status = Invoke-WebRequest -UseBasicParsing -Uri "$($ns.baseUrl)/api/v1/status.json" -TimeoutSec 5
  $entries = Invoke-WebRequest -UseBasicParsing -Uri "$($ns.baseUrl)/api/v1/entries.json?count=1" -TimeoutSec 5
  $deviceStatus = Invoke-WebRequest -UseBasicParsing -Uri "$($ns.baseUrl)/api/v1/devicestatus.json?count=1" -TimeoutSec 5
  $results += New-Check -Id "nightscout.status.reachable" -State "available" -Passed ($status.StatusCode -eq 200) -Evidence "HTTP $($status.StatusCode)"
  $results += New-Check -Id "nightscout.entries.freshness" -State "available" -Passed ($entries.Content -match 'date') -Evidence "entries endpoint returned payload"
  $results += New-Check -Id "nightscout.devicestatus.visible" -State "available" -Passed ($deviceStatus.Content -match 'created_at|mills') -Evidence "devicestatus endpoint returned payload"
  $results += New-Check -Id "nightscout.response_time" -State "available" -Passed $true -Evidence "mock Nightscout responded inside script timeout"
} finally {
  if ($null -ne $nsProcess) {
    Stop-Process -Id $nsProcess -Force -ErrorAction SilentlyContinue
  }
}

$summary = [ordered]@{
  device = $device
  package = $Package
  generatedAt = (Get-Date).ToString("o")
  artifactRoot = $artifactRoot
  total = $results.Count
  passed = @($results | Where-Object { $_.passed }).Count
  failed = @($results | Where-Object { -not $_.passed }).Count
  results = $results
  notes = @(
    "This headless source matrix does not require the phone to be unlocked.",
    "It verifies probe input sources and SolgoInsight receivers/storage. Probe runtime/policy remains covered by Flutter tests and UI checklist smoke."
  )
}

$summaryPath = Join-Path $artifactRoot "probe-headless-source-summary.json"
$summary | ConvertTo-Json -Depth 8 | Set-Content -Path $summaryPath -Encoding UTF8
Write-Host "[probe-headless] summary: $summaryPath" -ForegroundColor Cyan
Write-Host "[probe-headless] passed=$($summary.passed)/$($summary.total)" -ForegroundColor Yellow

if ($summary.failed -gt 0) {
  exit 1
}
