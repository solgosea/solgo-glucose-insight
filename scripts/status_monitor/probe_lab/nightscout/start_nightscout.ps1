param(
  [int]$Port = 14120,
  [ValidateSet("fresh", "stale", "slow", "missingDevicestatus", "down")]
  [string]$Scenario = "fresh",
  [string]$ArtifactDir = "",
  [switch]$StopExisting
)

$ErrorActionPreference = "Stop"
$labRoot = Split-Path $PSScriptRoot -Parent
. (Join-Path $labRoot "lib\probe_lab_paths.ps1")

$matrixRoot = Get-ProbeMatrixRoot
& (Join-Path $matrixRoot "nightscout\start_probe_nightscout.ps1") `
  -Port $Port `
  -Scenario $Scenario `
  -ArtifactDir $ArtifactDir `
  -StopExisting:$StopExisting

