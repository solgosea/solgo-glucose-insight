# Changelog

All notable changes to this project will be documented in this file.

Format: [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)  
Versioning: [Semantic Versioning](https://semver.org/)

## [Unreleased]

## [0.1.0] - 2026-06-04

### Added
- Home page: real-time glucose reading, trend direction, insight banner
- History: day-level CGM review with high and low episode entry points
- Statistics: TIR, AGP, variability, and daily summary metrics
- Insights: CGM-derived summaries and pattern prompts
- Episodes: high and low episode detection and focused review pages
- Profile: data source configuration
- Settings: display, data, export
- Data sources: xDrip+ local web service, Nightscout API, and built-in mock data
- Alerting Core: local glucose alert rules, sounds, snooze, and actuator support
- Local SQLite cache with background polling
- Pure-Dart analysis engine: TIR, CV, dawn detection, and episode detection
- Python mock Nightscout server (`mockserver/`) with CGM scenario presets
