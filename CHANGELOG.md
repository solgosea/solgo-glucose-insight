# Changelog

All notable changes to this project will be documented in this file.

## [0.6.0] - 2026-06-28

### Added

- Added the public **Status Monitor beta** as a complete released feature scope.
- Added probe setup flows for checking whether useful evidence is available from external apps and configured sources.
- Added xDrip-centered connection health analysis for understanding how components relate to each other.
- Added component-level monitoring for source freshness, delay, availability, and supporting evidence.
- Added Status Monitor evidence support for xDrip+, Nightscout, Juggluco-related paths, AAPS-related paths, and watch display scenarios where evidence is available.
- Added Status Monitor report output for review and sharing.
- Added the **Smart Date Selection** foundation across date-related screens.
- Added multilingual architecture for the public preview.
- Added the report layer foundation.
- Added high and low episode report support.
- Added v0.6.0 preview screenshot assets for the GitHub project page.

### Changed

- Optimized the data sync layer with **Smart Sync** behavior.
- Added support for incremental sync for recent windows.
- Added support for sync behavior that uses the Settings sync window.
- Reworked sync boundaries so Home, History, Stats, Reports, and Status Monitor can share a more consistent data foundation.
- Updated date selection behavior so common windows and custom ranges can be handled more consistently across analysis and report surfaces.
- Reworked the data analysis engine boundaries so analysis, report generation, and UI presentation are easier to evolve independently.
- Improved History and High / Low Episode review flows.
- Improved Status Monitor UI direction from flat component cards toward a more practical troubleshooting model.
- Improved floating widget sizing behavior.
- Updated the public README around Solgo Insight positioning, download, privacy, and v0.6.0 scope.
- Renamed public-facing project copy to Solgo Insight.

### Removed

- Removed unpublished internal modules from the community preview build.
- Removed unreleased internal care, messaging, cloud relay, and music modules from this public source release.
- Removed advanced analysis plugins that are not part of the current community preview scope.
- Removed internal setup notes that are not relevant to this public release.

### Verified

- `flutter analyze` passes with no issues after the v0.6.0 sync and cleanup.

## [0.5.x and earlier]

Earlier community preview builds focused on Home, History, Stats, local alerts, glance widgets, high/low episode review, and the first Status Monitor experiments. The v0.6.0 release is the first public source update after the larger Status Monitor and report-layer architecture refresh.
