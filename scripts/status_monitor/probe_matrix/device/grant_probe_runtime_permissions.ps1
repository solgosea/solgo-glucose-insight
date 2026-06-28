param(
  [string]$DeviceId = "",
  [string]$Package = "com.metaguru.smartxdrip"
)

$ErrorActionPreference = "Stop"
$lib = Join-Path (Split-Path -Parent $PSScriptRoot) "lib\adb_device.ps1"
. $lib

$device = Resolve-AdbDevice -DeviceId $DeviceId

$permissions = @(
  "android.permission.BLUETOOTH_CONNECT",
  "android.permission.POST_NOTIFICATIONS"
)

foreach ($permission in $permissions) {
  try {
    Invoke-Adb -DeviceId $device -Arguments @("shell", "pm", "grant", $Package, $permission) | Out-Null
  } catch {
    Write-Warning "Could not grant $permission with pm grant: $($_.Exception.Message)"
  }
}

try {
  Invoke-Adb -DeviceId $device -Arguments @("shell", "cmd", "appops", "set", $Package, "BLUETOOTH_CONNECT", "allow") | Out-Null
} catch {
  Write-Warning "Could not set BLUETOOTH_CONNECT appop: $($_.Exception.Message)"
}

try {
  Invoke-Adb -DeviceId $device -Arguments @("shell", "cmd", "appops", "set", $Package, "POST_NOTIFICATION", "allow") | Out-Null
} catch {
  Write-Warning "Could not set POST_NOTIFICATION appop: $($_.Exception.Message)"
}

[ordered]@{
  device = $device
  package = $Package
  granted = $permissions
} | ConvertTo-Json -Compress
