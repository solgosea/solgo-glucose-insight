$ErrorActionPreference = "Stop"

function Get-ProbeControlPlan {
  return @(
    @{ id = "common.network.connectivity"; control = "system"; mutable = $true; available = "Enable Wi-Fi/mobile data"; unavailable = "Disable Wi-Fi/mobile data" },
    @{ id = "common.internet.validated"; control = "system"; mutable = $true; available = "Enable validated network"; unavailable = "Disable Wi-Fi/mobile data" },
    @{ id = "common.bluetooth.enabled"; control = "system"; mutable = $true; available = "Enable Bluetooth"; unavailable = "Disable Bluetooth" },
    @{ id = "common.bluetooth.permission"; control = "permission"; mutable = $true; available = "Grant BLUETOOTH_CONNECT"; unavailable = "Revoke/ignore BLUETOOTH_CONNECT" },
    @{ id = "common.notification.permission"; control = "permission"; mutable = $true; available = "Grant POST_NOTIFICATIONS"; unavailable = "Revoke/ignore POST_NOTIFICATIONS" },
    @{ id = "common.battery.optimization"; control = "system"; mutable = $true; available = "Whitelist app from Doze"; unavailable = "Remove app from Doze whitelist" },
    @{ id = "common.runtime.background"; control = "composite"; mutable = $true; available = "Start app, network on, notifications allowed, power save off"; unavailable = "Power save on or notifications denied" },

    @{ id = "xdrip.package.visible"; control = "external-package"; mutable = $false; available = "Install xDrip+ package"; unavailable = "Uninstall/disable xDrip+ package" },
    @{ id = "xdrip.broadcast.bg_estimate"; control = "broadcast"; mutable = $false; available = "Send xDrip BgEstimate broadcast"; unavailable = "Clear xDrip broadcast evidence" },
    @{ id = "xdrip.broadcast.freshness"; control = "broadcast"; mutable = $false; available = "Send fresh xDrip BgEstimate"; unavailable = "Send stale xDrip BgEstimate" },
    @{ id = "xdrip.web_service.reachable"; control = "target-config"; mutable = $false; available = "Configure reachable xDrip Web Service target"; unavailable = "Configure unreachable xDrip Web Service target" },
    @{ id = "xdrip.web_service.entries"; control = "target-config"; mutable = $false; available = "Configure xDrip Web Service with entries"; unavailable = "Configure xDrip Web Service with empty entries" },
    @{ id = "xdrip.aaps.output_evidence"; control = "derived"; mutable = $false; available = "Provide downstream AAPS evidence"; unavailable = "No downstream AAPS evidence" },

    @{ id = "juggluco.package.visible"; control = "external-package"; mutable = $false; available = "Install Juggluco package"; unavailable = "Uninstall/disable Juggluco package" },
    @{ id = "juggluco.broadcast.glucodata_minute"; control = "broadcast"; mutable = $false; available = "Send glucodata.Minute broadcast"; unavailable = "Clear Juggluco broadcast evidence" },
    @{ id = "juggluco.broadcast.xdrip_compatible"; control = "broadcast"; mutable = $false; available = "Send Juggluco xDrip-compatible broadcast"; unavailable = "Clear Juggluco broadcast evidence" },
    @{ id = "juggluco.broadcast.freshness"; control = "broadcast"; mutable = $false; available = "Send fresh Juggluco broadcast"; unavailable = "Send stale Juggluco broadcast" },

    @{ id = "nightscout.status.reachable"; control = "mock-target"; mutable = $false; available = "Start reachable mock Nightscout"; unavailable = "Stop/unreachable mock Nightscout" },
    @{ id = "nightscout.entries.freshness"; control = "mock-target"; mutable = $false; available = "Mock fresh entries"; unavailable = "Mock stale/empty entries" },
    @{ id = "nightscout.devicestatus.visible"; control = "mock-target"; mutable = $false; available = "Mock devicestatus rows"; unavailable = "Mock empty devicestatus" },
    @{ id = "nightscout.response_time"; control = "mock-target"; mutable = $false; available = "Mock fast response"; unavailable = "Mock slow/down response" },

    @{ id = "aaps.package.visible"; control = "external-package"; mutable = $false; available = "Install AAPS package"; unavailable = "Uninstall/disable AAPS package" },
    @{ id = "aaps.bg_source.xdrip_evidence"; control = "derived"; mutable = $false; available = "Provide AAPS xDrip BG source evidence"; unavailable = "No AAPS BG source evidence" },
    @{ id = "aaps.devicestatus.evidence"; control = "derived"; mutable = $false; available = "Provide AAPS devicestatus evidence"; unavailable = "No AAPS devicestatus evidence" },
    @{ id = "aaps.loop.context_evidence"; control = "derived"; mutable = $false; available = "Provide loop context evidence"; unavailable = "No loop context evidence" },

    @{ id = "watch.bridge.package"; control = "external-package"; mutable = $false; available = "Install watch bridge package"; unavailable = "Uninstall/disable watch bridge package" },
    @{ id = "watch.display.evidence"; control = "derived"; mutable = $false; available = "Provide watch display evidence"; unavailable = "No watch display evidence" }
  )
}

