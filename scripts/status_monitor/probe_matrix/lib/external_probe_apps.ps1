$ErrorActionPreference = "Stop"

function Get-ExternalProbeRepoRoot {
  $candidate = Join-Path (Resolve-Path ".").Path "..\agent_diabetes-hackathon\_external"
  if (Test-Path $candidate) {
    return (Resolve-Path $candidate).Path
  }

  $fromScript = Join-Path $PSScriptRoot "..\..\..\..\..\agent_diabetes-hackathon\_external"
  if (Test-Path $fromScript) {
    return (Resolve-Path $fromScript).Path
  }

  return "K:\Codes\metaguru-health-appcloud\agent_diabetes-hackathon\_external"
}

function Get-ExternalProbeApps {
  param([string]$ExternalRoot = "")

  if (-not $ExternalRoot) {
    $ExternalRoot = Get-ExternalProbeRepoRoot
  }

  return @(
    [ordered]@{
      id = "xdrip"
      displayName = "xDrip+"
      root = Join-Path $ExternalRoot "xDrip"
      gradle = "gradlew.bat"
      buildTask = ":app:assembleDebug"
      packageCandidates = @(
        "com.eveningoutpost.dexdrip",
        "jamorham.xdrip.plus",
        "jamorham.xdrip.plus.variant1",
        "jamorham.xdrip.plus.variant2",
        "jamorham.xdrip.plus.variant3",
        "jamorham.xdrip.plus.variant4"
      )
      apkGlobs = @(
        "app\build\outputs\apk\debug\*.apk",
        "app\build\outputs\apk\full\debug\*.apk",
        "app\build\outputs\apk\prod\debug\*.apk",
        "app\build\outputs\apk\fast\debug\*.apk"
      )
    },
    [ordered]@{
      id = "juggluco"
      displayName = "Juggluco"
      root = Join-Path $ExternalRoot "Juggluco"
      gradle = "gradlew.bat"
      buildTask = ":Common:assembleDebug"
      packageCandidates = @("tk.glucodata", "tk.glucodata.debug", "tk.glucodata.dub")
      apkGlobs = @("Common\build\outputs\apk\**\*.apk")
    },
    [ordered]@{
      id = "aaps"
      displayName = "AAPS"
      root = Join-Path $ExternalRoot "AndroidAPS"
      gradle = "gradlew.bat"
      buildTask = ":app:assembleFullDebug"
      packageCandidates = @(
        "info.nightscout.androidaps",
        "info.nightscout.aapspumpcontrol",
        "info.nightscout.aapsclient",
        "info.nightscout.aapsclient2"
      )
      apkGlobs = @("app\build\outputs\apk\**\*.apk")
    },
    [ordered]@{
      id = "watch"
      displayName = "Watchdrip"
      root = Join-Path $ExternalRoot "watchdrip"
      gradle = "gradlew.bat"
      buildTask = ":app:assembleDebug"
      packageCandidates = @(
        "com.thatguysservice.huami_xdrip",
        "com.thatguysservice.watchdrip",
        "com.thatguysservice.watchdripplus"
      )
      apkGlobs = @("app\build\outputs\apk\debug\*.apk")
    }
  )
}

function Get-ExternalProbeApp {
  param(
    [Parameter(Mandatory = $true)][string]$AppId,
    [string]$ExternalRoot = ""
  )

  $apps = Get-ExternalProbeApps -ExternalRoot $ExternalRoot
  foreach ($app in $apps) {
    if ($app.id -eq $AppId) {
      return $app
    }
  }
  throw "Unknown external probe app '$AppId'. Valid ids: $((($apps | ForEach-Object { $_.id }) -join ', '))"
}

function Test-AdbPackageInstalled {
  param(
    [Parameter(Mandatory = $true)][string]$DeviceId,
    [Parameter(Mandatory = $true)][string]$PackageName
  )

  $result = & adb -s $DeviceId shell pm list packages $PackageName 2>$null
  if ($LASTEXITCODE -ne 0) {
    return $false
  }
  return ($result -join "`n").Contains("package:$PackageName")
}

function Get-InstalledExternalProbePackage {
  param(
    [Parameter(Mandatory = $true)][string]$DeviceId,
    [Parameter(Mandatory = $true)]$App
  )

  foreach ($packageName in $App.packageCandidates) {
    if (Test-AdbPackageInstalled -DeviceId $DeviceId -PackageName $packageName) {
      return $packageName
    }
  }
  return $null
}

function Get-ExternalProbeApks {
  param([Parameter(Mandatory = $true)]$App)

  $files = @()
  foreach ($glob in $App.apkGlobs) {
    $files += Get-ChildItem -Path (Join-Path $App.root $glob) -File -ErrorAction SilentlyContinue
  }
  return @($files | Sort-Object LastWriteTime -Descending)
}

function Build-ExternalProbeApp {
  param([Parameter(Mandatory = $true)]$App)

  if (-not (Test-Path $App.root)) {
    throw "$($App.displayName) source folder does not exist: $($App.root)"
  }
  $gradle = Join-Path $App.root $App.gradle
  if (-not (Test-Path $gradle)) {
    throw "$($App.displayName) Gradle wrapper does not exist: $gradle"
  }

  Push-Location $App.root
  try {
    & $gradle $App.buildTask
    if ($LASTEXITCODE -ne 0) {
      throw "$($App.displayName) build failed with exit code $LASTEXITCODE"
    }
  } finally {
    Pop-Location
  }

  $apks = Get-ExternalProbeApks -App $App
  if (-not $apks) {
    throw "$($App.displayName) build completed but no APK matched configured globs."
  }
  return $apks[0].FullName
}

function Install-ExternalProbeApp {
  param(
    [Parameter(Mandatory = $true)][string]$DeviceId,
    [Parameter(Mandatory = $true)]$App,
    [switch]$Build
  )

  $apk = $null
  if ($Build) {
    $apk = Build-ExternalProbeApp -App $App
  } else {
    $apks = Get-ExternalProbeApks -App $App
    if ($apks) {
      $apk = $apks[0].FullName
    }
  }
  if (-not $apk) {
    throw "No APK found for $($App.displayName). Re-run with -Build to compile it."
  }

  & adb -s $DeviceId install -r $apk
  if ($LASTEXITCODE -ne 0) {
    throw "Failed to install $($App.displayName) APK: $apk"
  }
  return [ordered]@{
    id = $App.id
    displayName = $App.displayName
    apk = $apk
    installedPackage = Get-InstalledExternalProbePackage -DeviceId $DeviceId -App $App
  }
}

function Uninstall-ExternalProbeApp {
  param(
    [Parameter(Mandatory = $true)][string]$DeviceId,
    [Parameter(Mandatory = $true)]$App
  )

  $results = @()
  foreach ($packageName in $App.packageCandidates) {
    if (Test-AdbPackageInstalled -DeviceId $DeviceId -PackageName $packageName) {
      & adb -s $DeviceId uninstall $packageName | Out-Null
      $results += [ordered]@{
        packageName = $packageName
        uninstalled = ($LASTEXITCODE -eq 0)
      }
    }
  }
  return $results
}
