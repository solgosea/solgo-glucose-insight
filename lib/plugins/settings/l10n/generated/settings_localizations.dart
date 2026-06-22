import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'settings_localizations_en.dart';
import 'settings_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of SettingsLocalizations
/// returned by `SettingsLocalizations.of(context)`.
///
/// Applications need to include `SettingsLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/settings_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: SettingsLocalizations.localizationsDelegates,
///   supportedLocales: SettingsLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the SettingsLocalizations.supportedLocales
/// property.
abstract class SettingsLocalizations {
  SettingsLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static SettingsLocalizations of(BuildContext context) {
    return Localizations.of<SettingsLocalizations>(context, SettingsLocalizations)!;
  }

  static const LocalizationsDelegate<SettingsLocalizations> delegate = _SettingsLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
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

  /// No description provided for @settingsDangerDescription.
  ///
  /// In en, this message translates to:
  /// **'Destructive local data actions.'**
  String get settingsDangerDescription;

  /// No description provided for @settingsDisplaySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Units and presentation preferences'**
  String get settingsDisplaySubtitle;

  /// No description provided for @settingsDisplayTitle.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get settingsDisplayTitle;

  /// No description provided for @settingsDangerTitle.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get settingsDangerTitle;

  /// No description provided for @settingsExportTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Export'**
  String get settingsExportTitle;

  /// No description provided for @settingsAboutDescription.
  ///
  /// In en, this message translates to:
  /// **'Application metadata and support links.'**
  String get settingsAboutDescription;

  /// No description provided for @settingsStorageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Local data storage summary'**
  String get settingsStorageSubtitle;

  /// No description provided for @settingsDangerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Destructive local data actions'**
  String get settingsDangerSubtitle;

  /// No description provided for @settingsSyncSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sync window and source preferences'**
  String get settingsSyncSubtitle;

  /// No description provided for @settingsExportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Export local glucose data'**
  String get settingsExportSubtitle;

  /// No description provided for @settingsExportDescription.
  ///
  /// In en, this message translates to:
  /// **'Export local glucose data.'**
  String get settingsExportDescription;

  /// No description provided for @settingsSyncTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync Settings'**
  String get settingsSyncTitle;

  /// No description provided for @settingsAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAboutTitle;

  /// No description provided for @settingsDisplayDescription.
  ///
  /// In en, this message translates to:
  /// **'Display preferences for glucose units.'**
  String get settingsDisplayDescription;

  /// No description provided for @settingsStorageTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Storage'**
  String get settingsStorageTitle;

  /// No description provided for @settingsAboutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'App information and support links'**
  String get settingsAboutSubtitle;

  /// No description provided for @settingsStorageDescription.
  ///
  /// In en, this message translates to:
  /// **'Local glucose data storage summary.'**
  String get settingsStorageDescription;

  /// No description provided for @settingsSyncDescription.
  ///
  /// In en, this message translates to:
  /// **'Initial sync window and source sync preferences.'**
  String get settingsSyncDescription;

  /// No description provided for @pluginUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get pluginUnavailable;

  /// No description provided for @pluginReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings Report'**
  String get pluginReportTitle;

  /// No description provided for @pluginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Display, sync, storage, export, and safety settings.'**
  String get pluginSubtitle;

  /// No description provided for @pluginTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get pluginTitle;

  /// No description provided for @pluginDescription.
  ///
  /// In en, this message translates to:
  /// **'Display, sync, storage, export, and safety settings.'**
  String get pluginDescription;

  /// No description provided for @pluginNoData.
  ///
  /// In en, this message translates to:
  /// **'No data available yet.'**
  String get pluginNoData;

  /// No description provided for @pluginLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get pluginLoading;

  /// No description provided for @settingsExportNoReadings.
  ///
  /// In en, this message translates to:
  /// **'No readings to export yet.'**
  String get settingsExportNoReadings;

  /// No description provided for @settingsAllLocalDataCleared.
  ///
  /// In en, this message translates to:
  /// **'All local data cleared.'**
  String get settingsAllLocalDataCleared;

  /// No description provided for @settingsUnitsLabel.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get settingsUnitsLabel;

