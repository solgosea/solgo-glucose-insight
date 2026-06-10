# Smart xDrip Test Guide

This project keeps tests close to the app architecture so contributors can
change one layer without guessing which behavior they broke.

## Test Layers

- `test/engine`
  Pure glucose algorithms such as TIR, episode detection, and gap detection.
- `test/application`
  Application services, sync pipeline steps, unit formatting, templates, and
  analysis modules.
- `test/data`
  SQLite persistence, mock data generation, Nightscout API source, and xDrip+
  local HTTP source behavior.
- `test/integration`
  Local mock HTTP flows that exercise source parsing, sync coordination, and
  persistence together.
- `test/_support`
  Shared fixtures, fake sources, test databases, and mock HTTP servers.

## Local Commands

Run static analysis:

```powershell
flutter analyze
```

Run all tests:

```powershell
flutter test
```

Run the full local check:

```powershell
.\scripts\test_all.ps1
```

## Data Source Test Strategy

Nightscout and xDrip+ local HTTP tests use `MockCgmHttpServer`. The mock server
serves Nightscout-compatible endpoints:

- `/api/v1/status.json`
- `/api/v1/entries/sgv.json`

All source tests assert that incoming `sgv` values in `mg/dL` are normalized to
the app's internal `mmol/L` model before persistence.

## SQLite Test Strategy

SQLite tests use `sqflite_common_ffi` and an in-memory database through
`GlucoseDatabase(databaseFactoryOverride, databasePathOverride)`. This keeps
tests fast and prevents changes from touching a developer's local app data.

## Sync Flow Test Strategy

Sync tests cover:

- step ordering and short-circuit behavior in `GlucoseSyncPipeline`
- source availability handling
- idempotent persistence by reading timestamp
- success cursor updates
- unavailable source error recording

## Adding Tests

Prefer one focused test file per architectural boundary. If a test needs CGM
readings, use `CgmReadingsFixture`. If it needs a source, use
`FakeGlucoseSource` for unit-level behavior or `MockCgmHttpServer` for HTTP
flow behavior.
