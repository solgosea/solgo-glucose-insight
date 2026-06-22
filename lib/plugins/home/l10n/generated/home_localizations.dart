import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'home_localizations_en.dart';
import 'home_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of HomeLocalizations
/// returned by `HomeLocalizations.of(context)`.
///
/// Applications need to include `HomeLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/home_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: HomeLocalizations.localizationsDelegates,
///   supportedLocales: HomeLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the HomeLocalizations.supportedLocales
/// property.
abstract class HomeLocalizations {
  HomeLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static HomeLocalizations of(BuildContext context) {
    return Localizations.of<HomeLocalizations>(context, HomeLocalizations)!;
  }

  static const LocalizationsDelegate<HomeLocalizations> delegate =
      _HomeLocalizationsDelegate();

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

  /// No description provided for @homeHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Home title and active sync status.'**
  String get homeHeaderSubtitle;

  /// No description provided for @homeHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Current Glucose'**
  String get homeHeroTitle;

  /// No description provided for @homeTirSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Current range summary'**
  String get homeTirSubtitle;

  /// No description provided for @homeHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Latest glucose value'**
  String get homeHeroSubtitle;

  /// No description provided for @homeTirDescription.
  ///
  /// In en, this message translates to:
  /// **'Time-in-range summary for the current view.'**
  String get homeTirDescription;

  /// No description provided for @homeRangeChartDescription.
  ///
  /// In en, this message translates to:
  /// **'Recent glucose range chart.'**
  String get homeRangeChartDescription;

  /// No description provided for @homeHeroDescription.
  ///
  /// In en, this message translates to:
  /// **'Latest glucose value and trend summary.'**
  String get homeHeroDescription;

  /// No description provided for @homeStatsDescription.
  ///
  /// In en, this message translates to:
  /// **'Compact mean, CV, and event stat row.'**
  String get homeStatsDescription;

  /// No description provided for @homeInsightDescription.
  ///
  /// In en, this message translates to:
  /// **'Compact generated insight entry point.'**
  String get homeInsightDescription;

  /// No description provided for @homeStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Home Stats'**
  String get homeStatsTitle;

  /// No description provided for @homeHeaderDescription.
  ///
  /// In en, this message translates to:
  /// **'Home title and active sync status.'**
  String get homeHeaderDescription;

  /// No description provided for @homeRangeChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Range Chart'**
  String get homeRangeChartTitle;

  /// No description provided for @homeHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Home Header'**
  String get homeHeaderTitle;

  /// No description provided for @homeTirTitle.
  ///
  /// In en, this message translates to:
  /// **'Time In Range'**
  String get homeTirTitle;

  /// No description provided for @homeStatsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Mean, CV, and event stats'**
  String get homeStatsSubtitle;

  /// No description provided for @homeInsightTitle.
  ///
  /// In en, this message translates to:
  /// **'Home Insight'**
  String get homeInsightTitle;

  /// No description provided for @homeRangeChartSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Recent glucose trend'**
  String get homeRangeChartSubtitle;

  /// No description provided for @homeInsightSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Generated insight entry point'**
  String get homeInsightSubtitle;

  /// No description provided for @pluginUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get pluginUnavailable;

  /// No description provided for @pluginReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Home Report'**
  String get pluginReportTitle;

  /// No description provided for @pluginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard widgets and glucose overview.'**
  String get pluginSubtitle;

  /// No description provided for @pluginTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get pluginTitle;

  /// No description provided for @pluginDescription.
  ///
  /// In en, this message translates to:
  /// **'Dashboard widgets and glucose overview.'**
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

  /// No description provided for @homeStatAverage.
  ///
  /// In en, this message translates to:
  /// **'Avg {window}'**
  String homeStatAverage(Object window);

  /// No description provided for @homeStatTir.
  ///
  /// In en, this message translates to:
  /// **'TIR {window}'**
  String homeStatTir(Object window);

