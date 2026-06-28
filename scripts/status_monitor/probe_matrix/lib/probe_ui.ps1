$ErrorActionPreference = "Stop"

function Test-ProbeChecklistVisible {
  param([Parameter(Mandatory = $true)][string]$UiXml)

  return $UiXml.Contains("Run checks") -or
    $UiXml.Contains("Running...") -or
    $UiXml.Contains("Core score") -or
    $UiXml.Contains("Connection checklist") -or
    $UiXml.Contains("Check your data path")
}

function Get-UiNodeCenterByText {
  param(
    [Parameter(Mandatory = $true)][string]$UiXml,
    [Parameter(Mandatory = $true)][string]$Text
  )

  $escaped = [regex]::Escape($Text)
  $pattern = "text=`"$escaped`"[^>]*bounds=`"\[(\d+),(\d+)\]\[(\d+),(\d+)\]`""
  $match = [regex]::Match($UiXml, $pattern)
  if (-not $match.Success) {
    $pattern = "content-desc=`"$escaped`"[^>]*bounds=`"\[(\d+),(\d+)\]\[(\d+),(\d+)\]`""
    $match = [regex]::Match($UiXml, $pattern)
  }
  if (-not $match.Success) {
    $pattern = "text=`"[^`"]*$escaped[^`"]*`"[^>]*clickable=`"true`"[^>]*bounds=`"\[(\d+),(\d+)\]\[(\d+),(\d+)\]`""
    $match = [regex]::Match($UiXml, $pattern)
  }
  if (-not $match.Success) {
    $pattern = "content-desc=`"[^`"]*$escaped[^`"]*`"[^>]*clickable=`"true`"[^>]*bounds=`"\[(\d+),(\d+)\]\[(\d+),(\d+)\]`""
    $match = [regex]::Match($UiXml, $pattern)
  }
  if (-not $match.Success) {
    return $null
  }

  $left = [int]$match.Groups[1].Value
  $top = [int]$match.Groups[2].Value
  $right = [int]$match.Groups[3].Value
  $bottom = [int]$match.Groups[4].Value
  return @{
    x = [int](($left + $right) / 2)
    y = [int](($top + $bottom) / 2)
  }
}

function Wait-ProbeChecklistVisible {
  param(
    [Parameter(Mandatory = $true)][string]$DeviceId,
    [Parameter(Mandatory = $true)][string]$ArtifactDir,
    [int]$TimeoutSeconds = 30
  )

  $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
  do {
    Invoke-Adb -DeviceId $DeviceId -Arguments @("shell", "cmd", "statusbar", "collapse") | Out-Null
    $xml = Get-AdbUiXml -DeviceId $DeviceId -ArtifactDir $ArtifactDir -Name "probe-page-check"
    if ($xml.Contains('package="com.android.systemui"')) {
      Invoke-Adb -DeviceId $DeviceId -Arguments @("shell", "input", "keyevent", "4") | Out-Null
      Start-Sleep -Milliseconds 350
      Invoke-Adb -DeviceId $DeviceId -Arguments @("shell", "input", "keyevent", "4") | Out-Null
      Start-Sleep -Milliseconds 550
      $xml = Get-AdbUiXml -DeviceId $DeviceId -ArtifactDir $ArtifactDir -Name "probe-page-check-after-systemui"
    }
    if (Test-ProbeChecklistVisible -UiXml $xml) {
      return $xml
    }
    Start-Sleep -Milliseconds 700
  } while ((Get-Date) -lt $deadline)

  throw "Probe Checklist is not visible. Open Status Monitor > Probe Checklist on the phone, then rerun the script or increase -ManualNavigationTimeoutSeconds."
}

function Open-ProbeChecklistFromStatusDashboard {
  param(
    [Parameter(Mandatory = $true)][string]$DeviceId,
    [Parameter(Mandatory = $true)][string]$ArtifactDir
  )

  $xml = Get-AdbUiXml -DeviceId $DeviceId -ArtifactDir $ArtifactDir -Name "status-dashboard-before-probe-tap"
  if (-not $xml.Contains("Status Monitor")) {
    return $false
  }

  $rootMatch = [regex]::Match($xml, "<hierarchy[^>]*>.*?bounds=`"\[0,0\]\[(\d+),(\d+)\]`"", "Singleline")
  $screenWidth = if ($rootMatch.Success) { [int]$rootMatch.Groups[1].Value } else { 1600 }
  $buttonMatches = [regex]::Matches(
    $xml,
    "class=`"android\.widget\.Button`"[^>]*clickable=`"true`"[^>]*bounds=`"\[(\d+),(\d+)\]\[(\d+),(\d+)\]`""
  )
  $candidates = @()
  foreach ($match in $buttonMatches) {
    $left = [int]$match.Groups[1].Value
    $top = [int]$match.Groups[2].Value
    $right = [int]$match.Groups[3].Value
    $bottom = [int]$match.Groups[4].Value
    if ($left -gt ($screenWidth / 2) -and $top -lt 320) {
      $candidates += [ordered]@{
        left = $left
        top = $top
        right = $right
        bottom = $bottom
      }
    }
  }
  if (-not $candidates) {
    return $false
  }

  $target = $candidates | Sort-Object left | Select-Object -First 1
  $x = [int](($target.left + $target.right) / 2)
  $y = [int](($target.top + $target.bottom) / 2)
  Invoke-Adb -DeviceId $DeviceId -Arguments @("shell", "input", "tap", "$x", "$y") | Out-Null
  Start-Sleep -Milliseconds 1200
  return $true
}

function Wait-ProbeNotRunning {
  param(
    [Parameter(Mandatory = $true)][string]$DeviceId,
    [Parameter(Mandatory = $true)][string]$ArtifactDir,
    [int]$TimeoutSeconds = 75
  )

  $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
  do {
    $xml = Get-AdbUiXml -DeviceId $DeviceId -ArtifactDir $ArtifactDir -Name "wait-not-running"
    if ((Test-ProbeChecklistVisible -UiXml $xml) -and -not $xml.Contains("Running...")) {
      return $xml
    }
    Start-Sleep -Milliseconds 900
  } while ((Get-Date) -lt $deadline)

  throw "Probe Checklist is still running after $TimeoutSeconds seconds."
}

function Open-ProbeChecklistRoute {
  param(
    [Parameter(Mandatory = $true)][string]$DeviceId,
    [Parameter(Mandatory = $true)][string]$ArtifactDir,
    [string]$Package = "com.metaguru.smartxdrip",
    [int]$TimeoutSeconds = 45,
    [string]$NightscoutBaseUrl = "",
    [string]$NightscoutToken = ""
  )

  $route = "/explore/status/probe-checklist"
  Invoke-Adb -DeviceId $DeviceId -Arguments @("shell", "cmd", "statusbar", "collapse") | Out-Null
  if (-not $NightscoutBaseUrl -and -not $NightscoutToken) {
    $currentXml = Get-AdbUiXml -DeviceId $DeviceId -ArtifactDir $ArtifactDir -Name "probe-route-current"
    if (Test-ProbeChecklistVisible -UiXml $currentXml) {
      Wait-ProbeNotRunning `
        -DeviceId $DeviceId `
        -ArtifactDir $ArtifactDir `
        -TimeoutSeconds 75 | Out-Null
      return
    }
  }
  $query = @()
  if ($NightscoutBaseUrl) {
    $query += "nightscoutUrl=$([System.Uri]::EscapeDataString($NightscoutBaseUrl))"
  }
  if ($NightscoutToken) {
    $query += "nightscoutToken=$([System.Uri]::EscapeDataString($NightscoutToken))"
  }
  $query += "probeRunId=$([System.Uri]::EscapeDataString([guid]::NewGuid().ToString('N')))"
  if ($query.Count -gt 0) {
    $route = "$route?$($query -join '&')"
  }

  $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
  $lastError = $null
  $usedColdStart = $false
  do {
    if ($lastError -and -not $usedColdStart) {
      Stop-ProbeApp -DeviceId $DeviceId -Package $Package
      Start-Sleep -Milliseconds 900
      Start-ProbeApp -DeviceId $DeviceId -Package $Package
      Start-Sleep -Seconds 8
      $usedColdStart = $true
    }
    Open-DebugRoute `
      -DeviceId $DeviceId `
      -Package $Package `
      -Route $route
    Start-Sleep -Milliseconds 1200
    try {
      Wait-ProbeChecklistVisible `
        -DeviceId $DeviceId `
        -ArtifactDir $ArtifactDir `
        -TimeoutSeconds 4 | Out-Null
      $lastError = $null
      break
    } catch {
      if (Open-ProbeChecklistFromStatusDashboard -DeviceId $DeviceId -ArtifactDir $ArtifactDir) {
        try {
          Wait-ProbeChecklistVisible `
            -DeviceId $DeviceId `
            -ArtifactDir $ArtifactDir `
            -TimeoutSeconds 8 | Out-Null
          $lastError = $null
          break
        } catch {
          $lastError = $_
        }
      } else {
        $lastError = $_
      }
      Start-Sleep -Milliseconds 1100
    }
  } while ((Get-Date) -lt $deadline)

  if ($lastError) {
    throw $lastError
  }

  Wait-ProbeNotRunning `
    -DeviceId $DeviceId `
    -ArtifactDir $ArtifactDir `
    -TimeoutSeconds 75 | Out-Null
}

function Invoke-ProbeRunChecks {
  param(
    [Parameter(Mandatory = $true)][string]$DeviceId,
    [Parameter(Mandatory = $true)][string]$ArtifactDir,
    [int]$TimeoutSeconds = 45
  )

  Wait-ProbeNotRunning -DeviceId $DeviceId -ArtifactDir $ArtifactDir -TimeoutSeconds 75 | Out-Null
  $before = Get-AdbUiXml -DeviceId $DeviceId -ArtifactDir $ArtifactDir -Name "before-run"
  $center = Get-UiNodeCenterByText -UiXml $before -Text "Run checks"
  $attempts = 0
  while ($null -eq $center -and $attempts -lt 4) {
    # If the checklist is scrolled down, pull the scrollable area back toward
    # the top so the primary action row is visible to UIAutomator.
    Invoke-Adb -DeviceId $DeviceId -Arguments @("shell", "input", "swipe", "800", "740", "800", "2140", "420") | Out-Null
    Start-Sleep -Milliseconds 500
    $before = Get-AdbUiXml -DeviceId $DeviceId -ArtifactDir $ArtifactDir -Name "before-run-scroll-$attempts"
    $center = Get-UiNodeCenterByText -UiXml $before -Text "Run checks"
    $attempts++
  }
  if ($null -eq $center) {
    throw "Could not find the 'Run checks' button in UIAutomator XML."
  }

  Invoke-Adb -DeviceId $DeviceId -Arguments @("shell", "input", "tap", "$($center.x)", "$($center.y)") | Out-Null

  $sawRunning = $false
  $deadline = (Get-Date).AddSeconds($TimeoutSeconds)
  do {
    Start-Sleep -Milliseconds 800
    $xml = Get-AdbUiXml -DeviceId $DeviceId -ArtifactDir $ArtifactDir -Name "during-run"
    if ($xml.Contains("Running...")) {
      $sawRunning = $true
    }
    $hasSuiteEvidence = $xml.Contains("Phone environment") -and
      $xml.Contains("xDrip+") -and
      $xml.Contains("Nightscout") -and
      $xml.Contains("score")
    if ($sawRunning -and $hasSuiteEvidence -and -not $xml.Contains("Running...")) {
      return $xml
    }
    if ($hasSuiteEvidence -and -not $xml.Contains("Running...")) {
      return $xml
    }
  } while ((Get-Date) -lt $deadline)

  $finalXml = Get-AdbUiXml -DeviceId $DeviceId -ArtifactDir $ArtifactDir -Name "after-timeout"
  $hasFinalSuiteEvidence = $finalXml.Contains("Phone environment") -and
    $finalXml.Contains("xDrip+") -and
    $finalXml.Contains("Nightscout") -and
    $finalXml.Contains("score")
  if ($hasFinalSuiteEvidence -and -not $finalXml.Contains("Running...")) {
    return $finalXml
  }
  throw "Probe run did not complete within $TimeoutSeconds seconds."
}

function Get-ProbeChecklistExpandedXml {
  param(
    [Parameter(Mandatory = $true)][string]$DeviceId,
    [Parameter(Mandatory = $true)][string]$ArtifactDir
  )

  $suites = @(
    @{ label = "Phone environment"; firstRow = "Network connectivity" },
    @{ label = "xDrip+"; firstRow = "xDrip+ package visibility" },
    @{ label = "Juggluco"; firstRow = "Juggluco package visibility" },
    @{ label = "Nightscout"; firstRow = "Nightscout status endpoint" },
    @{ label = "AAPS"; firstRow = "AAPS package visibility" },
    @{ label = "Watch display"; firstRow = "Watch bridge package" }
  )

  $combined = @()

  # Start from the top of the checklist so each suite can be reached in order.
  for ($i = 0; $i -lt 3; $i++) {
    Invoke-Adb -DeviceId $DeviceId -Arguments @("shell", "input", "swipe", "800", "760", "800", "2200", "360") | Out-Null
    Start-Sleep -Milliseconds 250
  }

  foreach ($suite in $suites) {
    $captured = $false
    for ($attempt = 0; $attempt -lt 8; $attempt++) {
      $xml = Get-AdbUiXml `
        -DeviceId $DeviceId `
        -ArtifactDir $ArtifactDir `
        -Name "expanded-$($suite.label -replace '[^A-Za-z0-9]+', '-')-$attempt"

      if ($xml.Contains($suite.label)) {
        if (-not $xml.Contains($suite.firstRow)) {
          $center = Get-UiNodeCenterByText -UiXml $xml -Text $suite.label
          if ($null -ne $center) {
            Invoke-Adb -DeviceId $DeviceId -Arguments @("shell", "input", "tap", "$($center.x)", "$($center.y)") | Out-Null
            Start-Sleep -Milliseconds 650
            $xml = Get-AdbUiXml `
              -DeviceId $DeviceId `
              -ArtifactDir $ArtifactDir `
              -Name "expanded-$($suite.label -replace '[^A-Za-z0-9]+', '-')-open"
          }
        }

        $combined += $xml
        $captured = $true
        break
      }

      Invoke-Adb -DeviceId $DeviceId -Arguments @("shell", "input", "swipe", "800", "2100", "800", "820", "420") | Out-Null
      Start-Sleep -Milliseconds 350
    }

    if (-not $captured) {
      $combined += Get-AdbUiXml `
        -DeviceId $DeviceId `
        -ArtifactDir $ArtifactDir `
        -Name "expanded-$($suite.label -replace '[^A-Za-z0-9]+', '-')-missing"
    }
  }

  return ($combined -join "`n")
}
