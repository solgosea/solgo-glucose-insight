param(
  [string]$DeviceId = "",
  [string]$Package = "com.metaguru.smartxdrip",
  [int]$ManualNavigationTimeoutSeconds = 45,
  [switch]$SkipAppStart,
  [switch]$CaptureSystemSnapshot
)

$ErrorActionPreference = "Stop"

$root = $PSScriptRoot
. (Join-Path $root "lib\adb_device.ps1")
. (Join-Path $root "lib\probe_ui.ps1")
. (Join-Path $root "lib\probe_assertions.ps1")
. (Join-Path $root "lib\probe_inventory.ps1")

$device = Resolve-AdbDevice -DeviceId $DeviceId
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$artifactRoot = Join-Path (Resolve-Path ".").Path "build\probe-test-artifacts\inventory-$stamp"
New-Item -ItemType Directory -Force -Path $artifactRoot | Out-Null

Write-Host "[probe-inventory] device=$device artifacts=$artifactRoot" -ForegroundColor Cyan

Open-ProbeChecklistRoute `
  -DeviceId $device `
  -ArtifactDir $artifactRoot `
  -Package $Package `
  -TimeoutSeconds $ManualNavigationTimeoutSeconds

$finalXml = Invoke-ProbeRunChecks `
  -DeviceId $device `
  -ArtifactDir $artifactRoot `
  -TimeoutSeconds 60
$expandedXml = Get-ProbeChecklistExpandedXml `
  -DeviceId $device `
  -ArtifactDir $artifactRoot

Save-AdbScreenshot `
  -DeviceId $device `
  -OutputPath (Join-Path $artifactRoot "probe-checklist.png")
Save-AdbUiDump `
  -DeviceId $device `
  -OutputPath (Join-Path $artifactRoot "probe-checklist.xml")

$visibleText = Convert-UiXmlToVisibleText -UiXml $expandedXml
$visibleText | Set-Content -Path (Join-Path $artifactRoot "probe-visible-text.txt") -Encoding UTF8

$inventory = New-ProbeInventoryResult -VisibleText $visibleText

if ($CaptureSystemSnapshot) {
  Invoke-Adb -DeviceId $device -Arguments @("shell", "dumpsys", "bluetooth_manager") |
    Set-Content -Path (Join-Path $artifactRoot "system-bluetooth-manager.txt") -Encoding UTF8
  Invoke-Adb -DeviceId $device -Arguments @("shell", "dumpsys", "package", $Package) |
    Set-Content -Path (Join-Path $artifactRoot "system-package-permissions.txt") -Encoding UTF8
  Invoke-Adb -DeviceId $device -Arguments @("shell", "cmd", "appops", "get", $Package) |
    Set-Content -Path (Join-Path $artifactRoot "system-appops.txt") -Encoding UTF8
}

$summary = [ordered]@{
  device = $device
  package = $Package
  generatedAt = (Get-Date).ToString("o")
  artifactRoot = $artifactRoot
  inventory = $inventory
  notes = @(
    "This inventory validates every probe row exposed by the Probe Checklist UI.",
    "Bluetooth enabled depends on Android Bluetooth state and BLUETOOTH_CONNECT permission."
  )
}

Save-ProbeSummary -Summary $summary -OutputPath (Join-Path $artifactRoot "probe-inventory-summary.json")

Write-Host "[probe-inventory] found=$($inventory.found)/$($inventory.total) yes=$($inventory.yes) no=$($inventory.no) unknown=$($inventory.unknown)" -ForegroundColor Yellow
if ($inventory.missing.Count -gt 0) {
  Write-Host "[probe-inventory] missing: $($inventory.missing -join ', ')" -ForegroundColor Red
}
Write-Host "[probe-inventory] summary: $(Join-Path $artifactRoot 'probe-inventory-summary.json')" -ForegroundColor Cyan
