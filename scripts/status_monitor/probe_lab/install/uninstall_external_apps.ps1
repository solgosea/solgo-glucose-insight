param(
  [string]$DeviceId = "",
  [string[]]$AppIds = @("xdrip", "juggluco", "aaps", "watch"),
  [string]$ExternalRoot = ""
)

$ErrorActionPreference = "Stop"
$labRoot = Split-Path $PSScriptRoot -Parent
. (Join-Path $labRoot "lib\probe_lab_paths.ps1")

$matrixRoot = Get-ProbeMatrixRoot
& (Join-Path $matrixRoot "external_apps\uninstall_external_probe_apps.ps1") `
  -DeviceId $DeviceId `
  -AppIds $AppIds `
  -ExternalRoot $ExternalRoot

