import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'statistics_localizations_en.dart';
import 'statistics_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of StatisticsLocalizations
/// returned by `StatisticsLocalizations.of(context)`.
///
/// Applications need to include `StatisticsLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/statistics_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: StatisticsLocalizations.localizationsDelegates,
///   supportedLocales: StatisticsLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the StatisticsLocalizations.supportedLocales
/// property.
abstract class StatisticsLocalizations {
  StatisticsLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static StatisticsLocalizations of(BuildContext context) {
    return Localizations.of<StatisticsLocalizations>(
        context, StatisticsLocalizations)!;
  }

  static const LocalizationsDelegate<StatisticsLocalizations> delegate =
      _StatisticsLocalizationsDelegate();

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
  /// **'Stats'**
  String get pluginTitle;

  /// No description provided for @pluginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Glucose metrics, TIR, AGP, and heatmap.'**
  String get pluginSubtitle;

  /// No description provided for @pluginDescription.
  ///
  /// In en, this message translates to:
  /// **'Glucose metrics, TIR, AGP, and heatmap.'**
  String get pluginDescription;

  /// No description provided for @pluginReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Stats Report'**
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

  /// No description provided for @pageTitle.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get pageTitle;

  /// No description provided for @exportAction.
  ///
  /// In en, this message translates to:
  /// **'Export ->'**
  String get exportAction;

  /// No description provided for @tirBreakdownTitle.
  ///
  /// In en, this message translates to:
  /// **'Time in range breakdown'**
  String get tirBreakdownTitle;

  /// No description provided for @agpTitle.
  ///
  /// In en, this message translates to:
  /// **'AGP - Ambulatory Glucose Profile - {window} pattern'**
  String agpTitle(String window);

  /// No description provided for @agpAnnotationDawn.
  ///
  /// In en, this message translates to:
  /// **'Dawn'**
  String get agpAnnotationDawn;

  /// No description provided for @agpAnnotationPhenomenon.
  ///
  /// In en, this message translates to:
  /// **'phenomenon'**
  String get agpAnnotationPhenomenon;

  /// No description provided for @periodNight.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get periodNight;

  /// No description provided for @periodMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get periodMorning;

  /// No description provided for @periodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get periodAfternoon;

  /// No description provided for @periodEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get periodEvening;

  /// No description provided for @minutesPerDay.
  ///
  /// In en, this message translates to:
  /// **'~{minutes} min/day'**
  String minutesPerDay(Object minutes);

  /// No description provided for @windowShortLast24Hours.
  ///
  /// In en, this message translates to:
  /// **'24h'**
  String get windowShortLast24Hours;

  /// No description provided for @windowShortLast3Days.
  ///
  /// In en, this message translates to:
  /// **'3d'**
  String get windowShortLast3Days;

  /// No description provided for @windowShortLast7Days.
  ///
  /// In en, this message translates to:
  /// **'7d'**
  String get windowShortLast7Days;

  /// No description provided for @windowShortLast14Days.
  ///
  /// In en, this message translates to:
  /// **'14d'**
  String get windowShortLast14Days;

  /// No description provided for @windowShortLast30Days.
  ///
  /// In en, this message translates to:
  /// **'30d'**
  String get windowShortLast30Days;

  /// No description provided for @windowShortLast90Days.
  ///
  /// In en, this message translates to:
  /// **'90d'**
  String get windowShortLast90Days;

  /// No description provided for @windowHeaderLast24Hours.
  ///
  /// In en, this message translates to:
  /// **'LAST 24 HOURS'**
  String get windowHeaderLast24Hours;

  /// No description provided for @windowHeaderLast3Days.
  ///
  /// In en, this message translates to:
  /// **'LAST 3 DAYS'**
  String get windowHeaderLast3Days;

  /// No description provided for @windowHeaderLast7Days.
  ///
  /// In en, this message translates to:
  /// **'LAST 7 DAYS'**
  String get windowHeaderLast7Days;

  /// No description provided for @windowHeaderLast14Days.
  ///
  /// In en, this message translates to:
  /// **'LAST 14 DAYS'**
  String get windowHeaderLast14Days;

  /// No description provided for @windowHeaderLast30Days.
  ///
  /// In en, this message translates to:
  /// **'LAST 30 DAYS'**
  String get windowHeaderLast30Days;

  /// No description provided for @windowHeaderLast90Days.
  ///
  /// In en, this message translates to:
  /// **'LAST 90 DAYS'**
  String get windowHeaderLast90Days;

  /// No description provided for @deltaSame.
  ///
  /// In en, this message translates to:
  /// **'same'**
  String get deltaSame;

  /// No description provided for @deltaVsPrevious.
  ///
  /// In en, this message translates to:
  /// **'{delta} vs prev {window}'**
  String deltaVsPrevious(String delta, String window);
}

class _StatisticsLocalizationsDelegate
    extends LocalizationsDelegate<StatisticsLocalizations> {
  const _StatisticsLocalizationsDelegate();

  @override
  Future<StatisticsLocalizations> load(Locale locale) {
    return SynchronousFuture<StatisticsLocalizations>(
        lookupStatisticsLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_StatisticsLocalizationsDelegate old) => false;
}

StatisticsLocalizations lookupStatisticsLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return StatisticsLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return StatisticsLocalizationsEn();
    case 'zh':
      return StatisticsLocalizationsZh();
  }

  throw FlutterError(
      'StatisticsLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
