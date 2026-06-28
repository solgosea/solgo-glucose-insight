# Status Monitor Probe Lab

Probe Lab is the orchestration layer for real-device Status Monitor probe validation.
It composes the lower-level `probe_matrix` scripts instead of duplicating probe
execution logic.

## Validation layers

1. Protocol evidence injection: send xDrip/Juggluco/Nightscout evidence to
   SolgoInsight and verify each probe row.
2. External app presence: build/install xDrip, Juggluco, AAPS, and watchdrip from
   `_external`, then verify package visibility probes.
3. Full-chain checklist: run the Probe Checklist UI and archive screenshot,
   UI XML, logcat, and JSON summaries.

## Examples

```powershell
# Core protocol + Nightscout + checklist validation.
powershell -ExecutionPolicy Bypass -File scripts/status_monitor/probe_lab/run_all.ps1 -DeviceId <adb-id>

# Single probe matrix.
powershell -ExecutionPolicy Bypass -File scripts/status_monitor/probe_lab/run_single_probe.ps1 `
  -DeviceId <adb-id> `
  -ProbeIds xdrip.broadcast.bg_estimate,xdrip.broadcast.freshness

# Suite matrix.
powershell -ExecutionPolicy Bypass -File scripts/status_monitor/probe_lab/run_suite.ps1 `
  -DeviceId <adb-id> `
  -Suites xdrip,juggluco,nightscout

# Build/install external apps when APKs or sources are ready.
powershell -ExecutionPolicy Bypass -File scripts/status_monitor/probe_lab/install/install_external_apps.ps1 `
  -DeviceId <adb-id> `
  -AppIds xdrip,juggluco,aaps,watch `
  -Build
```

## Boundary

The current `directReceiver` injection mode validates SolgoInsight receivers and
probe logic. Real external-app behavior should use UIAutomator or debug-only
fixture receivers in the external app builds. Fixture mode intentionally throws
until those receivers exist, so tests cannot silently fake downstream AAPS or
watch evidence.

