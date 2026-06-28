$ErrorActionPreference = "Stop"

function Get-ProbeLabRoot {
  return (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
}

function Get-ProbeMatrixRoot {
  return (Resolve-Path (Join-Path $PSScriptRoot "..\..\probe_matrix")).Path
}

function Get-ProbeLabArtifactRoot {
  param([string]$Name = "lab")

  $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
  $root = Join-Path (Resolve-Path ".").Path "build\probe-lab-artifacts\$Name-$stamp"
  New-Item -ItemType Directory -Force -Path $root | Out-Null
  return $root
}

function Get-ProbeExternalRoot {
  param([string]$ExternalRoot = "")

  if ($ExternalRoot) {
    return (Resolve-Path $ExternalRoot).Path
  }
  return (Resolve-Path "K:\Codes\metaguru-health-appcloud\agent_diabetes-hackathon\_external").Path
}

function Import-ProbeMatrixLibraries {
  $matrixRoot = Get-ProbeMatrixRoot
  . (Join-Path $matrixRoot "lib\adb_device.ps1")
  . (Join-Path $matrixRoot "lib\probe_assertions.ps1")
  . (Join-Path $matrixRoot "lib\probe_inventory.ps1")
}

