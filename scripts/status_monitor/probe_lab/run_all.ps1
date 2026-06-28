param(
  [string]$DeviceId = "",
  [string]$Package = "com.metaguru.smartxdrip",
  [int]$NightscoutPort = 14120,
  [string]$ExternalRoot = "",
  [switch]$InstallExternalApps,
  [switch]$BuildExternalApps,
  [switch]$AllowSystemMutation,
  [switch]$EnableExternalAppControl
)

$ErrorActionPreference = "Stop"
$root = $PSScriptRoot
. (Join-Path $root "lib\probe_lab_paths.ps1")
. (Join-Path $root "lib\probe_lab_summary.ps1")
$matrixRoot = Get-ProbeMatrixRoot
. (Join-Path $matrixRoot "lib\adb_device.ps1")
. (Join-Path $matrixRoot "lib\probe_assertions.ps1")
. (Join-Path $matrixRoot "lib\probe_inventory.ps1")

$device = Resolve-AdbDevice -DeviceId $DeviceId
$artifactRoot = Get-ProbeLabArtifactRoot -Name "all"
$steps = New-Object System.Collections.ArrayList

Write-Host "[probe-lab] device=$device artifacts=$artifactRoot" -ForegroundColor Cyan

Add-ProbeLabStep -Steps $steps -Name "grant-runtime-permissions" -Action {
  & (Join-Path (Get-ProbeMatrixRoot) "device\grant_probe_runtime_permissions.ps1") -DeviceId $device -Package $Package
}

Add-ProbeLabStep -Steps $steps -Name "clear-passive-evidence" -Action {
  & (Join-Path (Get-ProbeMatrixRoot) "device\clear_probe_evidence.ps1") -DeviceId $device -Package $Package
}

Add-ProbeLabStep -Steps $steps -Name "start-nightscout-fresh" -Action {
  & (Join-Path $root "nightscout\start_nightscout.ps1") `
    -Port $NightscoutPort `
    -Scenario fresh `
    -ArtifactDir $artifactRoot `
    -StopExisting
}

Add-ProbeLabStep -Steps $steps -Name "adb-reverse-nightscout" -Action {
  Set-AdbReversePort -DeviceId $device -Port $NightscoutPort
  [ordered]@{ port = $NightscoutPort }
}

if ($InstallExternalApps) {
  Add-ProbeLabStep -Steps $steps -Name "install-external-apps" -Action {
    & (Join-Path $root "install\install_external_apps.ps1") `
      -DeviceId $device `
      -ExternalRoot $ExternalRoot `
      -Build:$BuildExternalApps
  }
}

Add-ProbeLabStep -Steps $steps -Name "inject-xdrip-bg" -Action {
  & (Join-Path $root "inject\inject_xdrip_glucose.ps1") `
    -DeviceId $device `
    -Package $Package `
    -Glucose 118 `
    -SlopeName Flat
}

Add-ProbeLabStep -Steps $steps -Name "inject-juggluco-direct" -Action {
  & (Join-Path $root "inject\inject_juggluco_glucose.ps1") `
    -DeviceId $device `
    -Package $Package `
    -Glucose 121
}

Add-ProbeLabStep -Steps $steps -Name "inject-juggluco-xdrip-compatible" -Action {
  & (Join-Path $root "inject\inject_juggluco_glucose.ps1") `
    -DeviceId $device `
    -Package $Package `
    -Glucose 124 `
    -XdripCompatible
}

Add-ProbeLabStep -Steps $steps -Name "run-single-probe-core-matrix" -Action {
  & (Join-Path $root "run_single_probe.ps1") `
    -DeviceId $device `
    -Package $Package `
    -NightscoutPort $NightscoutPort `
    -ProbeIds @(
      "xdrip.broadcast.bg_estimate",
      "xdrip.broadcast.freshness",
      "juggluco.broadcast.glucodata_minute",
      "juggluco.broadcast.xdrip_compatible",
      "juggluco.broadcast.freshness",
      "nightscout.status.reachable",
      "nightscout.entries.freshness",
      "nightscout.devicestatus.visible",
      "nightscout.response_time"
    )
}

Add-ProbeLabStep -Steps $steps -Name "run-suite-core-matrix" -Action {
  & (Join-Path $root "run_suite.ps1") `
    -DeviceId $device `
    -Package $Package `
    -NightscoutPort $NightscoutPort `
    -Suites @("xdrip", "juggluco", "nightscout")
}

Add-ProbeLabStep -Steps $steps -Name "run-full-chain" -Action {
  & (Join-Path $root "run_full_chain.ps1") `
    -DeviceId $device `
    -Package $Package `
    -NightscoutPort $NightscoutPort `
    -AllowSystemMutation:$AllowSystemMutation `
    -EnableExternalAppControl:$EnableExternalAppControl `
    -BuildExternalApps:$BuildExternalApps `
    -ExternalRoot $ExternalRoot
}

$summary = [ordered]@{
  device = $device
  package = $Package
  generatedAt = (Get-Date).ToString("o")
  artifactRoot = $artifactRoot
  steps = $steps
  notes = @(
    "Probe Lab composes existing probe_matrix scripts; it does not duplicate probe execution logic.",
    "directReceiver injection validates SolgoInsight receiver/probe behavior.",
    "fixture mode is intentionally blocked until debug-only external app receivers are added."
  )
}

Save-ProbeLabSummary -Summary $summary -OutputPath (Join-Path $artifactRoot "probe-lab-summary.json")
Write-Host "[probe-lab] summary: $(Join-Path $artifactRoot 'probe-lab-summary.json')" -ForegroundColor Cyan
