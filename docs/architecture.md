# Solgo Insight Architecture Notes

Solgo Insight is being built as an open-source companion platform around xDrip+ and Nightscout data.

The goal is not only to provide a few screens on top of CGM data. The goal is to build a maintainable architecture where features can evolve based on real user feedback without turning the app into a tightly coupled collection of screens.

## Architecture Direction

Solgo Insight is moving toward a **plugin + host architecture**.

The host app provides the shared foundation:

- App shell
- Navigation
- Shared settings
- Data source coordination
- Sync runtime
- Background runtime
- Analysis session
- Alert runtime foundation
- Plugin lifecycle
- Shared UI primitives

Feature areas are implemented as plugins where possible:

- Home
- History
- Stats
- Insights
- Data Source
- Glance Layer
- Alerting
- High / Low Episode analysis
- Profile / target range

This structure is intended to keep feature boundaries clear while allowing the product to grow step by step.

## Why Plugin + Host

Solgo Insight is expected to evolve through community feedback.

Some features may become core. Some may remain experimental. Some may only make sense for certain workflows or release profiles.

A plugin + host model helps the project:

- Add new feature modules without tightly coupling them to unrelated screens.
- Keep the public community preview focused on currently released functionality.
- Disable unreleased or experimental features from public builds.
- Share common services across features without duplicating logic.
- Keep runtime behavior easier to test and reason about.
- Support future release profiles with different feature sets.
- Make larger changes possible without forcing every feature to know about every other feature.

## Main Layers

The current architecture can be understood in several layers.

### Host Application Layer

The host application owns the main app structure.

Responsibilities include:

- App startup
- Dependency container
- Routing
- Global settings
- Theme
- Main navigation shell
- Plugin registration
- Platform capability detection

The host should know how to install and run plugins, but feature-specific behavior should stay inside each plugin when possible.

### Plugin Platform Layer

The plugin platform provides the shared contracts used by feature modules.

It includes concepts such as:

- Plugin identity
- Plugin lifecycle
- Plugin routes
- Plugin runtime state
- Plugin release stage
- Plugin capability contracts
- Plugin composition
- Plugin render slots

This layer is designed to let the host app compose features without hardcoding every detail into the main app shell.

### Feature Plugin Layer

Feature plugins provide user-facing functionality.

Examples:

- Home plugin
- History plugin
- Statistics plugin
- Insights plugin
- Data Source plugin
- Glance plugin
- Alerting plugin
- Explore / episode analysis plugins

A feature plugin may provide:

- Pages
- Widgets
- Runtime behavior
- Snapshot preheating
- Navigation entries
- Settings entries
- Profile sections
- Background capabilities
- Data or schema contributions

The purpose is to keep each feature area easier to maintain and easier to remove or evolve independently.

### Application Service Layer

Application services provide shared use cases and orchestration.

Examples include:

- Data source connection
- Glucose sync
- Foreground reconcile
- Background sync
- Polling runtime
- Sync runtime
- Analysis refresh
- Subject / session state
- Glucose unit formatting
- Insight rendering
- Settings updates

This layer contains app-level logic that should not belong to UI widgets or individual screens.

### Domain Layer

The domain layer defines core concepts used across the app.

Examples include:

- Glucose readings
- Glucose events
- App settings
- Data source kind
- Sync status
- Polling mode
- Insight type
- Analysis subject
- Alert event
- Alert rule
- Widget template

The domain layer should stay relatively stable and independent from UI details.

### Data and Infrastructure Layer

This layer handles persistence, platform APIs, and external communication.

Examples include:

- SQLite storage
- Settings storage
- Nightscout API source
- xDrip+ Local HTTP source
- Android background service
- Android widgets
- Local notifications
- Platform channels

This layer is where the app talks to the operating system, local database, and configured data sources.

## Runtime Design

Solgo Insight needs to handle glucose data across several situations:

- App is open
- App resumes from background
- App is running in background
- Widget needs fresh data
- Notification needs updated status
- Source becomes unavailable
- User changes data source settings

To make this easier to reason about, the runtime is being separated into focused components.

### Sync Runtime

The sync runtime coordinates glucose data synchronization.

It is responsible for:

