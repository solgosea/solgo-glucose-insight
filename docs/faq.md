# SmartXDrip FAQ

## Does SmartXDrip use raw xDrip+ Local data?

Yes.

When xDrip+ Local is configured, SmartXDrip reads raw glucose readings from the xDrip+ local web service.

SmartXDrip does not import xDrip+'s precomputed stats or display values. It syncs glucose readings, stores them locally, and calculates its own Home, History, Stats, Insights, and chart views from those readings.

## Does SmartXDrip require Nightscout?

No.

SmartXDrip can use xDrip+ Local as a data source when it is available.

Nightscout is also supported, but it is not required for every setup. Users who prefer local data can use xDrip+ Local without forcing glucose data through a cloud path.

## How do I set up xDrip+ Local?

See the [xDrip+ Local Connection Guide](xdrip-local-connection-guide.md).

The short version is:

1. Open xDrip+ settings.
2. Open **Inter-app settings**.
3. Enable **xDrip Web Service**.
4. Open SmartXDrip.
5. Go to **Data Source** and connect **xDrip+ Local**.

## Does SmartXDrip import xDrip+ stats?

No.

SmartXDrip currently calculates its own stats from synced glucose readings.

This means SmartXDrip may not always match xDrip+'s internal stats exactly, especially if:

- The initial sync has not completed.
- The available history window is different.
- xDrip+ and SmartXDrip use different calculation windows.
- The displayed metric has a different meaning.

## Why is the delta different from xDrip+?

This may be a display meaning difference rather than a sync problem.

xDrip+ may show the reading-to-reading delta, for example:

```text
-1 mg/dL since the last reading
```

SmartXDrip may show a rate per minute, for example:

```text
-0.2 mg/dL/min
```

If glucose changed by about `-1 mg/dL` over roughly 5 minutes, the per-minute rate would be about:

```text
-0.2 mg/dL/min
```

SmartXDrip will continue improving the UI wording so users can clearly distinguish:

- Reading-to-reading delta
- Rate per minute
- Trend direction

## Why are Stats or Insights incomplete after first setup?

SmartXDrip calculates Stats and Insights from the readings that have been synced locally.

After first setup, the amount of available history depends on:

- The selected data source
- What xDrip+ Local or Nightscout returns
- The configured initial sync window
- Whether background sync has had time to run

Stats and Insights become more useful after enough history has been synced.

## Why is the widget small?

SmartXDrip includes multiple widget layouts and sizes.

Some widgets are intentionally compact for quick viewing. Larger layouts can show more context.

To add a larger widget:

```text
Long press Home Screen
-> Widgets
-> SmartXDrip
-> choose a larger layout
```

Different Android launchers may also render widget sizes differently.

## Does SmartXDrip replace xDrip+?

No.

SmartXDrip is a companion app for people who already use xDrip+ and Nightscout.

xDrip+ remains responsible for important core workflows such as:

- CGM collection
- Device integration
- xDrip+ alerts
- xDrip+ watch features
- Existing diabetes operation workflows

SmartXDrip focuses on:

- Data review
- Analysis
- Insights
- History
- Stats
- Episode analysis
- Quick-glance views

## Will SmartXDrip support Wear OS?

Wear OS support is not a current focus.

xDrip+ already has strong Wear OS support, including watch faces and complications. SmartXDrip's current focus is data review, analysis, insights, and Android glance surfaces such as widgets and persistent notification previews.

This may be revisited later, but the current roadmap is focused on SmartXDrip's differentiation as a data analysis and companion experience.

## Known issue: alert unit display

Some alert text may still show `mmol/L` even when the app display unit is set to `mg/dL`.

This is being reviewed. The intended behavior is that user-facing alert text should respect the selected glucose unit, while internal glucose calculations can continue using normalized storage units.

## Is SmartXDrip a medical device?

No.

SmartXDrip is not a medical device and should not be used as the only basis for treatment decisions.

Always follow your care plan and consult qualified healthcare professionals.
