param(
  [string]$DeviceId = "",
  [string]$Package = "com.metaguru.smartxdrip",
  [string[]]$AppIds = @("xdrip", "juggluco", "aaps", "watch"),
  [string]$ExternalRoot = "",
  [switch]$BuildExternalApps,
  [switch]$UseControlledFixturesForJugglucoAaps
)

$ErrorActionPreference = "Stop"

$root = Split-Path $PSScriptRoot -Parent
$repoRoot = (Resolve-Path (Join-Path $root "..\..\..")).Path
. (Join-Path $root "lib\adb_device.ps1")
. (Join-Path $root "lib\external_probe_apps.ps1")
. (Join-Path $root "lib\probe_controls.ps1")

$device = Resolve-AdbDevice -DeviceId $DeviceId
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$artifactRoot = Join-Path (Resolve-Path ".").Path "build\probe-test-artifacts\external-apps-$stamp"
New-Item -ItemType Directory -Force -Path $artifactRoot | Out-Null

function Invoke-ExternalAdb {
  param([Parameter(Mandatory = $true)][string[]]$Arguments)
  & adb -s $device @Arguments
  if ($LASTEXITCODE -ne 0) {
    throw "adb command failed: adb -s $device $($Arguments -join ' ')"
  }
}

function Install-ControlledFixtureApps {
  param([string[]]$Ids)

  $fixtureRoot = Join-Path $root "fixture_apps"
  $tasks = @()
  if ($Ids -contains "juggluco") {
    $tasks += ":jugglucoFixture:assembleDebug"
  }
  if ($Ids -contains "aaps") {
    $tasks += ":aapsFixture:assembleDebug"
  }
  if (-not $tasks) {
    return @()
  }

  $gradle = Join-Path $repoRoot "android\gradlew.bat"
  & $gradle -p $fixtureRoot @tasks --console=plain
  if ($LASTEXITCODE -ne 0) {
    throw "Controlled fixture build failed."
  }

  $installed = @()
  if ($Ids -contains "juggluco") {
    & adb -s $device uninstall tk.glucodata 2>$null | Out-Null
    $apk = Join-Path $fixtureRoot "jugglucoFixture\build\outputs\apk\debug\jugglucoFixture-debug.apk"
    Invoke-ExternalAdb -Arguments @("install", "-r", $apk)
    Invoke-ExternalAdb -Arguments @("shell", "monkey", "-p", "tk.glucodata", "1")
    $installed += [ordered]@{
      id = "juggluco"
      displayName = "Juggluco controlled fixture"
      packageName = "tk.glucodata"
      apk = $apk
      mode = "controlled-fixture"
    }
  }
  if ($Ids -contains "aaps") {
    & adb -s $device uninstall info.nightscout.aapsclient 2>$null | Out-Null
    $apk = Join-Path $fixtureRoot "aapsFixture\build\outputs\apk\debug\aapsFixture-debug.apk"
    Invoke-ExternalAdb -Arguments @("install", "-r", $apk)
    Invoke-ExternalAdb -Arguments @("shell", "monkey", "-p", "info.nightscout.aapsclient", "1")
    $installed += [ordered]@{
      id = "aaps"
      displayName = "AAPS controlled fixture"
      packageName = "info.nightscout.aapsclient"
      apk = $apk
      mode = "controlled-fixture"
    }
  }
  return $installed
}

function Read-AppSharedPrefs {
  param([Parameter(Mandatory = $true)][string]$FileName)
  $content = & adb -s $device shell run-as $Package cat "shared_prefs/$FileName" 2>$null
  if ($LASTEXITCODE -ne 0) {
    return ""
  }
  return ($content -join "`n")
}

function Test-XmlContains {
  param(
    [Parameter(Mandatory = $true)][string]$FileName,
    [Parameter(Mandatory = $true)][string]$Pattern
  )
  $xml = Read-AppSharedPrefs -FileName $FileName
  return [ordered]@{
    file = $FileName
    pattern = $Pattern
    matched = $xml.Contains($Pattern)
    xml = $xml
  }
}

function Test-ExternalPackageVisible {
  param([Parameter(Mandatory = $true)][string]$ProbeId)
  . (Join-Path $root "lib\external_probe_apps.ps1")
  $appId = switch -Regex ($ProbeId) {
    "^xdrip\." { "xdrip"; break }
    "^juggluco\." { "juggluco"; break }
    "^aaps\." { "aaps"; break }
    "^watch\." { "watch"; break }
    default { $null }
  }
  if (-not $appId) {
    return [ordered]@{ controlled = $false; reason = "No package mapping"; probeId = $ProbeId }
  }
  $app = Get-ExternalProbeApp -AppId $appId -ExternalRoot $ExternalRoot
  $installed = Get-InstalledExternalProbePackage -DeviceId $device -App $app
  return [ordered]@{
    controlled = [bool]$installed
    probeId = $ProbeId
    state = "available"
    control = "external-package"
    installedPackage = $installed
    packageCandidates = $app.packageCandidates
  }
}

$resolvedAppIds = @()
foreach ($item in $AppIds) {
  $resolvedAppIds += ($item -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ })
}

Write-Host "[external-validation] device=$device artifacts=$artifactRoot apps=$($resolvedAppIds -join ',')" -ForegroundColor Cyan

