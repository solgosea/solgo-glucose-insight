import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'glance_localizations_en.dart';
import 'glance_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of GlanceLocalizations
/// returned by `GlanceLocalizations.of(context)`.
///
/// Applications need to include `GlanceLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/glance_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: GlanceLocalizations.localizationsDelegates,
///   supportedLocales: GlanceLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the GlanceLocalizations.supportedLocales
/// property.
abstract class GlanceLocalizations {
  GlanceLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static GlanceLocalizations of(BuildContext context) {
    return Localizations.of<GlanceLocalizations>(context, GlanceLocalizations)!;
  }

  static const LocalizationsDelegate<GlanceLocalizations> delegate =
      _GlanceLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')
  ];

  /// No description provided for @pluginTitle.
  ///
  /// In en, this message translates to:
  /// **'Widgets & Notification'**
  String get pluginTitle;

  /// No description provided for @pluginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Home widgets, notifications, and Floating Glance.'**
  String get pluginSubtitle;

  /// No description provided for @pluginDescription.
  ///
  /// In en, this message translates to:
  /// **'Home widgets, notifications, and Floating Glance.'**
  String get pluginDescription;

  /// No description provided for @pluginReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Widgets & Notification Report'**
  String get pluginReportTitle;

  /// No description provided for @pluginLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get pluginLoading;

  /// No description provided for @pluginNoData.
  ///
  /// In en, this message translates to:
  /// **'No data available yet.'**
  String get pluginNoData;

  /// No description provided for @pluginUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get pluginUnavailable;

  /// No description provided for @glancePrivacySection.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get glancePrivacySection;

  /// No description provided for @glanceLowBatterySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reduces refresh frequency to save power'**
  String get glanceLowBatterySubtitle;

  /// No description provided for @glanceLockScreenModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Lock screen glance'**
  String get glanceLockScreenModeTitle;

  /// No description provided for @glanceHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Widgets & Notifications'**
  String get glanceHubTitle;

  /// No description provided for @floatingUnavailableAction.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get floatingUnavailableAction;

  /// No description provided for @floatingVisibleBody.
  ///
  /// In en, this message translates to:
  /// **'Drag it anywhere. Tap the floating view to return to the app.'**
  String get floatingVisibleBody;

  /// No description provided for @glanceGraphExpandedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show a small trend graph inside expanded notification'**
  String get glanceGraphExpandedSubtitle;

  /// No description provided for @glanceWidgetTemplatesSection.
  ///
  /// In en, this message translates to:
  /// **'Widget templates'**
  String get glanceWidgetTemplatesSection;

  /// No description provided for @glanceShowNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Show in notification bar'**
  String get glanceShowNotificationTitle;

  /// No description provided for @glancePersistentNotificationSection.
  ///
  /// In en, this message translates to:
  /// **'Persistent notification'**
  String get glancePersistentNotificationSection;

  /// No description provided for @glanceIosWidgetGuide.
  ///
  /// In en, this message translates to:
  /// **'Add SolgoInsight Glance from the iOS widget picker. Home and Lock Screen widgets update from the last shared Glance snapshot.'**
  String get glanceIosWidgetGuide;

  /// No description provided for @glanceNotificationSettingsSection.
  ///
  /// In en, this message translates to:
  /// **'Notification settings'**
  String get glanceNotificationSettingsSection;

  /// No description provided for @glanceLockScreenModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose full value, range-only, or private mode'**
  String get glanceLockScreenModeSubtitle;

  /// No description provided for @glanceAndroidWidgetGuide.
  ///
  /// In en, this message translates to:
  /// **'Android does not let apps place widgets for you. This is a system action, and steps may vary slightly by phone brand.'**
  String get glanceAndroidWidgetGuide;

  /// No description provided for @glanceLockScreenGlanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Lock Screen Glance'**
  String get glanceLockScreenGlanceTitle;

  /// No description provided for @floatingVisibleTitle.
  ///
  /// In en, this message translates to:
  /// **'Floating Glance is visible now'**
  String get floatingVisibleTitle;

  /// No description provided for @glanceTabNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get glanceTabNotifications;

  /// No description provided for @floatingUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Floating Glance is unavailable'**
  String get floatingUnavailableTitle;

  /// No description provided for @floatingPermissionNeededBody.
  ///
  /// In en, this message translates to:
  /// **'Allow display over other apps first. Return here after Android grants the permission.'**
  String get floatingPermissionNeededBody;

  /// No description provided for @glanceNotificationPrivacySection.
  ///
  /// In en, this message translates to:
  /// **'Notification privacy'**
  String get glanceNotificationPrivacySection;

  /// No description provided for @floatingPermissionNeededTitle.
  ///
  /// In en, this message translates to:
  /// **'Floating permission needed'**
  String get floatingPermissionNeededTitle;

  /// No description provided for @glancePrivateModeTitle.
  ///
  /// In en, this message translates to:
  /// **'Private mode text'**
  String get glancePrivateModeTitle;

  /// No description provided for @floatingPermissionGrantedBody.
  ///
  /// In en, this message translates to:
  /// **'Tap once to place Floating Glance on your screen.'**
  String get floatingPermissionGrantedBody;

  /// No description provided for @floatingHiddenTitle.
  ///
  /// In en, this message translates to:
  /// **'Floating Glance is hidden'**
  String get floatingHiddenTitle;

  /// No description provided for @glanceFloatingSection.
  ///
  /// In en, this message translates to:
  /// **'Floating glance'**
  String get glanceFloatingSection;

  /// No description provided for @glanceFloatingCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Floating Glance'**
  String get glanceFloatingCardTitle;

  /// No description provided for @glanceFloatingCardBody.
  ///
  /// In en, this message translates to:
  /// **'Allows SolgoInsight to show glucose above other apps. It stays silent and only mirrors Glance status.'**
  String get glanceFloatingCardBody;

  /// No description provided for @glanceFloatingVisiblePill.
  ///
  /// In en, this message translates to:
  /// **'VISIBLE'**
  String get glanceFloatingVisiblePill;

  /// No description provided for @glanceFloatingSetupPill.
  ///
  /// In en, this message translates to:
  /// **'SETUP'**
  String get glanceFloatingSetupPill;

  /// No description provided for @glanceFloatingSizeTitle.
  ///
  /// In en, this message translates to:
  /// **'Floating Glance size'**
  String get glanceFloatingSizeTitle;

  /// No description provided for @glanceFloatingSizeAuto.
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get glanceFloatingSizeAuto;

  /// No description provided for @glanceFloatingSizeSmall.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get glanceFloatingSizeSmall;

  /// No description provided for @glanceFloatingSizeMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get glanceFloatingSizeMedium;

  /// No description provided for @glanceFloatingSizeLarge.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get glanceFloatingSizeLarge;

  /// No description provided for @glanceFloatingShapeTitle.
  ///
  /// In en, this message translates to:
  /// **'Shape'**
  String get glanceFloatingShapeTitle;

  /// No description provided for @glanceFloatingShapePill.
  ///
  /// In en, this message translates to:
  /// **'Pill'**
  String get glanceFloatingShapePill;

  /// No description provided for @glanceFloatingShapeCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get glanceFloatingShapeCard;

  /// No description provided for @glanceFloatingRecommendedPreset.
  ///
  /// In en, this message translates to:
  /// **'Recommended for this device: {size} {shape}'**
  String glanceFloatingRecommendedPreset(String size, String shape);

  /// No description provided for @glanceFloatingCustomPreset.
  ///
  /// In en, this message translates to:
  /// **'Custom size. Your choice will not be changed automatically.'**
  String get glanceFloatingCustomPreset;

  /// No description provided for @floatingUnavailableBody.
  ///
  /// In en, this message translates to:
  /// **'This device does not expose the Android floating overlay service.'**
  String get floatingUnavailableBody;

  /// No description provided for @glanceHomeScreenWidgetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Small and medium widgets use the latest Glance snapshot'**
  String get glanceHomeScreenWidgetSubtitle;

  /// No description provided for @glanceAddHomeScreenSection.
  ///
  /// In en, this message translates to:
  /// **'Add to home screen'**
  String get glanceAddHomeScreenSection;

  /// No description provided for @glanceShowNotificationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Always-on glucose status, silent and low-priority'**
  String get glanceShowNotificationSubtitle;

  /// No description provided for @floatingShowAction.
  ///
  /// In en, this message translates to:
  /// **'Show Floating Glance'**
  String get floatingShowAction;

  /// No description provided for @floatingHiddenBody.
  ///
  /// In en, this message translates to:
  /// **'Permission is ready. Show it again when you want a screen overlay.'**
  String get floatingHiddenBody;

  /// No description provided for @glanceHomeScreenWidgetTitle.
  ///
  /// In en, this message translates to:
  /// **'Home Screen Widget'**
  String get glanceHomeScreenWidgetTitle;

  /// No description provided for @glanceLockAodSection.
  ///
  /// In en, this message translates to:
  /// **'Lock screen & AOD'**
  String get glanceLockAodSection;

  /// No description provided for @glanceGraphExpandedTitle.
  ///
  /// In en, this message translates to:
  /// **'Graph in expanded view'**
  String get glanceGraphExpandedTitle;

  /// No description provided for @glanceLockScreenGlanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Accessory widget on iOS 16+. AOD follows iOS behavior.'**
  String get glanceLockScreenGlanceSubtitle;

  /// No description provided for @glanceAodFriendlySection.
  ///
  /// In en, this message translates to:
  /// **'AOD-friendly'**
  String get glanceAodFriendlySection;

  /// No description provided for @glanceLowBatteryTitle.
  ///
  /// In en, this message translates to:
  /// **'Low-battery friendly mode'**
  String get glanceLowBatteryTitle;

  /// No description provided for @floatingHideAction.
  ///
  /// In en, this message translates to:
  /// **'Hide Floating Glance'**
  String get floatingHideAction;

  /// No description provided for @floatingPermissionGrantedTitle.
  ///
  /// In en, this message translates to:
  /// **'Floating Glance permission granted'**
  String get floatingPermissionGrantedTitle;

  /// No description provided for @floatingPermissionNeededAction.
  ///
  /// In en, this message translates to:
  /// **'Enable floating permission'**
  String get floatingPermissionNeededAction;

  /// No description provided for @glanceQuickActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get glanceQuickActionsTitle;

  /// No description provided for @glanceTabWidgets.
  ///
  /// In en, this message translates to:
  /// **'Widgets'**
  String get glanceTabWidgets;

  /// No description provided for @glanceHomeLockWidgetsSection.
  ///
  /// In en, this message translates to:
  /// **'Home & lock screen widgets'**
  String get glanceHomeLockWidgetsSection;

  /// No description provided for @glancePrivateModeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Glucose data available - Unlock to view'**
  String get glancePrivateModeSubtitle;

  /// No description provided for @glanceQuickActionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open app, data source, and settings'**
  String get glanceQuickActionsSubtitle;

  /// No description provided for @glanceNotificationPreviewDataSource.
  ///
  /// In en, this message translates to:
  /// **'Data source'**
  String get glanceNotificationPreviewDataSource;

  /// No description provided for @glanceFloatingPreviewSourceUpdated.
  ///
  /// In en, this message translates to:
  /// **'SOURCE {source} - updated {freshness}'**
  String glanceFloatingPreviewSourceUpdated(String freshness, String source);

  /// No description provided for @glanceWidgetGraphRange.
  ///
  /// In en, this message translates to:
  /// **'Graph range'**
  String get glanceWidgetGraphRange;

  /// No description provided for @glanceWidgetLastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated'**
  String get glanceWidgetLastUpdated;

  /// No description provided for @glanceNotificationPreviewOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get glanceNotificationPreviewOpen;

  /// No description provided for @glanceWidgetShowOnWidget.
  ///
  /// In en, this message translates to:
  /// **'Show on widget'**
  String get glanceWidgetShowOnWidget;

  /// No description provided for @glanceWidgetMiniGraph.
  ///
  /// In en, this message translates to:
  /// **'Mini graph'**
  String get glanceWidgetMiniGraph;

  /// No description provided for @glanceNotificationPreviewFlat.
  ///
  /// In en, this message translates to:
  /// **'Flat'**
  String get glanceNotificationPreviewFlat;

  /// No description provided for @glanceNotificationPreviewSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get glanceNotificationPreviewSettings;

  /// No description provided for @glanceWidgetTrendArrow.
  ///
  /// In en, this message translates to:
  /// **'Trend arrow'**
  String get glanceWidgetTrendArrow;

  /// No description provided for @glanceNotificationPreviewTir24h.
  ///
  /// In en, this message translates to:
  /// **'TIR 24H'**
  String get glanceNotificationPreviewTir24h;

  /// No description provided for @glanceNotificationPreviewSource.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get glanceNotificationPreviewSource;

  /// No description provided for @glanceWidgetAddWidget.
  ///
  /// In en, this message translates to:
  /// **'Add widget'**
  String get glanceWidgetAddWidget;

  /// No description provided for @glanceNotificationPreviewTrend.
  ///
  /// In en, this message translates to:
  /// **'Trend'**
  String get glanceNotificationPreviewTrend;

  /// No description provided for @glanceWidgetDelta.
  ///
  /// In en, this message translates to:
  /// **'Delta'**
  String get glanceWidgetDelta;

  /// No description provided for @glanceFloatingPreviewWindow.
  ///
  /// In en, this message translates to:
  /// **'Window'**
  String get glanceFloatingPreviewWindow;

  /// No description provided for @glanceWidgetTapAction.
  ///
  /// In en, this message translates to:
  /// **'Tap action'**
  String get glanceWidgetTapAction;

  /// No description provided for @glanceFloatingPreviewCompact.
  ///
  /// In en, this message translates to:
  /// **'Compact'**
  String get glanceFloatingPreviewCompact;

  /// No description provided for @glanceFloatingPreviewExpanded.
  ///
  /// In en, this message translates to:
  /// **'Expanded'**
  String get glanceFloatingPreviewExpanded;

  /// No description provided for @glancePrivateUnlockToView.
  ///
  /// In en, this message translates to:
  /// **'Unlock to view current glucose'**
  String get glancePrivateUnlockToView;

  /// No description provided for @glancePrivateDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'Glucose data available'**
  String get glancePrivateDataAvailable;

  /// No description provided for @glanceFloatingPreviewUpdated.
  ///
  /// In en, this message translates to:
  /// **'Updated {freshness}'**
  String glanceFloatingPreviewUpdated(String freshness);

  /// No description provided for @glanceNotificationGlucoseDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'Glucose data available'**
  String get glanceNotificationGlucoseDataAvailable;

  /// No description provided for @glanceNotificationSourceOffline.
  ///
  /// In en, this message translates to:
  /// **'Source offline'**
  String get glanceNotificationSourceOffline;

  /// No description provided for @glanceNotificationGlucoseStale.
  ///
  /// In en, this message translates to:
  /// **'Glucose stale'**
  String get glanceNotificationGlucoseStale;

  /// No description provided for @glanceNotificationHidden.
  ///
  /// In en, this message translates to:
  /// **'Glance hidden'**
  String get glanceNotificationHidden;

  /// No description provided for @glanceNotificationHiddenOnLockScreen.
  ///
  /// In en, this message translates to:
  /// **'Glance is hidden on lock screen'**
  String get glanceNotificationHiddenOnLockScreen;

  /// No description provided for @glanceNotificationUnlockCurrentGlucose.
  ///
  /// In en, this message translates to:
  /// **'Unlock to view current glucose'**
  String get glanceNotificationUnlockCurrentGlucose;

  /// No description provided for @glanceNotificationNoRecentGlucoseData.
  ///
  /// In en, this message translates to:
  /// **'No recent glucose data'**
  String get glanceNotificationNoRecentGlucoseData;

  /// No description provided for @glanceNotificationRangeHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get glanceNotificationRangeHigh;

  /// No description provided for @glanceNotificationRangeLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get glanceNotificationRangeLow;

  /// No description provided for @glanceNotificationRangeInRange.
  ///
  /// In en, this message translates to:
  /// **'In range'**
  String get glanceNotificationRangeInRange;

  /// No description provided for @glanceNotificationStatusAvailable.
  ///
  /// In en, this message translates to:
  /// **'Glucose status available'**
  String get glanceNotificationStatusAvailable;

  /// No description provided for @glanceNotificationChannelTitle.
  ///
  /// In en, this message translates to:
  /// **'Glance status'**
  String get glanceNotificationChannelTitle;

  /// No description provided for @glanceNotificationChannelDescription.
  ///
  /// In en, this message translates to:
  /// **'Lock screen glucose status without sound or vibration.'**
  String get glanceNotificationChannelDescription;
}

class _GlanceLocalizationsDelegate
    extends LocalizationsDelegate<GlanceLocalizations> {
  const _GlanceLocalizationsDelegate();

  @override
  Future<GlanceLocalizations> load(Locale locale) {
    return SynchronousFuture<GlanceLocalizations>(
        lookupGlanceLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_GlanceLocalizationsDelegate old) => false;
}

GlanceLocalizations lookupGlanceLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return GlanceLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return GlanceLocalizationsEn();
    case 'zh':
      return GlanceLocalizationsZh();
  }

  throw FlutterError(
      'GlanceLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
