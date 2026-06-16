# xDrip+ Local Connection Guide

Solgo Insight can read glucose data from the local xDrip+ web service.

This is useful when you already use xDrip+ as your local CGM data hub and want Solgo Insight to review, analyze, and display the data without requiring Nightscout as the first path.

## Before You Start

- xDrip+ should already be receiving glucose data.
- Solgo Insight and xDrip+ should be installed on the Android device you want to use.
- This guide uses the xDrip+ local web service path.

Solgo Insight does not replace xDrip+. xDrip+ remains responsible for CGM collection and its own alert workflow.

## Step 1: Open xDrip+ Settings

In xDrip+, open the main menu and tap **Settings**.

<img src="assets/guides/xdrip-local/01-open-xdrip-settings.png" alt="Open xDrip+ settings" width="420">

## Step 2: Open Inter-app Settings

Scroll down in xDrip+ settings and open **Inter-app settings**.

<img src="assets/guides/xdrip-local/02-open-inter-app-settings.png" alt="Open xDrip+ inter-app settings" width="420">

## Step 3: Enable xDrip Web Service

In **Inter-app settings**, enable **xDrip Web Service**.

This allows compatible apps such as Solgo Insight to read glucose data from xDrip+ locally.

<img src="assets/guides/xdrip-local/03-enable-xdrip-web-service.png" alt="Enable xDrip Web Service in xDrip+ inter-app settings" width="420">

## About Open Web Service

xDrip+ may also show an **Open Web Service** option.

For many same-device setups, enabling **xDrip Web Service** is the first setting to try.

Only enable **Open Web Service** if your setup requires access from another device or your local configuration needs it. This option may allow connections beyond the current device, so it has security and privacy implications.

## Then Connect in Solgo Insight

After enabling the xDrip+ web service:

1. Open Solgo Insight.
2. Go to **Data Source**.
3. Choose **xDrip+ Local**.
4. Test the connection.
5. Save the data source if the connection succeeds.

If the connection does not work, check that xDrip+ is running, receiving glucose data, and that the web service option is enabled.

## Notes

- xDrip+ Local is useful for users who prefer local data paths.
- Nightscout is still supported, but it is not required for every setup.
- Refresh behavior may depend on xDrip+ settings, Android background behavior, and device power restrictions.
- Do not expose local glucose services to a network unless you understand the security implications.
