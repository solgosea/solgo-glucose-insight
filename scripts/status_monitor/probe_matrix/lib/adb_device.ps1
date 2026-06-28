$ErrorActionPreference = "Stop"

function Resolve-AdbDevice {
  param([string]$DeviceId = "")

  if ($DeviceId) {
    $state = adb -s $DeviceId get-state 2>$null
    if ($LASTEXITCODE -ne 0 -or ($state -join "").Trim() -ne "device") {
      throw "ADB device '$DeviceId' is not connected."
    }
    return $DeviceId
  }

  $devices = adb devices |
    Select-String "`tdevice$" |
    ForEach-Object { ($_.ToString() -split "`t")[0] }

  if (-not $devices) {
    throw "No adb device is connected."
  }
  if (@($devices).Count -gt 1) {
    throw "Multiple adb devices are connected. Pass -DeviceId explicitly."
  }
  return @($devices)[0]
}

function Invoke-Adb {
  param(
    [Parameter(Mandatory = $true)][string]$DeviceId,
    [Parameter(Mandatory = $true)][string[]]$Arguments
  )

  & adb -s $DeviceId @Arguments
  if ($LASTEXITCODE -ne 0) {
    throw "adb command failed: adb -s $DeviceId $($Arguments -join ' ')"
  }
}

function Start-ProbeApp {
  param(
    [Parameter(Mandatory = $true)][string]$DeviceId,
    [string]$Package = "com.metaguru.smartxdrip"
  )

  Invoke-Adb -DeviceId $DeviceId -Arguments @(
    "shell",
    "monkey",
    "-p",
    $Package,
    "-c",
    "android.intent.category.LAUNCHER",
    "1"
  ) | Out-Null
}

function Invoke-AdbNoThrow {
  param(
    [Parameter(Mandatory = $true)][string]$DeviceId,
    [Parameter(Mandatory = $true)][string[]]$Arguments
  )

  try {
    & adb -s $DeviceId @Arguments | Out-Null
  } catch {
    # Best-effort recovery helper. The test result should not be hidden by a
    # device/ROM refusing a non-critical state reset command.
  }
}

function Restore-ProbeDeviceBaseline {
  param(
    [Parameter(Mandatory = $true)][string]$DeviceId,
    [string]$Package = "com.metaguru.smartxdrip"
  )

  Invoke-AdbNoThrow -DeviceId $DeviceId -Arguments @("shell", "input", "keyevent", "224")
  Invoke-AdbNoThrow -DeviceId $DeviceId -Arguments @("shell", "wm", "dismiss-keyguard")
  Invoke-AdbNoThrow -DeviceId $DeviceId -Arguments @("shell", "input", "keyevent", "82")
  Invoke-AdbNoThrow -DeviceId $DeviceId -Arguments @("shell", "cmd", "statusbar", "collapse")
  Invoke-AdbNoThrow -DeviceId $DeviceId -Arguments @("shell", "cmd", "power", "set-mode", "0")
  Invoke-AdbNoThrow -DeviceId $DeviceId -Arguments @("shell", "svc", "wifi", "enable")
  Invoke-AdbNoThrow -DeviceId $DeviceId -Arguments @("shell", "svc", "data", "enable")
  Invoke-AdbNoThrow -DeviceId $DeviceId -Arguments @("shell", "cmd", "bluetooth_manager", "enable")
  Invoke-AdbNoThrow -DeviceId $DeviceId -Arguments @("shell", "pm", "grant", $Package, "android.permission.POST_NOTIFICATIONS")
  Invoke-AdbNoThrow -DeviceId $DeviceId -Arguments @("shell", "cmd", "appops", "set", $Package, "POST_NOTIFICATION", "allow")
  Invoke-AdbNoThrow -DeviceId $DeviceId -Arguments @("shell", "pm", "grant", $Package, "android.permission.BLUETOOTH_CONNECT")
  Invoke-AdbNoThrow -DeviceId $DeviceId -Arguments @("shell", "cmd", "appops", "set", $Package, "BLUETOOTH_CONNECT", "allow")
}

function Stop-ProbeApp {
  param(
    [Parameter(Mandatory = $true)][string]$DeviceId,
    [string]$Package = "com.metaguru.smartxdrip"
  )

  Invoke-Adb -DeviceId $DeviceId -Arguments @(
    "shell",
    "am",
    "force-stop",
    $Package
  ) | Out-Null
}

