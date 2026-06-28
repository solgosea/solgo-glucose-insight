param(
  [string]$DeviceId = "",
  [string]$Package = "com.metaguru.smartxdrip",
  [int]$NightscoutPort = 14120,
  [switch]$AllowSystemMutation,
  [switch]$EnableExternalAppControl,
  [switch]$BuildExternalApps,
  [string]$ExternalRoot = ""
)

$ErrorActionPreference = "Stop"
$root = $PSScriptRoot
. (Join-Path $root "lib\probe_lab_paths.ps1")
$matrixRoot = Get-ProbeMatrixRoot

& (Join-Path $matrixRoot "run_probe_full_chain.ps1") `
  -DeviceId $DeviceId `
  -Package $Package `
  -NightscoutPort $NightscoutPort `
  -AllowSystemMutation:$AllowSystemMutation `
  -EnableExternalAppControl:$EnableExternalAppControl `
  -BuildExternalApps:$BuildExternalApps `
  -ExternalRoot $ExternalRoot