function Get-ProbeControl {
  param([Parameter(Mandatory = $true)][string]$ProbeId)

  foreach ($item in Get-ProbeControlPlan) {
    if ($item.id -eq $ProbeId) {
      return $item
    }
  }
  return $null
}

function Invoke-AdbBestEffort {
  param(
    [Parameter(Mandatory = $true)][string]$DeviceId,
    [Parameter(Mandatory = $true)][string[]]$Arguments
  )

  try {
    if (Get-Command Invoke-Adb -ErrorAction SilentlyContinue) {
      Invoke-Adb -DeviceId $DeviceId -Arguments $Arguments | Out-Null
    } else {
      & adb -s $DeviceId @Arguments | Out-Null
      if ($LASTEXITCODE -ne 0) {
        throw "adb command failed: adb -s $DeviceId $($Arguments -join ' ')"
      }
    }
    return @{ ok = $true; error = $null; command = "adb -s $DeviceId $($Arguments -join ' ')" }
  } catch {
    return @{ ok = $false; error = $_.Exception.Message; command = "adb -s $DeviceId $($Arguments -join ' ')" }
  }
}

function Send-AapsEvidence {
  param(
    [Parameter(Mandatory = $true)][string]$DeviceId,
    [string]$Package = "com.metaguru.smartxdrip",
    [string]$BgSource = "xdrip",
    [bool]$DevicestatusObserved = $false,
    [bool]$LoopContextObserved = $false,
    [string]$LoopState = "visible",
    [int]$TimestampOffsetMinutes = 0
  )

  $receiver = "$Package/.statusmonitor.aaps.AapsEvidenceReceiver"
  $timestampMs = [DateTimeOffset]::UtcNow.AddMinutes($TimestampOffsetMinutes).ToUnixTimeMilliseconds()
  Invoke-AdbBestEffort -DeviceId $DeviceId -Arguments @(
    "shell", "am", "broadcast",
    "--include-stopped-packages",
    "-a", "com.metaguru.probe.AAPS_CONTEXT",
    "-n", $receiver,
    "--el", "timestamp", "$timestampMs",
    "--es", "bgSource", $BgSource,
    "--ez", "devicestatusObserved", $(if ($DevicestatusObserved) { "true" } else { "false" }),
    "--ez", "loopContextObserved", $(if ($LoopContextObserved) { "true" } else { "false" }),
    "--es", "loopState", $LoopState
  )
}

