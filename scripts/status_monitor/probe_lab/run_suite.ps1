param(
  [string]$DeviceId = "",
  [string]$Package = "com.metaguru.smartxdrip",
  [string[]]$Suites = @("common", "xdrip", "juggluco", "nightscout", "aaps", "watch"),
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

& (Join-Path $matrixRoot "run_probe_suite_matrix.ps1") `
  -DeviceId $DeviceId `
  -Package $Package `
  -Suites $Suites `
  -NightscoutPort $NightscoutPort `
  -AllowSystemMutation:$AllowSystemMutation `
  -EnableExternalAppControl:$EnableExternalAppControl `
  -BuildExternalApps:$BuildExternalApps `
  -ExternalRoot $ExternalRoot

