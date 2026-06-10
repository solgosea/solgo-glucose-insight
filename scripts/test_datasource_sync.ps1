$ErrorActionPreference = "Stop"

Push-Location (Split-Path -Parent $PSScriptRoot)
try {
  Write-Host "== SmartXDrip datasource sync coverage ==" -ForegroundColor Cyan

  $groups = @(
    "test\application\sync",
    "test\application\sync_orchestration",
    "test\application\glucose_etl",
    "test\application\data_source",
    "test\application\polling",
    "test\integration\mock_nightscout_sync_flow_test.dart",
    "test\integration\datasource"
  )

  foreach ($target in $groups) {
    Write-Host "`n>> flutter test $target" -ForegroundColor Green
    flutter test $target
  }

  Write-Host "`n>> flutter analyze" -ForegroundColor Green
  flutter analyze

  Write-Host "`nDatasource sync coverage completed." -ForegroundColor Cyan
}
finally {
  Pop-Location
}
