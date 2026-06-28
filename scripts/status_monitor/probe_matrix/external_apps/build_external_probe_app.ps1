param(
  [Parameter(Mandatory = $true)][ValidateSet("xdrip", "juggluco", "aaps", "watch")] [string]$AppId,
  [string]$ExternalRoot = ""
)

$ErrorActionPreference = "Stop"

$root = Split-Path $PSScriptRoot -Parent
. (Join-Path $root "lib\external_probe_apps.ps1")

$app = Get-ExternalProbeApp -AppId $AppId -ExternalRoot $ExternalRoot
$apk = Build-ExternalProbeApp -App $app

[ordered]@{
  appId = $app.id
  displayName = $app.displayName
  apk = $apk
  packageCandidates = $app.packageCandidates
} | ConvertTo-Json -Depth 4