  /// No description provided for @homeStatCv.
  ///
  /// In en, this message translates to:
  /// **'CV {window}'**
  String homeStatCv(Object window);

  /// No description provided for @homeInRange.
  ///
  /// In en, this message translates to:
  /// **'in range'**
  String get homeInRange;

  /// No description provided for @homeStable.
  ///
  /// In en, this message translates to:
  /// **'stable'**
  String get homeStable;

  /// No description provided for @homeHighWithThreshold.
  ///
  /// In en, this message translates to:
  /// **'High {threshold}'**
  String homeHighWithThreshold(Object threshold);

  /// No description provided for @homeLowWithThreshold.
  ///
  /// In en, this message translates to:
  /// **'Low {threshold}'**
  String homeLowWithThreshold(Object threshold);

  /// No description provided for @homeLast24h.
  ///
  /// In en, this message translates to:
  /// **'Last 24h'**
  String get homeLast24h;

  /// No description provided for @homeNotEnoughData.
  ///
  /// In en, this message translates to:
  /// **'Not enough CGM data yet.'**
  String get homeNotEnoughData;

  /// No description provided for @homeCheckingSync.
  ///
  /// In en, this message translates to:
  /// **'Checking sync'**
  String get homeCheckingSync;

  /// No description provided for @homeCompanionEyebrow.
  ///
  /// In en, this message translates to:
  /// **'CGM COMPANION'**
  String get homeCompanionEyebrow;

  /// No description provided for @homeTodaysInsight.
  ///
  /// In en, this message translates to:
  /// **'TODAY\'S INSIGHT'**
  String get homeTodaysInsight;

  /// No description provided for @homeSeeFullAnalysis.
  ///
  /// In en, this message translates to:
  /// **'See full analysis  >'**
  String get homeSeeFullAnalysis;

  /// No description provided for @homeMyDevice.
  ///
  /// In en, this message translates to:
  /// **'My device'**
  String get homeMyDevice;

  /// No description provided for @homeInspectingPast.
  ///
  /// In en, this message translates to:
  /// **'INSPECTING PAST - release for now'**
  String get homeInspectingPast;

  /// No description provided for @homeRangeOneHour.
  ///
  /// In en, this message translates to:
  /// **'1h'**
  String get homeRangeOneHour;

  /// No description provided for @homeRangeFourHours.
  ///
  /// In en, this message translates to:
  /// **'4h'**
  String get homeRangeFourHours;

  /// No description provided for @homeRangeEightHours.
  ///
  /// In en, this message translates to:
  /// **'8h'**
  String get homeRangeEightHours;

  /// No description provided for @homeRangeTwentyFourHours.
  ///
  /// In en, this message translates to:
  /// **'24h'**
  String get homeRangeTwentyFourHours;

  /// No description provided for @homeRangeTitleOneHour.
  ///
  /// In en, this message translates to:
  /// **'LAST 1H'**
  String get homeRangeTitleOneHour;

  /// No description provided for @homeRangeTitleFourHours.
  ///
  /// In en, this message translates to:
  /// **'LAST 4H'**
  String get homeRangeTitleFourHours;

  /// No description provided for @homeRangeTitleEightHours.
  ///
  /// In en, this message translates to:
  /// **'LAST 8H'**
  String get homeRangeTitleEightHours;

  /// No description provided for @homeRangeTitleTwentyFourHours.
  ///
  /// In en, this message translates to:
  /// **'LAST 24H'**
  String get homeRangeTitleTwentyFourHours;
}

class _HomeLocalizationsDelegate
    extends LocalizationsDelegate<HomeLocalizations> {
  const _HomeLocalizationsDelegate();

  @override
  Future<HomeLocalizations> load(Locale locale) {
    return SynchronousFuture<HomeLocalizations>(
        lookupHomeLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_HomeLocalizationsDelegate old) => false;
}

HomeLocalizations lookupHomeLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return HomeLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return HomeLocalizationsEn();
    case 'zh':
      return HomeLocalizationsZh();
  }

  throw FlutterError(
      'HomeLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
