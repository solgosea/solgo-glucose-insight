# Solgo Insight Test Guide

This project keeps tests close to the app architecture so contributors can change one layer without guessing which behavior they broke.

## Test Layers

- `test/application`
  Application services, sync pipeline steps, unit formatting, scheduling, and runtime coordination.
- `test/data`
  SQLite persistence, mock data generation, Nightscout API source, and xDrip+ local source behavior.
- `test/plugins`
  Feature-level tests for Home, History, Stats, Report, Status Monitor, alerts, settings, profile, and data source modules.
- `test/presentation`
  Shared presentation behavior such as sync status and reusable UI state mapping.
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

Run a focused test:

```powershell
flutter test test/plugins/status_monitor
```

## Data Source Test Strategy

Nightscout and xDrip+ tests use local mocks and fake sources where possible. Tests should verify:

- source availability behavior
- idempotent persistence by reading timestamp
- mg/dL and mmol/L normalization
- sync cursor updates
- stale, delayed, and unavailable source states

## Status Monitor Test Strategy

Status Monitor tests should focus on evidence and state transitions rather than UI wording:

- component evidence collection
- hub path diagnosis
- probe checklist flow
- rule-engine outputs
- history snapshots
- report summaries

## SQLite Test Strategy

SQLite tests use `sqflite_common_ffi` and in-memory databases where possible. This keeps tests fast and prevents test runs from touching a developer's local app data.

## Adding Tests

Prefer one focused test file per architectural boundary. If a test needs CGM readings, use existing fixtures or fake glucose sources instead of real personal data.
