import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'SolgoInsight'**
  String get appName;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get commonLoading;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get commonShare;

  /// No description provided for @commonPrint.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get commonPrint;

  /// No description provided for @commonExportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get commonExportPdf;

  /// No description provided for @commonNoData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get commonNoData;

  /// No description provided for @commonUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get commonUnavailable;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Display, sync window, storage, and export preferences.'**
  String get settingsSubtitle;

  /// No description provided for @settingsLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageTitle;

  /// No description provided for @settingsLanguageDescription.
  ///
  /// In en, this message translates to:
  /// **'App display language'**
  String get settingsLanguageDescription;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In en, this message translates to:
  /// **'Use system'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageSimplifiedChinese.
  ///
  /// In en, this message translates to:
  /// **'Simplified Chinese'**
  String get settingsLanguageSimplifiedChinese;

  /// No description provided for @settingsLanguageTraditionalChinese.
  ///
  /// In en, this message translates to:
  /// **'Traditional Chinese'**
  String get settingsLanguageTraditionalChinese;

  /// No description provided for @settingsLanguageChanged.
  ///
  /// In en, this message translates to:
  /// **'Language updated.'**
  String get settingsLanguageChanged;

  /// No description provided for @settingsBloodGlucoseUnit.
  ///
  /// In en, this message translates to:
  /// **'Blood glucose unit'**
  String get settingsBloodGlucoseUnit;

  /// No description provided for @settingsInitialSyncWindow.
  ///
  /// In en, this message translates to:
  /// **'Initial sync window'**
  String get settingsInitialSyncWindow;

  /// No description provided for @settingsRecommendedBalance.
  ///
  /// In en, this message translates to:
  /// **'Recommended balance'**
  String get settingsRecommendedBalance;

  /// No description provided for @settingsExportData.
  ///
  /// In en, this message translates to:
  /// **'Export data'**
  String get settingsExportData;

  /// No description provided for @settingsClearAllData.
  ///
  /// In en, this message translates to:
  /// **'Clear all data'**
  String get settingsClearAllData;

  /// No description provided for @timeJustNow.
  ///
  /// In en, this message translates to:
  /// **'just now'**
  String get timeJustNow;

  /// No description provided for @timeNever.
  ///
  /// In en, this message translates to:
  /// **'never'**
  String get timeNever;

  /// No description provided for @timeMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min ago'**
  String timeMinutesAgo(int minutes);

  /// No description provided for @timeHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String timeHoursAgo(int hours);

  /// No description provided for @timeDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days}d ago'**
  String timeDaysAgo(int days);

  /// No description provided for @durationSecondsShort.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s'**
  String durationSecondsShort(int seconds);

  /// No description provided for @durationMinutesShort.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m'**
  String durationMinutesShort(int minutes);

  /// No description provided for @durationHoursShort.
  ///
  /// In en, this message translates to:
  /// **'{hours}h'**
  String durationHoursShort(int hours);

  /// No description provided for @durationHoursMinutesShort.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m'**
  String durationHoursMinutesShort(int hours, int minutes);

  /// No description provided for @dateToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dateToday;

  /// No description provided for @dateYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get dateYesterday;

  /// No description provided for @dateTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get dateTomorrow;

  /// No description provided for @dayPeriodDawn.
  ///
  /// In en, this message translates to:
  /// **'dawn'**
  String get dayPeriodDawn;

  /// No description provided for @dayPeriodMorning.
  ///
  /// In en, this message translates to:
  /// **'morning'**
  String get dayPeriodMorning;

  /// No description provided for @dayPeriodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'afternoon'**
  String get dayPeriodAfternoon;

  /// No description provided for @dayPeriodEvening.
  ///
  /// In en, this message translates to:
  /// **'evening'**
  String get dayPeriodEvening;

  /// No description provided for @dayPeriodNight.
  ///
  /// In en, this message translates to:
  /// **'night'**
  String get dayPeriodNight;

  /// No description provided for @relativeDayPeriodToday.
  ///
  /// In en, this message translates to:
  /// **'today {period}'**
  String relativeDayPeriodToday(Object period);

  /// No description provided for @relativeDayPeriodYesterday.
  ///
  /// In en, this message translates to:
  /// **'yesterday {period}'**
  String relativeDayPeriodYesterday(Object period);

  /// No description provided for @relativeDayPeriodTomorrow.
  ///
  /// In en, this message translates to:
  /// **'tomorrow {period}'**
  String relativeDayPeriodTomorrow(Object period);

  /// No description provided for @syncNotSyncing.
  ///
  /// In en, this message translates to:
  /// **'Not syncing'**
  String get syncNotSyncing;

  /// No description provided for @syncWaiting.
  ///
  /// In en, this message translates to:
  /// **'waiting'**
  String get syncWaiting;

  /// No description provided for @syncNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Not configured'**
  String get syncNotConfigured;

  /// No description provided for @syncConfiguredNotSyncing.
  ///
  /// In en, this message translates to:
  /// **'Configured, not syncing'**
  String get syncConfiguredNotSyncing;

  /// No description provided for @syncWaitingFirstSync.
  ///
  /// In en, this message translates to:
  /// **'Waiting for first sync'**
  String get syncWaitingFirstSync;

  /// No description provided for @syncSynced.
  ///
  /// In en, this message translates to:
  /// **'Synced {relative}'**
  String syncSynced(Object relative);

  /// No description provided for @syncLastSynced.
  ///
  /// In en, this message translates to:
  /// **'Last synced {relative}'**
  String syncLastSynced(Object relative);

  /// No description provided for @syncFailed.
  ///
  /// In en, this message translates to:
  /// **'failed'**
  String get syncFailed;

  /// No description provided for @syncStatusWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get syncStatusWaiting;

  /// No description provided for @syncStatusSynced.
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get syncStatusSynced;

  /// No description provided for @syncStatusNeedsSync.
  ///
  /// In en, this message translates to:
  /// **'Needs sync'**
  String get syncStatusNeedsSync;

  /// No description provided for @syncStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get syncStatusFailed;

  /// No description provided for @syncLastFailed.
  ///
  /// In en, this message translates to:
  /// **'Last sync failed'**
  String get syncLastFailed;

  /// No description provided for @syncLastAttempt.
  ///
  /// In en, this message translates to:
  /// **'Last attempt {relative}'**
  String syncLastAttempt(Object relative);

  /// No description provided for @syncSchedulePending.
  ///
  /// In en, this message translates to:
  /// **'Schedule pending'**
  String get syncSchedulePending;

  /// No description provided for @syncPaused.
  ///
  /// In en, this message translates to:
  /// **'Sync paused'**
  String get syncPaused;

  /// No description provided for @syncWaitingSchedule.
  ///
  /// In en, this message translates to:
  /// **'Waiting for schedule'**
  String get syncWaitingSchedule;

  /// No description provided for @syncDue.
  ///
  /// In en, this message translates to:
  /// **'Sync due'**
  String get syncDue;

  /// No description provided for @syncNext.
  ///
  /// In en, this message translates to:
  /// **'Next in {duration}'**
  String syncNext(Object duration);

  /// No description provided for @syncEstimatedNext.
  ///
  /// In en, this message translates to:
  /// **'Est. next in {duration}'**
  String syncEstimatedNext(Object duration);

  /// No description provided for @syncForegroundRefresh.
  ///
  /// In en, this message translates to:
  /// **'Foreground refresh {relative}'**
  String syncForegroundRefresh(Object relative);

  /// No description provided for @syncNewCount.
  ///
  /// In en, this message translates to:
  /// **'{count} new'**
  String syncNewCount(int count);

  /// No description provided for @syncTitleLive.
  ///
  /// In en, this message translates to:
  /// **'Live sync active'**
  String get syncTitleLive;

  /// No description provided for @syncTitleWarming.
  ///
  /// In en, this message translates to:
  /// **'Sync warming up'**
  String get syncTitleWarming;

  /// No description provided for @syncTitleNeedsAttention.
  ///
  /// In en, this message translates to:
  /// **'Sync needs attention'**
  String get syncTitleNeedsAttention;

  /// No description provided for @syncTitleInterrupted.
  ///
  /// In en, this message translates to:
  /// **'Sync interrupted'**
  String get syncTitleInterrupted;

  /// No description provided for @syncTitleDisabled.
  ///
  /// In en, this message translates to:
  /// **'Sync disabled'**
  String get syncTitleDisabled;

  /// No description provided for @syncDetailCollectingFirstSamples.
  ///
  /// In en, this message translates to:
  /// **'Collecting the first glucose samples for this source.'**
  String get syncDetailCollectingFirstSamples;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