function Send-ExternalXdripBgEstimate {
  param(
    [Parameter(Mandatory = $true)][string]$DeviceId,
    [double]$Glucose = 118,
    [string]$SlopeName = "Flat",
    [double]$Slope = 0,
    [int]$TimestampOffsetMinutes = 0
  )

  $timestampMs = [DateTimeOffset]::UtcNow.AddMinutes($TimestampOffsetMinutes).ToUnixTimeMilliseconds()
  $glucoseText = [string]::Format([Globalization.CultureInfo]::InvariantCulture, "{0:0.0}", $Glucose)
  $slopeText = [string]::Format([Globalization.CultureInfo]::InvariantCulture, "{0:0.0}", $Slope)
  Invoke-AdbBestEffort -DeviceId $DeviceId -Arguments @("shell", "monkey", "-p", "com.eveningoutpost.dexdrip", "1") | Out-Null
  Start-Sleep -Milliseconds 800
  Invoke-AdbBestEffort -DeviceId $DeviceId -Arguments @(
    "shell", "am", "broadcast",
    "--include-stopped-packages",
    "-a", "com.metaguru.probe.XDRIP_SEND_BG",
    "-n", "com.eveningoutpost.dexdrip/com.eveningoutpost.dexdrip.probe.XdripProbeFixtureReceiver",
    "--el", "timestamp", "$timestampMs",
    "--ef", "glucose", $glucoseText,
    "--ef", "slope", $slopeText,
    "--es", "slopeName", $SlopeName
  )
}

function Send-ExternalJugglucoGlucose {
  param(
    [Parameter(Mandatory = $true)][string]$DeviceId,
    [double]$Glucose = 121,
    [bool]$XdripCompatible = $false,
    [int]$TimestampOffsetMinutes = 0
  )

  $timestampMs = [DateTimeOffset]::UtcNow.AddMinutes($TimestampOffsetMinutes).ToUnixTimeMilliseconds()
  $glucoseText = [string]::Format([Globalization.CultureInfo]::InvariantCulture, "{0:0.0}", $Glucose)
  Invoke-AdbBestEffort -DeviceId $DeviceId -Arguments @("shell", "monkey", "-p", "tk.glucodata", "1") | Out-Null
  Start-Sleep -Milliseconds 800
  Invoke-AdbBestEffort -DeviceId $DeviceId -Arguments @(
    "shell", "am", "broadcast",
    "--include-stopped-packages",
    "-a", "com.metaguru.probe.JUGGLUCO_SEND_GLUCOSE",
    "-n", "tk.glucodata/tk.glucodata.probe.JugglucoProbeFixtureReceiver",
    "--el", "timestamp", "$timestampMs",
    "--ef", "glucose", $glucoseText,
    "--ez", "xdripCompatible", $(if ($XdripCompatible) { "true" } else { "false" })
  )
}

function Send-ExternalAapsEvidence {
  param(
    [Parameter(Mandatory = $true)][string]$DeviceId,
    [string]$BgSource = "xdrip",
    [bool]$DevicestatusObserved = $false,
    [bool]$LoopContextObserved = $false,
    [string]$LoopState = "visible",
    [int]$TimestampOffsetMinutes = 0
  )

  $timestampMs = [DateTimeOffset]::UtcNow.AddMinutes($TimestampOffsetMinutes).ToUnixTimeMilliseconds()
  Invoke-AdbBestEffort -DeviceId $DeviceId -Arguments @("shell", "monkey", "-p", "info.nightscout.aapsclient", "1") | Out-Null
  Start-Sleep -Milliseconds 800
  $primary = Invoke-AdbBestEffort -DeviceId $DeviceId -Arguments @(
    "shell", "am", "broadcast",
    "--include-stopped-packages",
    "-a", "com.metaguru.probe.AAPS_SEND_CONTEXT",
    "-n", "info.nightscout.aapsclient/.probe.AapsProbeFixtureReceiver",
    "--el", "timestamp", "$timestampMs",
    "--es", "bgSource", $BgSource,
    "--ez", "devicestatusObserved", $(if ($DevicestatusObserved) { "true" } else { "false" }),
    "--ez", "loopContextObserved", $(if ($LoopContextObserved) { "true" } else { "false" }),
    "--es", "loopState", $LoopState
  )
  if ($primary.ok) {
    return $primary
  }
  return Invoke-AdbBestEffort -DeviceId $DeviceId -Arguments @(
    "shell", "am", "broadcast",
    "--include-stopped-packages",
    "-a", "com.metaguru.probe.AAPS_SEND_CONTEXT",
    "-n", "info.nightscout.aapsclient/app.aaps.probe.AapsProbeFixtureReceiver",
    "--el", "timestamp", "$timestampMs",
    "--es", "bgSource", $BgSource,
    "--ez", "devicestatusObserved", $(if ($DevicestatusObserved) { "true" } else { "false" }),
    "--ez", "loopContextObserved", $(if ($LoopContextObserved) { "true" } else { "false" }),
    "--es", "loopState", $LoopState
  )
}

