param(
  [string]$DeviceId = "",
  [string]$Package = "com.metaguru.smartxdrip",
  [string[]]$ProbeIds = @(),
  [int]$NightscoutPort = 14120,
  [int]$ManualNavigationTimeoutSeconds = 45,
  [switch]$SkipAppStart,
  [switch]$AllowSystemMutation,
  [switch]$EnableExternalAppControl,
  [switch]$BuildExternalApps,
  [string]$ExternalRoot = ""
)

$ErrorActionPreference = "Stop"

& (Join-Path $PSScriptRoot "run_probe_control_matrix.ps1") `
  -DeviceId $DeviceId `
  -Package $Package `
  -ProbeIds $ProbeIds `
  -NightscoutPort $NightscoutPort `
  -ManualNavigationTimeoutSeconds $ManualNavigationTimeoutSeconds `
  -SkipAppStart:$SkipAppStart `
  -AllowSystemMutation:$AllowSystemMutation `
  -EnableExternalAppControl:$EnableExternalAppControl `
  -BuildExternalApps:$BuildExternalApps `
  -ExternalRoot $ExternalRoot
