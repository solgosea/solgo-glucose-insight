param(
  [string]$DeviceId = "",
  [string]$Package = "com.metaguru.smartxdrip",
  [Parameter(Mandatory = $true)][string[]]$ProbeIds,
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

& (Join-Path $matrixRoot "run_probe_individual_matrix.ps1") `
  -DeviceId $DeviceId `
  -Package $Package `
  -ProbeIds $ProbeIds `
  -NightscoutPort $NightscoutPort `
  -AllowSystemMutation:$AllowSystemMutation `
  -EnableExternalAppControl:$EnableExternalAppControl `
  -BuildExternalApps:$BuildExternalApps `
  -ExternalRoot $ExternalRoot

