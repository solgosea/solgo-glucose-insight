$ErrorActionPreference = "Stop"

function New-ProbeCaseResult {
  param(
    [Parameter(Mandatory = $true)][string]$Name,
    [Parameter(Mandatory = $true)][string]$ArtifactDir,
    [Parameter(Mandatory = $true)][string]$UiXml,
    [string[]]$RequiredTexts = @()
  )

  $missing = @()
  foreach ($text in $RequiredTexts) {
    if (-not $UiXml.Contains($text)) {
      $missing += $text
    }
  }

  $yesCount = ([regex]::Matches($UiXml, "(?<![A-Za-z])Yes(?![A-Za-z])")).Count
  $noCount = ([regex]::Matches($UiXml, "(?<![A-Za-z])No(?![A-Za-z])")).Count
  $unknownCount = ([regex]::Matches($UiXml, "Unknown|No recent evidence|Not observed")).Count

  return [ordered]@{
    name = $Name
    passed = ($missing.Count -eq 0)
    missingTexts = $missing
    yesCount = $yesCount
    noCount = $noCount
    unknownCount = $unknownCount
    artifactDir = $ArtifactDir
  }
}

function Save-ProbeSummary {
  param(
    [Parameter(Mandatory = $true)]$Summary,
    [Parameter(Mandatory = $true)][string]$OutputPath
  )

  $Summary | ConvertTo-Json -Depth 8 | Set-Content -Path $OutputPath -Encoding UTF8
}

function Convert-UiXmlToVisibleText {
  param([Parameter(Mandatory = $true)][string]$UiXml)

  $values = @()
  foreach ($match in [regex]::Matches($UiXml, "(?:text|content-desc)=`"([^`"]*)`"")) {
    $value = [System.Net.WebUtility]::HtmlDecode($match.Groups[1].Value)
    if ($value) {
      $values += $value
    }
  }
  return ($values -join "`n")
}

function Get-ProbeRowObservation {
  param(
    [Parameter(Mandatory = $true)][string]$VisibleText,
    [Parameter(Mandatory = $true)][string]$Title
  )

  $lines = $VisibleText -split "`r?`n" |
    ForEach-Object { $_.Trim() } |
    Where-Object { $_ }

  for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -ne $Title) {
      continue
    }

    $window = @()
    for ($j = $i; $j -lt [Math]::Min($lines.Count, $i + 6); $j++) {
      $window += $lines[$j]
    }
    $status = "unknown"
    for ($j = $i + 1; $j -lt [Math]::Min($lines.Count, $i + 5); $j++) {
      if ($lines[$j] -eq "Yes") {
        $status = "yes"
        break
      }
      if ($lines[$j] -eq "No") {
        $status = "no"
        break
      }
    }
    $summary = if ($window.Count -ge 3) { $window[2] } else { "" }
    return [ordered]@{
      title = $Title
      found = $true
      status = $status
      summary = $summary
      lines = $window
    }
  }

  return [ordered]@{
    title = $Title
    found = $false
    status = "missing"
    summary = ""
    lines = @()
  }
}