function Open-DebugRoute {
  param(
    [Parameter(Mandatory = $true)][string]$DeviceId,
    [string]$Package = "com.metaguru.smartxdrip",
    [Parameter(Mandatory = $true)][string]$Route
  )

  $routeBase64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($Route))
  Invoke-Adb -DeviceId $DeviceId -Arguments @(
    "shell",
    "am",
    "start",
    "-n",
    "$Package/.MainActivity",
    "-a",
    "com.metaguru.smartxdrip.DEBUG_OPEN_ROUTE",
    "--es",
    "routeBase64",
    $routeBase64
  ) | Out-Null
}

function Set-AdbReversePort {
  param(
    [Parameter(Mandatory = $true)][string]$DeviceId,
    [Parameter(Mandatory = $true)][int]$Port
  )

  Invoke-Adb -DeviceId $DeviceId -Arguments @(
    "reverse",
    "tcp:$Port",
    "tcp:$Port"
  ) | Out-Null
}

function Clear-StatusMonitorBroadcastPrefs {
  param(
    [Parameter(Mandatory = $true)][string]$DeviceId,
    [string]$Package = "com.metaguru.smartxdrip"
  )

  Invoke-Adb -DeviceId $DeviceId -Arguments @(
    "shell",
    "run-as",
    $Package,
    "rm",
    "-f",
    "shared_prefs/xdrip_broadcast_status.xml",
    "shared_prefs/juggluco_broadcast_status.xml",
    "shared_prefs/aaps_evidence_status.xml",
    "shared_prefs/watch_evidence_status.xml"
  ) | Out-Null
}

function Start-ProbeLogcatCapture {
  param(
    [Parameter(Mandatory = $true)][string]$DeviceId,
    [Parameter(Mandatory = $true)][string]$OutputPath
  )

  Invoke-Adb -DeviceId $DeviceId -Arguments @("logcat", "-c") | Out-Null

  $argList = @("-s", $DeviceId, "logcat", "-v", "time")
  return Start-Process `
    -FilePath "adb" `
    -ArgumentList $argList `
    -RedirectStandardOutput $OutputPath `
    -RedirectStandardError "$OutputPath.err" `
    -PassThru `
    -WindowStyle Hidden
}

function Stop-ProbeLogcatCapture {
  param($Process)

  if ($null -ne $Process -and -not $Process.HasExited) {
    Stop-Process -Id $Process.Id -Force
  }
}

function Save-AdbScreenshot {
  param(
    [Parameter(Mandatory = $true)][string]$DeviceId,
    [Parameter(Mandatory = $true)][string]$OutputPath
  )

  $remote = "/sdcard/probe_matrix_screen.png"
  Invoke-Adb -DeviceId $DeviceId -Arguments @("shell", "screencap", "-p", $remote) | Out-Null
  Invoke-Adb -DeviceId $DeviceId -Arguments @("pull", $remote, $OutputPath) | Out-Null
  Invoke-Adb -DeviceId $DeviceId -Arguments @("shell", "rm", "-f", $remote) | Out-Null
}

function Save-AdbUiDump {
  param(
    [Parameter(Mandatory = $true)][string]$DeviceId,
    [Parameter(Mandatory = $true)][string]$OutputPath
  )

  $remote = "/sdcard/window_dump.xml"
  $lastError = $null
  for ($attempt = 0; $attempt -lt 4; $attempt++) {
    try {
      Invoke-Adb -DeviceId $DeviceId -Arguments @("shell", "uiautomator", "dump", $remote) | Out-Null
      Invoke-Adb -DeviceId $DeviceId -Arguments @("pull", $remote, $OutputPath) | Out-Null
      Invoke-Adb -DeviceId $DeviceId -Arguments @("shell", "rm", "-f", $remote) | Out-Null
      return
    } catch {
      $lastError = $_
      Start-Sleep -Milliseconds (500 + ($attempt * 350))
    }
  }
  throw $lastError
}

function Get-AdbUiXml {
  param(
    [Parameter(Mandatory = $true)][string]$DeviceId,
    [Parameter(Mandatory = $true)][string]$ArtifactDir,
    [string]$Name = "ui"
  )

  & adb -s $DeviceId shell cmd statusbar collapse 2>$null | Out-Null
  $path = Join-Path $ArtifactDir "$Name.xml"
  Save-AdbUiDump -DeviceId $DeviceId -OutputPath $path
  return Get-Content $path -Raw
}