$installResults = @()
$fixtureIds = @()
foreach ($appId in $resolvedAppIds) {
  if (($appId -eq "juggluco" -or $appId -eq "aaps") -and $UseControlledFixturesForJugglucoAaps) {
    $fixtureIds += $appId
    continue
  }

  try {
    $app = Get-ExternalProbeApp -AppId $appId -ExternalRoot $ExternalRoot
    $installResults += Install-ExternalProbeApp -DeviceId $device -App $app -Build:$BuildExternalApps
  } catch {
    $installResults += [ordered]@{
      id = $appId
      installedPackage = $null
      mode = "real-external-app"
      error = $_.Exception.Message
    }
    if (($appId -eq "juggluco" -or $appId -eq "aaps") -and -not $UseControlledFixturesForJugglucoAaps) {
      throw
    }
  }
}

if ($fixtureIds.Count -gt 0) {
  $installResults += Install-ControlledFixtureApps -Ids $fixtureIds
}

Invoke-ExternalAdb -Arguments @("shell", "monkey", "-p", $Package, "1")
Start-Sleep -Seconds 2
Invoke-ExternalAdb -Arguments @("shell", "run-as", $Package, "rm", "-f",
  "shared_prefs/xdrip_broadcast_status.xml",
  "shared_prefs/juggluco_broadcast_status.xml",
  "shared_prefs/aaps_evidence_status.xml",
  "shared_prefs/watch_evidence_status.xml"
)

$probeCases = @(
  @{ id = "xdrip.package.visible"; file = ""; expect = "" },
  @{ id = "xdrip.broadcast.bg_estimate"; file = "xdrip_broadcast_status.xml"; expect = 'broadcastObserved" value="true' },
  @{ id = "xdrip.broadcast.freshness"; file = "xdrip_broadcast_status.xml"; expect = "latestBroadcastAtMs" },
  @{ id = "xdrip.aaps.output_evidence"; file = "aaps_evidence_status.xml"; expect = 'bgSource">xdrip' },
  @{ id = "juggluco.package.visible"; file = ""; expect = "" },
  @{ id = "juggluco.broadcast.glucodata_minute"; file = "juggluco_broadcast_status.xml"; expect = "glucodata" },
  @{ id = "juggluco.broadcast.xdrip_compatible"; file = "juggluco_broadcast_status.xml"; expect = "xdripLocal" },
  @{ id = "juggluco.broadcast.freshness"; file = "juggluco_broadcast_status.xml"; expect = "latestBroadcastAtMs" },
  @{ id = "aaps.package.visible"; file = ""; expect = "" },
  @{ id = "aaps.bg_source.xdrip_evidence"; file = "aaps_evidence_status.xml"; expect = 'bgSource">xdrip' },
  @{ id = "aaps.devicestatus.evidence"; file = "aaps_evidence_status.xml"; expect = 'devicestatusObserved" value="true' },
  @{ id = "aaps.loop.context_evidence"; file = "aaps_evidence_status.xml"; expect = 'loopContextObserved" value="true' },
  @{ id = "watch.bridge.package"; file = ""; expect = "" },
  @{ id = "watch.display.evidence"; file = "watch_evidence_status.xml"; expect = 'displayObserved" value="true' }
)

$results = @()
foreach ($case in $probeCases) {
  Write-Host "[external-validation] $($case.id)" -ForegroundColor Yellow
  $caseDir = Join-Path $artifactRoot (($case.id -replace '[^A-Za-z0-9_.-]', '_'))
  New-Item -ItemType Directory -Force -Path $caseDir | Out-Null
  $control = if ($case.id.EndsWith(".package.visible") -or $case.id.EndsWith(".bridge.package")) {
    Test-ExternalPackageVisible -ProbeId $case.id
  } else {
    Set-ProbeControlledState `
      -ProbeId $case.id `
      -State available `
      -DeviceId $device `
      -Package $Package `
      -Root $root `
      -ArtifactDir $caseDir `
      -EnableExternalAppControl `
      -ExternalRoot $ExternalRoot
  }
  $check = $null
  if ($case.file) {
    Start-Sleep -Milliseconds 800
    $check = Test-XmlContains -FileName $case.file -Pattern $case.expect
  }
  $passed = if ($case.file) {
    [bool]$check.matched
  } else {
    [bool]$control.controlled
  }
  $results += [ordered]@{
    probeId = $case.id
    passed = $passed
    control = $control
    evidenceCheck = $check
  }
}

$summary = [ordered]@{
  device = $device
  package = $Package
  generatedAt = (Get-Date).ToString("o")
  artifactRoot = $artifactRoot
  externalRoot = $(if ($ExternalRoot) { $ExternalRoot } else { Get-ExternalProbeRepoRoot })
  useControlledFixturesForJugglucoAaps = [bool]$UseControlledFixturesForJugglucoAaps
  installedApps = $installResults
  total = $results.Count
  passed = @($results | Where-Object { $_.passed }).Count
  results = $results
}

$summaryPath = Join-Path $artifactRoot "external-probe-app-validation-summary.json"
$summary | ConvertTo-Json -Depth 12 | Set-Content -Path $summaryPath -Encoding UTF8
Write-Host "[external-validation] passed=$($summary.passed)/$($summary.total)" -ForegroundColor Green
Write-Host "[external-validation] summary: $summaryPath" -ForegroundColor Cyan