  /// No description provided for @settingsDeleteEverything.
  ///
  /// In en, this message translates to:
  /// **'Delete everything'**
  String get settingsDeleteEverything;

  /// No description provided for @settingsClearAllDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear all data'**
  String get settingsClearAllDataTitle;

  /// No description provided for @settingsRetentionPeriodLabel.
  ///
  /// In en, this message translates to:
  /// **'Retention period'**
  String get settingsRetentionPeriodLabel;

  /// No description provided for @settingsDaysSuffix.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get settingsDaysSuffix;

  /// No description provided for @settingsInitialSyncWindowLabel.
  ///
  /// In en, this message translates to:
  /// **'Initial sync window'**
  String get settingsInitialSyncWindowLabel;

  /// No description provided for @settingsRetentionSummarySuffix.
  ///
  /// In en, this message translates to:
  /// **'No data leaves this device'**
  String get settingsRetentionSummarySuffix;

  /// No description provided for @settingsClearAllDataDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear all data?'**
  String get settingsClearAllDataDialogTitle;

  /// No description provided for @settingsDaysMax.
  ///
  /// In en, this message translates to:
  /// **'days max'**
  String get settingsDaysMax;

  /// No description provided for @settingsCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get settingsCancel;

  /// No description provided for @settingsRecommendedBalance.
  ///
  /// In en, this message translates to:
  /// **'Recommended balance'**
  String get settingsRecommendedBalance;

  /// No description provided for @settingsDaysCovered.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get settingsDaysCovered;

  /// No description provided for @settingsInitialSyncWindowSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Used when connecting a new source'**
  String get settingsInitialSyncWindowSubtitle;

  /// No description provided for @settingsOpenSourceLink.
  ///
  /// In en, this message translates to:
  /// **'Open source'**
  String get settingsOpenSourceLink;

  /// No description provided for @settingsStorageUsed.
  ///
  /// In en, this message translates to:
  /// **'used'**
  String get settingsStorageUsed;

  /// No description provided for @settingsBloodGlucoseUnitSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Blood glucose unit'**
  String get settingsBloodGlucoseUnitSubtitle;

  /// No description provided for @settingsRetentionPeriodSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Auto-trims older readings'**
  String get settingsRetentionPeriodSubtitle;

  /// No description provided for @settingsPrivacyLink.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get settingsPrivacyLink;

  /// No description provided for @settingsRetentionSummaryPrefix.
  ///
  /// In en, this message translates to:
  /// **'Data retention:'**
  String get settingsRetentionSummaryPrefix;

  /// No description provided for @settingsExportDataLabel.
  ///
  /// In en, this message translates to:
  /// **'Export data'**
  String get settingsExportDataLabel;

  /// No description provided for @settingsClearAllDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Permanently removes all stored readings'**
  String get settingsClearAllDataSubtitle;

  /// No description provided for @settingsExportDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save readings as CSV'**
  String get settingsExportDataSubtitle;

  /// No description provided for @settingsExportedTo.
  ///
  /// In en, this message translates to:
  /// **'Exported to:'**
  String get settingsExportedTo;

  /// No description provided for @settingsLocalStorageTitle.
  ///
  /// In en, this message translates to:
  /// **'Local storage'**
  String get settingsLocalStorageTitle;

  /// No description provided for @settingsClearAllDataDialogBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes all stored CGM readings, events, and analysis snapshots. This cannot be undone.'**
  String get settingsClearAllDataDialogBody;
}

class _SettingsLocalizationsDelegate extends LocalizationsDelegate<SettingsLocalizations> {
  const _SettingsLocalizationsDelegate();

  @override
  Future<SettingsLocalizations> load(Locale locale) {
    return SynchronousFuture<SettingsLocalizations>(lookupSettingsLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_SettingsLocalizationsDelegate old) => false;
}

SettingsLocalizations lookupSettingsLocalizations(Locale locale) {

  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh': {
  switch (locale.scriptCode) {
    case 'Hant': return SettingsLocalizationsZhHant();
   }
  break;
   }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return SettingsLocalizationsEn();
    case 'zh': return SettingsLocalizationsZh();
  }

  throw FlutterError(
    'SettingsLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
