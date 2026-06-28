$ErrorActionPreference = "Stop"

function Save-ProbeLabSummary {
  param(
    [Parameter(Mandatory = $true)]$Summary,
    [Parameter(Mandatory = $true)][string]$OutputPath
  )

  $Summary |
    ConvertTo-Json -Depth 12 |
    Set-Content -Path $OutputPath -Encoding UTF8
}

function Add-ProbeLabStep {
  param(
    [Parameter(Mandatory = $true)][System.Collections.IList]$Steps,
    [Parameter(Mandatory = $true)][string]$Name,
    [Parameter(Mandatory = $true)][scriptblock]$Action
  )

  $startedAt = Get-Date
  try {
    $result = & $Action
    $Steps.Add([ordered]@{
      name = $Name
      ok = $true
      startedAt = $startedAt.ToString("o")
      finishedAt = (Get-Date).ToString("o")
      result = $result
    }) | Out-Null
    return $result
  } catch {
    $Steps.Add([ordered]@{
      name = $Name
      ok = $false
      startedAt = $startedAt.ToString("o")
      finishedAt = (Get-Date).ToString("o")
      error = $_.Exception.Message
    }) | Out-Null
    throw
  }
}

