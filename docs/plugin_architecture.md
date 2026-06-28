# Solgo Insight Plugin Architecture

Solgo Insight uses a static plugin architecture. Features are compiled into the app, while the release matrix controls which modules are visible and active in each public build.

The v0.6.0 community preview keeps the public source focused on the released scope:

- Home
- History
- Stats
- Profile basics
- Settings basics
- Data source setup
- Target range
- Insights
- High Episode
- Low Episode
- Report
- Glance surfaces
- Local alerts
- Background glucose sync
- Status Monitor beta

Unreleased internal modules are intentionally not included in this repository release.

## Architecture Goals

- Keep each feature isolated enough to evolve without rewriting the whole app.
- Let public builds expose only the features that are ready for community testing.
- Keep shared services, charts, sync, units, settings, and navigation outside feature modules.
- Allow future plugin-like surfaces such as reports, widgets, floating views, and troubleshooting flows to reuse common infrastructure.

## Main Layers

```text
lib/app/
  App shell, routing, and dependency wiring.

lib/domain/
  Core entities and source-independent business types.

lib/application/
  Sync, polling, settings, runtime coordination, and use cases.

lib/data/
  Local SQLite storage, settings storage, and data source implementations.

lib/plugin_platform/
  Static plugin contracts, placement, routing, registry, runtime state, and release controls.

lib/plugins/
  Feature modules.

lib/presentation/common/
  Shared UI components such as charts, date filters, sync status, and reusable layout pieces.
```

## Plugin Platform

Each feature declares:

- plugin id
- title and description
- release stage
- placement
- data requirements
- routes
- optional home, profile, settings, background, or explore entries

The app builds a registry from:

```text
lib/plugins/plugin_catalog.dart
lib/plugins/plugin_release_config.dart
lib/plugins/release/
```

The registry decides what appears in the UI for the active release profile.

## Public Release Profile

The public community preview uses the `ossPreview` release profile. This profile enables the current public scope and hides unreleased modules.

The intent is simple: users and contributors should see only the code and UI that match the public README and release notes.

## Status Monitor

Status Monitor is implemented as a feature plugin, but it also uses native Android receivers and probe/evidence services where available.

Its job is not to replace xDrip+, Nightscout, Juggluco, WatchDrip, AAPS, or CGM manufacturer apps. Its job is to collect practical evidence and help users understand where to look first when the glucose data chain appears broken.

## Report Layer

Reports are treated as a shared output layer. Feature modules provide structured report data; the report runtime is responsible for rendering review-friendly pages, exports, and shareable summaries.

This keeps analysis logic separate from the final report format.

## Development Commands

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d android
```

For release builds, configure a local signing file from `android/key.properties.example`. Private signing keys must never be committed.