- Running source sync safely
- Avoiding duplicate concurrent sync runs
- Reporting completion
- Updating affected subjects
- Feeding analysis refresh and UI updates

### Polling Runtime

The polling runtime controls repeated work.

It is responsible for:

- Scheduling polling jobs
- Applying retry / backoff behavior
- Triggering immediate refresh when needed
- Avoiding uncontrolled repeated work

### Foreground Reconcile

Foreground reconcile handles app resume and foreground refresh behavior.

It helps decide whether the app should:

- Use a light refresh
- Run a full sync
- Reuse recent background results
- Update UI status without unnecessary network work

### Background Runtime

The background runtime supports longer-running Android behavior, especially for:

- Background sync
- Widget freshness
- Persistent notification updates
- Alert runtime coordination

Android background behavior varies by device and power settings, so this layer is expected to continue evolving.

## Glance Layer Design

The Glance Layer is designed as a dedicated plugin rather than a small extension of the Home screen.

It includes:

- Glance plugin runtime
- Glance snapshot builder
- Widget configuration service
- Persistent notification service
- Android widget bridge
- Render payload builder
- Widget template model
- Widget settings persistence

This separation matters because widgets and persistent notifications have different runtime needs than normal app screens.

For example:

- They may need updates when the app is not open.
- They need compact, stable render payloads.
- They must work with Android widget constraints.
- They should not depend directly on Home UI widgets.

## Data Source Design

Solgo Insight currently focuses on data users already collect through xDrip+ and Nightscout.

Supported preview sources:

- xDrip+ Local
- Nightscout

The Data Source plugin manages source setup and source state.

The shared sync pipeline handles:

- Source availability checks
- Fetching glucose readings
- Normalizing readings
- Merging readings into canonical local storage
- Recording sync success or failure
- Reporting freshness status

The intent is to make data source behavior explicit and testable.

## Alerting Design

The current public preview includes a local alert engine foundation.

Alerts are disabled by default.

The alerting architecture is separated into:

- Alert rules
- Alert events
- Alert policy engine
- Delivery pipeline
- Sound strategy
- Vibration strategy
- Notification strategy
- Runtime coordination
- Settings UI

The reason for this separation is that alert behavior needs to be cautious, testable, and configurable.

Solgo Insight should not introduce aggressive alert behavior without careful review and user feedback.

## Analysis and Insight Design

Solgo Insight separates analysis from presentation.

The analysis pipeline works with structured glucose data and produces facts or snapshots.

The insight rendering layer turns those facts into readable summaries.

This is intended to avoid hardcoding static text into UI components and to make future insight improvements easier to test.

Current analysis areas include:

- Time in range
- Variability
- Daily summary
- Period summary
- High / low episode analysis
- Pattern-oriented insight summaries

## Public Preview Scope

The public community preview is intentionally scoped.

The current preview includes:

- Home
- History
- Stats
- Insights
- High / Low Episode analysis
- xDrip+ Local data source
- Nightscout data source
- Background sync foundation
- Android widgets
- Persistent notification preview
- Chart touch inspection
- Local alert foundation, disabled by default

The public repository does not include every internal experiment or future feature idea.

This is intentional. The goal is to keep the public code aligned with what users can actually test now.

## Engineering Principles

Solgo Insight is being built with several practical engineering principles.

### Keep User-Facing Scope Clear

The public preview should match the features users can actually try.

Unreleased or internal-only features should not create confusion in the public repository.

### Keep Feature Boundaries Explicit

Features should have clear ownership and minimal dependency on unrelated features.

This helps future refactoring and community review.

### Prefer Runtime Clarity

Sync, polling, background work, and alerting should be visible in code as explicit runtime systems rather than hidden side effects.

### Make Data Freshness Understandable

CGM data is time-sensitive.

The app should make freshness, delay, stale data, and source status understandable to users.

### Build for Feedback

Solgo Insight is still early.

The architecture should make it possible to respond to community feedback without requiring the whole app to be rewritten for every new feature.

## Current Status

v0.2.0 is an Android-first community preview.

The architecture is still evolving, but the current direction is clear:

**Solgo Insight is becoming a plugin-based companion platform around xDrip+ and Nightscout data, focused on review, insight, quick-glance access, and user-driven feature evolution.**
