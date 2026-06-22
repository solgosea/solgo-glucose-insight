// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'glance_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class GlanceLocalizationsEn extends GlanceLocalizations {
  GlanceLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get pluginTitle => 'Widgets & Notification';

  @override
  String get pluginSubtitle =>
      'Home widgets, notifications, and Floating Glance.';

  @override
  String get pluginDescription =>
      'Home widgets, notifications, and Floating Glance.';

  @override
  String get pluginReportTitle => 'Widgets & Notification Report';

  @override
  String get pluginLoading => 'Loading';

  @override
  String get pluginNoData => 'No data available yet.';

  @override
  String get pluginUnavailable => 'Unavailable';

  @override
  String get glancePrivacySection => 'Privacy';

  @override
  String get glanceLowBatterySubtitle =>
      'Reduces refresh frequency to save power';

  @override
  String get glanceLockScreenModeTitle => 'Lock screen glance';

  @override
  String get glanceHubTitle => 'Widgets & Notifications';

  @override
  String get floatingUnavailableAction => 'Unavailable';

  @override
  String get floatingVisibleBody =>
      'Drag it anywhere. Tap the floating view to return to the app.';

  @override
  String get glanceGraphExpandedSubtitle =>
      'Show a small trend graph inside expanded notification';

  @override
  String get glanceWidgetTemplatesSection => 'Widget templates';

  @override
  String get glanceShowNotificationTitle => 'Show in notification bar';

  @override
  String get glancePersistentNotificationSection => 'Persistent notification';

  @override
  String get glanceIosWidgetGuide =>
      'Add SolgoInsight Glance from the iOS widget picker. Home and Lock Screen widgets update from the last shared Glance snapshot.';

  @override
  String get glanceNotificationSettingsSection => 'Notification settings';

  @override
  String get glanceLockScreenModeSubtitle =>
      'Choose full value, range-only, or private mode';

  @override
  String get glanceAndroidWidgetGuide =>
      'Android does not let apps place widgets for you. This is a system action, and steps may vary slightly by phone brand.';

  @override
  String get glanceLockScreenGlanceTitle => 'Lock Screen Glance';

  @override
  String get floatingVisibleTitle => 'Floating Glance is visible now';

  @override
  String get glanceTabNotifications => 'Notifications';

  @override
  String get floatingUnavailableTitle => 'Floating Glance is unavailable';

  @override
  String get floatingPermissionNeededBody =>
      'Allow display over other apps first. Return here after Android grants the permission.';

  @override
  String get glanceNotificationPrivacySection => 'Notification privacy';

  @override
  String get floatingPermissionNeededTitle => 'Floating permission needed';

  @override
  String get glancePrivateModeTitle => 'Private mode text';

  @override
  String get floatingPermissionGrantedBody =>
      'Tap once to place Floating Glance on your screen.';

  @override
  String get floatingHiddenTitle => 'Floating Glance is hidden';

  @override
  String get glanceFloatingSection => 'Floating glance';

  @override
  String get glanceFloatingCardTitle => 'Floating Glance';

  @override
  String get glanceFloatingCardBody =>
      'Allows SolgoInsight to show glucose above other apps. It stays silent and only mirrors Glance status.';

  @override
  String get glanceFloatingVisiblePill => 'VISIBLE';

  @override
  String get glanceFloatingSetupPill => 'SETUP';

  @override
  String get glanceFloatingSizeTitle => 'Floating Glance size';

  @override
  String get glanceFloatingSizeAuto => 'Auto';

  @override
  String get glanceFloatingSizeSmall => 'Small';

  @override
  String get glanceFloatingSizeMedium => 'Medium';

  @override
  String get glanceFloatingSizeLarge => 'Large';

  @override
  String get glanceFloatingShapeTitle => 'Shape';

  @override
  String get glanceFloatingShapePill => 'Pill';

  @override
  String get glanceFloatingShapeCard => 'Card';

  @override
  String glanceFloatingRecommendedPreset(String size, String shape) {
    return 'Recommended for this device: $size $shape';
  }

  @override
  String get glanceFloatingCustomPreset =>
      'Custom size. Your choice will not be changed automatically.';

  @override
  String get floatingUnavailableBody =>
      'This device does not expose the Android floating overlay service.';

  @override
  String get glanceHomeScreenWidgetSubtitle =>
      'Small and medium widgets use the latest Glance snapshot';

  @override
  String get glanceAddHomeScreenSection => 'Add to home screen';

  @override
  String get glanceShowNotificationSubtitle =>
      'Always-on glucose status, silent and low-priority';

  @override
  String get floatingShowAction => 'Show Floating Glance';

  @override
  String get floatingHiddenBody =>
      'Permission is ready. Show it again when you want a screen overlay.';

  @override
  String get glanceHomeScreenWidgetTitle => 'Home Screen Widget';

  @override
  String get glanceLockAodSection => 'Lock screen & AOD';

  @override
  String get glanceGraphExpandedTitle => 'Graph in expanded view';

  @override
  String get glanceLockScreenGlanceSubtitle =>
      'Accessory widget on iOS 16+. AOD follows iOS behavior.';

  @override
  String get glanceAodFriendlySection => 'AOD-friendly';

  @override
  String get glanceLowBatteryTitle => 'Low-battery friendly mode';

  @override
  String get floatingHideAction => 'Hide Floating Glance';

  @override
  String get floatingPermissionGrantedTitle =>
      'Floating Glance permission granted';

  @override
  String get floatingPermissionNeededAction => 'Enable floating permission';

  @override
  String get glanceQuickActionsTitle => 'Quick actions';

  @override
  String get glanceTabWidgets => 'Widgets';

  @override
  String get glanceHomeLockWidgetsSection => 'Home & lock screen widgets';

  @override
  String get glancePrivateModeSubtitle =>
      'Glucose data available - Unlock to view';

  @override
  String get glanceQuickActionsSubtitle =>
      'Open app, data source, and settings';

  @override
  String get glanceNotificationPreviewDataSource => 'Data source';

  @override
  String glanceFloatingPreviewSourceUpdated(String freshness, String source) {
    return 'SOURCE $source - updated $freshness';
  }

  @override
  String get glanceWidgetGraphRange => 'Graph range';

  @override
  String get glanceWidgetLastUpdated => 'Last updated';

  @override
  String get glanceNotificationPreviewOpen => 'Open';

  @override
  String get glanceWidgetShowOnWidget => 'Show on widget';

  @override
  String get glanceWidgetMiniGraph => 'Mini graph';

  @override
  String get glanceNotificationPreviewFlat => 'Flat';

  @override
  String get glanceNotificationPreviewSettings => 'Settings';

  @override
  String get glanceWidgetTrendArrow => 'Trend arrow';

  @override
  String get glanceNotificationPreviewTir24h => 'TIR 24H';

  @override
  String get glanceNotificationPreviewSource => 'Source';

  @override
  String get glanceWidgetAddWidget => 'Add widget';

  @override
  String get glanceNotificationPreviewTrend => 'Trend';

  @override
  String get glanceWidgetDelta => 'Delta';

  @override
  String get glanceFloatingPreviewWindow => 'Window';

  @override
  String get glanceWidgetTapAction => 'Tap action';

  @override
  String get glanceFloatingPreviewCompact => 'Compact';

  @override
  String get glanceFloatingPreviewExpanded => 'Expanded';

  @override
  String get glancePrivateUnlockToView => 'Unlock to view current glucose';

  @override
  String get glancePrivateDataAvailable => 'Glucose data available';

  @override
  String glanceFloatingPreviewUpdated(String freshness) {
    return 'Updated $freshness';
  }

  @override
  String get glanceNotificationGlucoseDataAvailable => 'Glucose data available';

  @override
  String get glanceNotificationSourceOffline => 'Source offline';

  @override
  String get glanceNotificationGlucoseStale => 'Glucose stale';

  @override
  String get glanceNotificationHidden => 'Glance hidden';

  @override
  String get glanceNotificationHiddenOnLockScreen =>
      'Glance is hidden on lock screen';

  @override
  String get glanceNotificationUnlockCurrentGlucose =>
      'Unlock to view current glucose';

  @override
  String get glanceNotificationNoRecentGlucoseData => 'No recent glucose data';

  @override
  String get glanceNotificationRangeHigh => 'High';

  @override
  String get glanceNotificationRangeLow => 'Low';

  @override
  String get glanceNotificationRangeInRange => 'In range';

  @override
  String get glanceNotificationStatusAvailable => 'Glucose status available';

  @override
  String get glanceNotificationChannelTitle => 'Glance status';

  @override
  String get glanceNotificationChannelDescription =>
      'Lock screen glucose status without sound or vibration.';
}
