# Solgo Insight Community Preview

Solgo Insight is an open-source companion app for people who already use
[xDrip+](https://github.com/NightscoutFoundation/xDrip) and
[Nightscout](https://github.com/nightscout/cgm-remote-monitor).

This preview focuses on making existing CGM data easier to review, understand,
and discuss with the community. It does not replace xDrip+, Nightscout, a CGM
manufacturer app, or medical advice.

> Previously published as SmartXDrip Community Preview. The project has been
> renamed to Solgo Insight to make it clearer that this is an independent
> companion app, not an official xDrip+ project, fork, or replacement.

## Download

**Android APK:**  
https://github.com/solgosea/solgo-glucose-insight/releases/download/v0.3.0-community-preview/solgo-insight-community-preview-v0.3.0-android.apk

Latest preview: **v0.3.0 Community Preview**

## What's New in v0.3.0

This release improves the quick-glance experience for daily CGM use.

- Added **Floating Glance** for checking glucose status over other apps.
- Improved the Android **Glance Layer** for widgets and always-visible status.
- Added a floating glucose preview for current glucose, trend, delta, and update time.
- Updated Home CV to focus on the recent **24-hour** window.
- Improved Stats time windows, including short-range review such as **24h** and **3d**.
- Continued refining the plugin + host architecture so Glance, Home, and Stats can evolve independently.

Floating Glance requires Android overlay permission. On some devices, users may
need to allow Solgo Insight to display over other apps.

## v0.3.0 Preview

| Floating glance | Floating widget preview |
| --- | --- |
| <img src="docs/assets/release/v0.3.0/floating-glance.png" alt="Solgo Insight floating glance over other apps" width="360"> | <img src="docs/assets/release/v0.3.0/floating-widget-preview.png" alt="Solgo Insight floating widget preview" width="360"> |

| Home 24h CV | Stats time windows |
| --- | --- |
| <img src="docs/assets/release/v0.3.0/home-24h-cv.png" alt="Solgo Insight Home 24 hour CV" width="360"> | <img src="docs/assets/release/v0.3.0/stats-time-windows.png" alt="Solgo Insight Stats time window selection" width="360"> |

## What's New in v0.2.0

- Improved data refresh behavior for xDrip+ Local and Nightscout sources.
- Added Android Glance widgets for quick glucose viewing.
- Added a persistent notification preview for always-visible glucose status.
- Added chart touch inspection to check readings at specific points in time.
- Improved Home view controls, including glucose unit switching and clearer sync status.
- Added a local alert engine foundation, disabled by default.
- Cleaned the public preview scope so unreleased/internal features are not exposed.

## v0.2.0 Preview

| Home features | Target range |
| --- | --- |
| <img src="docs/assets/release/v0.2.0/home-overview-sync-status.png" alt="Solgo Insight Home overview and sync status" width="360"> | <img src="docs/assets/release/v0.2.0/target-range-settings.png" alt="Solgo Insight target range settings" width="360"> |

| Widget entry | Configure widgets |
| --- | --- |
| <img src="docs/assets/release/v0.2.0/glance-widget-entry.png" alt="Solgo Insight Glance widget entry" width="360"> | <img src="docs/assets/release/v0.2.0/glance-widget-configuration.png" alt="Solgo Insight Glance widget configuration" width="360"> |

| Add widget | Persistent notification |
| --- | --- |
| <img src="docs/assets/release/v0.2.0/android-add-glance-widget.png" alt="Add Solgo Insight Glance widget on Android" width="360"> | <img src="docs/assets/release/v0.2.0/persistent-notification-preview.png" alt="Solgo Insight persistent notification preview" width="360"> |

## Demo

**Demo video:**  
https://www.youtube.com/watch?v=UfjxgaeEwZA

**Playlist:**  
https://www.youtube.com/watch?v=QZl0NSckXYI&list=PLKDhx_9jUu-74px9PGC62dwRQwsXWhLxi

## Current Preview Scope

- Home view with current glucose, trend, range, TIR, and quick insights.
- History view with daily review and high/low episode entry points.
- Stats view for TIR, variability, AGP-style overview, and summary metrics.
- Insights view for readable glucose pattern summaries.
- High Episode and Low Episode analysis.
- xDrip+ Local and Nightscout data source setup.
- Background sync foundation for keeping data fresh.
- Local alert engine for glucose-related reminders.
- Glance Layer: Android widgets and persistent notification preview.
- Chart touch inspection for checking the reading at a specific point.

More features will be added step by step based on community feedback.

## Data Source Setup

Solgo Insight can use xDrip+ Local or Nightscout as data sources.

For xDrip+ Local setup, see the [xDrip+ Local Connection Guide](docs/xdrip-local-connection-guide.md).

## FAQ

Have questions about local xDrip+ data, Nightscout, widget sizes, delta
differences, or whether Solgo Insight replaces xDrip+?

See the [Solgo Insight FAQ](docs/faq.md).

## Architecture Direction

Solgo Insight is being built as a plugin + host companion platform around xDrip+
and Nightscout data.

The app separates the host shell, feature plugins, shared runtime services, and
capability boundaries so the public preview can stay focused while the product
continues to evolve based on community feedback.

Current architecture areas include:

- Feature plugins for Home, History, Stats, Insights, Data Source, Glance, and Alerts.
- Shared runtime layers for sync, polling, foreground reconcile, and background work.
- Capability boundaries for data sources, alerting, analysis sessions, and background sync.
- Android-first Glance infrastructure for widgets and persistent notification previews.

For more details, see [Architecture Notes](docs/architecture.md).

## Privacy

- No account is required.
- Glucose data is stored locally on the device.
- Network calls are made only to data sources you configure, such as xDrip+
  Local or your own Nightscout site.
- This repository does not include telemetry or advertising SDKs.

## Medical Disclaimer

Solgo Insight is not a medical device. It is for personal data review, education,
and community feedback. Do not make treatment decisions based only on this app.
Always follow your care plan and consult qualified healthcare professionals.

## Development

```bash
flutter pub get
flutter run -d android
```

This public preview is Android-first.