function Send-ExternalWatchEvidence {
  param(
    [Parameter(Mandatory = $true)][string]$DeviceId,
    [string]$BridgeName = "Watch bridge",
    [bool]$DisplayObserved = $true,
    [int]$TimestampOffsetMinutes = 0
  )

  $timestampMs = [DateTimeOffset]::UtcNow.AddMinutes($TimestampOffsetMinutes).ToUnixTimeMilliseconds()
  Invoke-AdbBestEffort -DeviceId $DeviceId -Arguments @("shell", "monkey", "-p", "com.thatguysservice.huami_xdrip", "1") | Out-Null
  Start-Sleep -Milliseconds 800
  Invoke-AdbBestEffort -DeviceId $DeviceId -Arguments @(
    "shell", "am", "broadcast",
    "--include-stopped-packages",
    "-a", "com.metaguru.probe.WATCHDRIP_SEND_DISPLAY",
    "-n", "com.thatguysservice.huami_xdrip/com.thatguysservice.huami_xdrip.probe.WatchdripProbeFixtureReceiver",
    "--el", "timestamp", "$timestampMs",
    "--es", "bridgeName", $BridgeName,
    "--ez", "displayObserved", $(if ($DisplayObserved) { "true" } else { "false" })
  )
}

function Send-WatchEvidence {
  param(
    [Parameter(Mandatory = $true)][string]$DeviceId,
    [string]$Package = "com.metaguru.smartxdrip",
    [string]$BridgeName = "Watch bridge",
    [bool]$DisplayObserved = $true,
    [int]$TimestampOffsetMinutes = 0
  )

  $receiver = "$Package/.statusmonitor.watch.WatchEvidenceReceiver"
  $timestampMs = [DateTimeOffset]::UtcNow.AddMinutes($TimestampOffsetMinutes).ToUnixTimeMilliseconds()
  Invoke-AdbBestEffort -DeviceId $DeviceId -Arguments @(
    "shell", "am", "broadcast",
    "--include-stopped-packages",
    "-a", "com.metaguru.probe.WATCHDRIP_DISPLAY",
    "-n", $receiver,
    "--el", "timestamp", "$timestampMs",
    "--es", "bridgeName", $BridgeName,
    "--ez", "displayObserved", $(if ($DisplayObserved) { "true" } else { "false" })
  )
}

