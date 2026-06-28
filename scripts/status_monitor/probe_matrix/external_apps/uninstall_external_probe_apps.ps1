param(
  [string]$DeviceId = "",
  [string[]]$AppIds = @("xdrip", "juggluco", "aaps", "watch"),
  [string]$ExternalRoot = ""
)

$ErrorActionPreference = "Stop"

$root = Split-Path $PSScriptRoot -Parent
. (Join-Path $root "lib\adb_device.ps1")
. (Join-Path $root "lib\external_probe_apps.ps1")

$device = Resolve-AdbDevice -DeviceId $DeviceId
$resolvedAppIds = @()
foreach ($item in $AppIds) {
  $resolvedAppIds += ($item -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ })
}

$results = @()
foreach ($appId in $resolvedAppIds) {
  $app = Get-ExternalProbeApp -AppId $appId -ExternalRoot $ExternalRoot
  Write-Host "[external-apps] uninstall $($app.displayName)" -ForegroundColor Cyan
  $results += [ordered]@{
    id = $app.id
    displayName = $app.displayName
    packages = Uninstall-ExternalProbeApp -DeviceId $device -App $app
  }
}

[ordered]@{
  device = $device
  generatedAt = (Get-Date).ToString("o")
  results = $results
} | ConvertTo-Json -Depth 6
