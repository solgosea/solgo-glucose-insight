$Script:ProbeInventory = @(
  @{ id = "common.network.connectivity"; suite = "common"; title = "Network connectivity" },
  @{ id = "common.internet.validated"; suite = "common"; title = "Internet reachability" },
  @{ id = "common.bluetooth.enabled"; suite = "common"; title = "Bluetooth enabled" },
  @{ id = "common.bluetooth.permission"; suite = "common"; title = "Bluetooth permission" },
  @{ id = "common.notification.permission"; suite = "common"; title = "Notification permission" },
  @{ id = "common.battery.optimization"; suite = "common"; title = "Battery optimization" },
  @{ id = "common.runtime.background"; suite = "common"; title = "Background runtime" },

  @{ id = "xdrip.package.visible"; suite = "xdrip"; title = "xDrip+ package visibility" },
  @{ id = "xdrip.broadcast.bg_estimate"; suite = "xdrip"; title = "xDrip+ BG broadcast" },
  @{ id = "xdrip.broadcast.freshness"; suite = "xdrip"; title = "xDrip+ broadcast freshness" },
  @{ id = "xdrip.web_service.reachable"; suite = "xdrip"; title = "xDrip+ Web Service reachable" },
  @{ id = "xdrip.web_service.entries"; suite = "xdrip"; title = "xDrip+ Web Service entries" },
  @{ id = "xdrip.aaps.output_evidence"; suite = "xdrip"; title = "xDrip+ AAPS output evidence" },

  @{ id = "juggluco.package.visible"; suite = "juggluco"; title = "Juggluco package visibility" },
  @{ id = "juggluco.broadcast.glucodata_minute"; suite = "juggluco"; title = "Juggluco glucodata broadcast" },
  @{ id = "juggluco.broadcast.xdrip_compatible"; suite = "juggluco"; title = "Juggluco xDrip-compatible broadcast" },
  @{ id = "juggluco.broadcast.freshness"; suite = "juggluco"; title = "Juggluco broadcast freshness" },

  @{ id = "nightscout.status.reachable"; suite = "nightscout"; title = "Nightscout status endpoint" },
  @{ id = "nightscout.entries.freshness"; suite = "nightscout"; title = "Nightscout entries freshness" },
  @{ id = "nightscout.devicestatus.visible"; suite = "nightscout"; title = "Nightscout devicestatus" },
  @{ id = "nightscout.response_time"; suite = "nightscout"; title = "Nightscout response time" },

  @{ id = "aaps.package.visible"; suite = "aaps"; title = "AAPS package visibility" },
  @{ id = "aaps.bg_source.xdrip_evidence"; suite = "aaps"; title = "AAPS xDrip BG source evidence" },
  @{ id = "aaps.devicestatus.evidence"; suite = "aaps"; title = "AAPS devicestatus evidence" },
  @{ id = "aaps.loop.context_evidence"; suite = "aaps"; title = "AAPS loop context evidence" },

  @{ id = "watch.bridge.package"; suite = "watch"; title = "Watch bridge package" },
  @{ id = "watch.display.evidence"; suite = "watch"; title = "Watch display evidence" }
)

function Get-ProbeInventory {
  return $Script:ProbeInventory
}

function New-ProbeInventoryResult {
  param(
    [Parameter(Mandatory = $true)][string]$VisibleText
  )

  $items = @()
  foreach ($probe in Get-ProbeInventory) {
    $row = Get-ProbeRowObservation -VisibleText $VisibleText -Title $probe.title
    $items += [ordered]@{
      id = $probe.id
      suite = $probe.suite
      title = $probe.title
      found = $row.found
      status = $row.status
      summary = $row.summary
      lines = $row.lines
    }
  }

  $missing = @($items | Where-Object { -not $_.found })
  $suiteGroups = $items | Group-Object suite
  $suites = @()
  foreach ($group in $suiteGroups) {
    $suiteItems = @($group.Group)
    $suites += [ordered]@{
      suite = $group.Name
      total = $suiteItems.Count
      yes = @($suiteItems | Where-Object { $_.status -eq "yes" }).Count
      no = @($suiteItems | Where-Object { $_.status -eq "no" }).Count
      unknown = @($suiteItems | Where-Object { $_.status -eq "unknown" }).Count
      missing = @($suiteItems | Where-Object { -not $_.found }).Count
    }
  }
  return [ordered]@{
    total = $items.Count
    found = $items.Count - $missing.Count
    missing = $missing.id
    yes = @($items | Where-Object { $_.status -eq "yes" }).Count
    no = @($items | Where-Object { $_.status -eq "no" }).Count
    unknown = @($items | Where-Object { $_.status -eq "unknown" }).Count
    suites = $suites
    items = $items
  }
}