function Set-ProbeControlledState {
  param(
    [Parameter(Mandatory = $true)][string]$ProbeId,
    [Parameter(Mandatory = $true)][ValidateSet("available", "unavailable")] [string]$State,
    [Parameter(Mandatory = $true)][string]$DeviceId,
    [string]$Package = "com.metaguru.smartxdrip",
    [string]$Root,
    [int]$NightscoutPort = 14120,
    [string]$ArtifactDir = "",
    [switch]$AllowSystemMutation,
    [switch]$EnableExternalAppControl,
    [switch]$BuildExternalApps,
    [string]$ExternalRoot = ""
  )

  $control = Get-ProbeControl -ProbeId $ProbeId
  if ($null -eq $control) {
    return [ordered]@{ controlled = $false; reason = "No control plan"; probeId = $ProbeId; state = $State }
  }

  if ($control.mutable -and -not $AllowSystemMutation) {
    return [ordered]@{
      controlled = $false
      reason = "Requires -AllowSystemMutation"
      probeId = $ProbeId
      state = $State
      control = $control.control
      action = if ($State -eq "available") { $control.available } else { $control.unavailable }
    }
  }

  $actions = @()
  switch ($ProbeId) {
    "common.network.connectivity" {
      if ($State -eq "available") {
        $actions += Invoke-AdbBestEffort -DeviceId $DeviceId -Arguments @("shell", "svc", "wifi", "enable")
        $actions += Invoke-AdbBestEffort -DeviceId $DeviceId -Arguments @("shell", "svc", "data", "enable")
      } else {
        $actions += Invoke-AdbBestEffort -DeviceId $DeviceId -Arguments @("shell", "svc", "wifi", "disable")
        $actions += Invoke-AdbBestEffort -DeviceId $DeviceId -Arguments @("shell", "svc", "data", "disable")
      }
    }
    "common.internet.validated" {
      if ($State -eq "available") {
        $actions += Invoke-AdbBestEffort -DeviceId $DeviceId -Arguments @("shell", "svc", "wifi", "enable")
        $actions += Invoke-AdbBestEffort -DeviceId $DeviceId -Arguments @("shell", "svc", "data", "enable")
      } else {
        $actions += Invoke-AdbBestEffort -DeviceId $DeviceId -Arguments @("shell", "svc", "wifi", "disable")
        $actions += Invoke-AdbBestEffort -DeviceId $DeviceId -Arguments @("shell", "svc", "data", "disable")
      }
    }
    "common.bluetooth.enabled" {
      $cmd = if ($State -eq "available") { "enable" } else { "disable" }
      $actions += Invoke-AdbBestEffort -DeviceId $DeviceId -Arguments @("shell", "cmd", "bluetooth_manager", $cmd)
      $actions += Invoke-AdbBestEffort -DeviceId $DeviceId -Arguments @("shell", "service", "call", "bluetooth_manager", $(if ($State -eq "available") { "6" } else { "8" }))
    }
    "common.bluetooth.permission" {
      if ($State -eq "available") {
        $actions += Invoke-AdbBestEffort -DeviceId $DeviceId -Arguments @("shell", "pm", "grant", $Package, "android.permission.BLUETOOTH_CONNECT")
        $actions += Invoke-AdbBestEffort -DeviceId $DeviceId -Arguments @("shell", "cmd", "appops", "set", $Package, "BLUETOOTH_CONNECT", "allow")
      } else {
        $actions += Invoke-AdbBestEffort -DeviceId $DeviceId -Arguments @("shell", "pm", "revoke", $Package, "android.permission.BLUETOOTH_CONNECT")
        $actions += Invoke-AdbBestEffort -DeviceId $DeviceId -Arguments @("shell", "cmd", "appops", "set", $Package, "BLUETOOTH_CONNECT", "ignore")
      }
    }
    "common.notification.permission" {
      if ($State -eq "available") {
        $actions += Invoke-AdbBestEffort -DeviceId $DeviceId -Arguments @("shell", "pm", "grant", $Package, "android.permission.POST_NOTIFICATIONS")
        $actions += Invoke-AdbBestEffort -DeviceId $DeviceId -Arguments @("shell", "cmd", "appops", "set", $Package, "POST_NOTIFICATION", "allow")
      } else {
        $actions += Invoke-AdbBestEffort -DeviceId $DeviceId -Arguments @("shell", "pm", "revoke", $Package, "android.permission.POST_NOTIFICATIONS")
        $actions += Invoke-AdbBestEffort -DeviceId $DeviceId -Arguments @("shell", "cmd", "appops", "set", $Package, "POST_NOTIFICATION", "ignore")
      }
    }
    "common.battery.optimization" {
      $op = if ($State -eq "available") { "+$Package" } else { "-$Package" }
      $actions += Invoke-AdbBestEffort -DeviceId $DeviceId -Arguments @("shell", "dumpsys", "deviceidle", "whitelist", $op)
    }
    "common.runtime.background" {
      if ($State -eq "available") {
        $actions += Invoke-AdbBestEffort -DeviceId $DeviceId -Arguments @("shell", "cmd", "power", "set-mode", "0")
        $actions += Invoke-AdbBestEffort -DeviceId $DeviceId -Arguments @("shell", "pm", "grant", $Package, "android.permission.POST_NOTIFICATIONS")
        Start-ProbeApp -DeviceId $DeviceId -Package $Package
      } else {
        $actions += Invoke-AdbBestEffort -DeviceId $DeviceId -Arguments @("shell", "cmd", "power", "set-mode", "1")
      }
    }
    "xdrip.broadcast.bg_estimate" {
      if ($State -eq "available") {
        if ($EnableExternalAppControl) {
          $actions += Send-ExternalXdripBgEstimate -DeviceId $DeviceId -Glucose 118
        } else {
          & (Join-Path $Root "broadcast\send_xdrip_bg_estimate.ps1") -DeviceId $DeviceId -Package $Package -Glucose 118 | Out-Null
          $actions += @{ ok = $true; command = "send_xdrip_bg_estimate receiver fallback"; error = $null }
        }
      } else {
        & (Join-Path $Root "device\clear_probe_evidence.ps1") -DeviceId $DeviceId -Package $Package | Out-Null
        $actions += @{ ok = $true; command = "clear xdrip evidence"; error = $null }
      }
    }
    "xdrip.broadcast.freshness" {
      if ($State -eq "available") {
        if ($EnableExternalAppControl) {
          $actions += Send-ExternalXdripBgEstimate -DeviceId $DeviceId -Glucose 118
        } else {
          & (Join-Path $Root "broadcast\send_xdrip_bg_estimate.ps1") -DeviceId $DeviceId -Package $Package -Glucose 118 | Out-Null
          $actions += @{ ok = $true; command = "send fresh xdrip receiver fallback"; error = $null }
        }
      } else {
        if ($EnableExternalAppControl) {
          $actions += Send-ExternalXdripBgEstimate -DeviceId $DeviceId -Glucose 118 -TimestampOffsetMinutes -25
        } else {
          & (Join-Path $Root "broadcast\send_xdrip_bg_estimate.ps1") -DeviceId $DeviceId -Package $Package -Glucose 118 -TimestampOffsetMinutes -25 | Out-Null
          $actions += @{ ok = $true; command = "send stale xdrip receiver fallback"; error = $null }
        }
      }
    }
    "juggluco.broadcast.glucodata_minute" {
      if ($State -eq "available") {
        if ($EnableExternalAppControl) {
          $actions += Send-ExternalJugglucoGlucose -DeviceId $DeviceId -Glucose 122
        } else {
          & (Join-Path $Root "broadcast\send_juggluco_glucodata.ps1") -DeviceId $DeviceId -Package $Package -Glucose 122 | Out-Null
          $actions += @{ ok = $true; command = "send glucodata.Minute receiver fallback"; error = $null }
        }
      } else {
        & (Join-Path $Root "device\clear_probe_evidence.ps1") -DeviceId $DeviceId -Package $Package | Out-Null
        $actions += @{ ok = $true; command = "clear juggluco evidence"; error = $null }
      }
    }
    "juggluco.broadcast.xdrip_compatible" {
      if ($State -eq "available") {
        if ($EnableExternalAppControl) {
          $actions += Send-ExternalJugglucoGlucose -DeviceId $DeviceId -Glucose 123 -XdripCompatible $true
        } else {
          & (Join-Path $Root "broadcast\send_juggluco_xdrip_compatible.ps1") -DeviceId $DeviceId -Package $Package -Glucose 123 | Out-Null
          $actions += @{ ok = $true; command = "send juggluco xdrip-compatible receiver fallback"; error = $null }
        }
      } else {
        & (Join-Path $Root "device\clear_probe_evidence.ps1") -DeviceId $DeviceId -Package $Package | Out-Null
        $actions += @{ ok = $true; command = "clear juggluco evidence"; error = $null }
      }
    }
    "juggluco.broadcast.freshness" {
      if ($State -eq "available") {
        if ($EnableExternalAppControl) {
          $actions += Send-ExternalJugglucoGlucose -DeviceId $DeviceId -Glucose 122
        } else {
          & (Join-Path $Root "broadcast\send_juggluco_glucodata.ps1") -DeviceId $DeviceId -Package $Package -Glucose 122 | Out-Null
          $actions += @{ ok = $true; command = "send fresh juggluco receiver fallback"; error = $null }
        }
      } else {
        if ($EnableExternalAppControl) {
          $actions += Send-ExternalJugglucoGlucose -DeviceId $DeviceId -Glucose 122 -TimestampOffsetMinutes -25
        } else {
          & (Join-Path $Root "broadcast\send_juggluco_glucodata.ps1") -DeviceId $DeviceId -Package $Package -Glucose 122 -TimestampOffsetMinutes -25 | Out-Null
          $actions += @{ ok = $true; command = "send stale juggluco receiver fallback"; error = $null }
        }
      }
    }
    "xdrip.aaps.output_evidence" {
      if ($State -eq "available") {
        if ($EnableExternalAppControl) {
          $actions += Send-ExternalAapsEvidence -DeviceId $DeviceId -BgSource "xdrip" -DevicestatusObserved $false -LoopContextObserved $false
        } else {
          $actions += Send-AapsEvidence -DeviceId $DeviceId -Package $Package -BgSource "xdrip" -DevicestatusObserved $false -LoopContextObserved $false
        }
      } else {
        & (Join-Path $Root "device\clear_probe_evidence.ps1") -DeviceId $DeviceId -Package $Package | Out-Null
        $actions += @{ ok = $true; command = "clear aaps evidence"; error = $null }
      }
    }
    "aaps.bg_source.xdrip_evidence" {
      if ($State -eq "available") {
        if ($EnableExternalAppControl) {
          $actions += Send-ExternalAapsEvidence -DeviceId $DeviceId -BgSource "xdrip" -DevicestatusObserved $false -LoopContextObserved $false
        } else {
          $actions += Send-AapsEvidence -DeviceId $DeviceId -Package $Package -BgSource "xdrip" -DevicestatusObserved $false -LoopContextObserved $false
        }
      } else {
        & (Join-Path $Root "device\clear_probe_evidence.ps1") -DeviceId $DeviceId -Package $Package | Out-Null
        $actions += @{ ok = $true; command = "clear aaps evidence"; error = $null }
      }
    }
    "aaps.devicestatus.evidence" {
      if ($State -eq "available") {
        if ($EnableExternalAppControl) {
          $actions += Send-ExternalAapsEvidence -DeviceId $DeviceId -BgSource "xdrip" -DevicestatusObserved $true -LoopContextObserved $false
        } else {
          $actions += Send-AapsEvidence -DeviceId $DeviceId -Package $Package -BgSource "xdrip" -DevicestatusObserved $true -LoopContextObserved $false
        }
      } else {
        & (Join-Path $Root "device\clear_probe_evidence.ps1") -DeviceId $DeviceId -Package $Package | Out-Null
        $actions += @{ ok = $true; command = "clear aaps evidence"; error = $null }
      }
    }
    "aaps.loop.context_evidence" {
      if ($State -eq "available") {
        if ($EnableExternalAppControl) {
          $actions += Send-ExternalAapsEvidence -DeviceId $DeviceId -BgSource "xdrip" -DevicestatusObserved $true -LoopContextObserved $true
        } else {
          $actions += Send-AapsEvidence -DeviceId $DeviceId -Package $Package -BgSource "xdrip" -DevicestatusObserved $true -LoopContextObserved $true
        }
      } else {
        & (Join-Path $Root "device\clear_probe_evidence.ps1") -DeviceId $DeviceId -Package $Package | Out-Null
        $actions += @{ ok = $true; command = "clear aaps evidence"; error = $null }
      }
    }
    "watch.display.evidence" {
      if ($State -eq "available") {
        if ($EnableExternalAppControl) {
          $actions += Send-ExternalWatchEvidence -DeviceId $DeviceId -DisplayObserved $true
        } else {
          $actions += Send-WatchEvidence -DeviceId $DeviceId -Package $Package -DisplayObserved $true
        }
      } else {
        & (Join-Path $Root "device\clear_probe_evidence.ps1") -DeviceId $DeviceId -Package $Package | Out-Null
        $actions += @{ ok = $true; command = "clear watch evidence"; error = $null }
      }
    }
    default {
      if ($ProbeId.StartsWith("nightscout.")) {
        $scenario = switch ($ProbeId) {
          "nightscout.status.reachable" { if ($State -eq "available") { "fresh" } else { "down" } }
          "nightscout.entries.freshness" { if ($State -eq "available") { "fresh" } else { "stale" } }
          "nightscout.devicestatus.visible" { if ($State -eq "available") { "fresh" } else { "missingDevicestatus" } }
          "nightscout.response_time" { if ($State -eq "available") { "fresh" } else { "slow" } }
        }
        if ($scenario) {
          $nsJson = & (Join-Path $Root "nightscout\start_probe_nightscout.ps1") -Port $NightscoutPort -Scenario $scenario -ArtifactDir $ArtifactDir -StopExisting
          Set-AdbReversePort -DeviceId $DeviceId -Port $NightscoutPort
          $actions += @{ ok = $true; command = "start mock nightscout $scenario"; error = $null; result = $nsJson }
        } else {
          $connection = Get-NetTCPConnection -LocalPort $NightscoutPort -State Listen -ErrorAction SilentlyContinue |
            Where-Object { $_.OwningProcess -gt 0 } |
            Select-Object -First 1
          if ($connection) {
            Stop-Process -Id $connection.OwningProcess -Force
          }
          $actions += @{ ok = $true; command = "stop mock nightscout"; error = $null }
        }
      } elseif ($control.control -eq "external-package") {
        if (-not $EnableExternalAppControl) {
          return [ordered]@{
            controlled = $false
            reason = "Requires -EnableExternalAppControl"
            probeId = $ProbeId
            state = $State
            control = $control.control
            action = if ($State -eq "available") { $control.available } else { $control.unavailable }
          }
        }

        . (Join-Path $Root "lib\external_probe_apps.ps1")
        $appId = switch -Regex ($ProbeId) {
          "^xdrip\." { "xdrip"; break }
          "^juggluco\." { "juggluco"; break }
          "^aaps\." { "aaps"; break }
          "^watch\." { "watch"; break }
          default { $null }
        }
        if (-not $appId) {
          throw "No external app mapping for probe '$ProbeId'."
        }
        $app = Get-ExternalProbeApp -AppId $appId -ExternalRoot $ExternalRoot
        if ($State -eq "available") {
          $installedPackage = Get-InstalledExternalProbePackage -DeviceId $DeviceId -App $app
          if ($installedPackage) {
            $actions += @{
              ok = $true
              command = "external app $appId already installed"
              error = $null
              result = [ordered]@{
                id = $app.id
                displayName = $app.displayName
                installedPackage = $installedPackage
              }
            }
          } else {
            $installed = Install-ExternalProbeApp -DeviceId $DeviceId -App $app -Build:$BuildExternalApps
            $actions += @{ ok = $true; command = "install external app $appId"; error = $null; result = $installed }
          }
        } else {
          $removed = Uninstall-ExternalProbeApp -DeviceId $DeviceId -App $app
          $actions += @{ ok = $true; command = "uninstall external app $appId"; error = $null; result = $removed }
        }
      } else {
        return [ordered]@{
          controlled = $false
          reason = "Requires external app/config/evidence"
          probeId = $ProbeId
          state = $State
          control = $control.control
          action = if ($State -eq "available") { $control.available } else { $control.unavailable }
        }
      }
    }
  }

  Start-Sleep -Milliseconds 700
  return [ordered]@{
    controlled = $true
    probeId = $ProbeId
    state = $State
    control = $control.control
    actions = $actions
  }
}
