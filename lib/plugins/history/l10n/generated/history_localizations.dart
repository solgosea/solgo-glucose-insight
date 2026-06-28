import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'history_localizations_en.dart';
import 'history_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of HistoryLocalizations
/// returned by `HistoryLocalizations.of(context)`.
///
/// Applications need to include `HistoryLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/history_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: HistoryLocalizations.localizationsDelegates,
///   supportedLocales: HistoryLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the HistoryLocalizations.supportedLocales
/// property.
abstract class HistoryLocalizations {
  HistoryLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static HistoryLocalizations of(BuildContext context) {
    return Localizations.of<HistoryLocalizations>(
        context, HistoryLocalizations)!;
  }

  static const LocalizationsDelegate<HistoryLocalizations> delegate =
      _HistoryLocalizationsDelegate();

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
  /// **'History'**
  String get pluginTitle;

  /// No description provided for @pluginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Daily glucose curve, events, and episode review.'**
  String get pluginSubtitle;

  /// No description provided for @pluginDescription.
  ///
  /// In en, this message translates to:
  /// **'Daily glucose curve, events, and episode review.'**
  String get pluginDescription;

  /// No description provided for @pluginReportTitle.
  ///
  /// In en, this message translates to:
  /// **'History Report'**
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

  /// No description provided for @dayView.
  ///
  /// In en, this message translates to:
  /// **'DAY VIEW'**
  String get dayView;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'TODAY'**
  String get today;

  /// No description provided for @dateFilterTooltip.
  ///
  /// In en, this message translates to:
  /// **'Choose dates'**
  String get dateFilterTooltip;

  /// No description provided for @dateFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose dates'**
  String get dateFilterTitle;

  /// No description provided for @dateFilterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap a day or drag across dates to filter history.'**
  String get dateFilterSubtitle;

  /// No description provided for @dateFilterRangeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'DATE RANGE'**
  String get dateFilterRangeSubtitle;

  /// No description provided for @dateFilterApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get dateFilterApply;

  /// No description provided for @dateFilterReset.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dateFilterReset;

  /// No description provided for @dateFilterCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get dateFilterCancel;

  /// No description provided for @dateFilterSelectedDates.
  ///
  /// In en, this message translates to:
  /// **'Selected dates'**
  String get dateFilterSelectedDates;

  /// No description provided for @dateFilterDay.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get dateFilterDay;

  /// No description provided for @dateFilterDays.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get dateFilterDays;

  /// No description provided for @dateFilterReadings.
  ///
  /// In en, this message translates to:
  /// **'readings'**
  String get dateFilterReadings;

  /// No description provided for @dateFilterDragHint.
  ///
  /// In en, this message translates to:
  /// **'Tap a day for a single day, or drag across dates to select a range.'**
  String get dateFilterDragHint;

  /// No description provided for @dateFilterToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dateFilterToday;

  /// No description provided for @dateFilterYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get dateFilterYesterday;

  /// No description provided for @dateFilterLast7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 days'**
  String get dateFilterLast7Days;

  /// No description provided for @dateFilterLast14Days.
  ///
  /// In en, this message translates to:
  /// **'Last 14 days'**
  String get dateFilterLast14Days;

  /// No description provided for @dateFilterThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get dateFilterThisMonth;

  /// No description provided for @summaryTir.
  ///
  /// In en, this message translates to:
  /// **'TIR'**
  String get summaryTir;

  /// No description provided for @summaryPeak.
  ///
  /// In en, this message translates to:
  /// **'Peak'**
  String get summaryPeak;

  /// No description provided for @summaryCv.
  ///
  /// In en, this message translates to:
  /// **'CV'**
  String get summaryCv;

  /// No description provided for @summaryAverage.
  ///
  /// In en, this message translates to:
  /// **'Avg'**
  String get summaryAverage;

  /// No description provided for @statTir.
  ///
  /// In en, this message translates to:
  /// **'TIR'**
  String get statTir;

  /// No description provided for @statAverage.
  ///
  /// In en, this message translates to:
  /// **'AVG'**
  String get statAverage;

  /// No description provided for @statPeak.
  ///
  /// In en, this message translates to:
  /// **'PEAK'**
  String get statPeak;

  /// No description provided for @statCv.
  ///
  /// In en, this message translates to:
  /// **'CV'**
  String get statCv;

  /// No description provided for @curveTitle.
  ///
  /// In en, this message translates to:
  /// **'24-HOUR CURVE'**
  String get curveTitle;

  /// No description provided for @legendInRange.
  ///
  /// In en, this message translates to:
  /// **'In range'**
  String get legendInRange;

  /// No description provided for @legendHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get legendHigh;

  /// No description provided for @legendLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get legendLow;

  /// No description provided for @filterFocusedAround.
  ///
  /// In en, this message translates to:
  /// **'Focused around {time}'**
  String filterFocusedAround(String time);

  /// No description provided for @filterClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get filterClear;

  /// No description provided for @episodeHigh.
  ///
  /// In en, this message translates to:
  /// **'High episode'**
  String get episodeHigh;

  /// No description provided for @episodeLow.
  ///
  /// In en, this message translates to:
  /// **'Low episode'**
  String get episodeLow;

  /// No description provided for @episodeAction.
  ///
  /// In en, this message translates to:
  /// **'View episode analysis ->'**
  String get episodeAction;

  /// No description provided for @episodesPanelTitle.
  ///
  /// In en, this message translates to:
  /// **'EPISODES'**
  String get episodesPanelTitle;

  /// No description provided for @episodesFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get episodesFilterAll;

  /// No description provided for @episodesFilterHighs.
  ///
  /// In en, this message translates to:
  /// **'Highs'**
  String get episodesFilterHighs;

  /// No description provided for @episodesFilterLows.
  ///
  /// In en, this message translates to:
  /// **'Lows'**
  String get episodesFilterLows;

  /// No description provided for @episodesShowAll.
  ///
  /// In en, this message translates to:
  /// **'Show all {count} episodes'**
  String episodesShowAll(int count);

  /// No description provided for @episodesShowLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get episodesShowLess;

  /// No description provided for @episodeMinutes.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get episodeMinutes;

  /// No description provided for @episodeAboveThreshold.
  ///
  /// In en, this message translates to:
  /// **'above {threshold}'**
  String episodeAboveThreshold(String threshold);

  /// No description provided for @episodeBelowThreshold.
  ///
  /// In en, this message translates to:
  /// **'below {threshold}'**
  String episodeBelowThreshold(String threshold);

  /// No description provided for @episodeNocturnal.
  ///
  /// In en, this message translates to:
  /// **'nocturnal'**
  String get episodeNocturnal;

  /// No description provided for @eventRiseDetected.
  ///
  /// In en, this message translates to:
  /// **'Rise detected'**
  String get eventRiseDetected;

  /// No description provided for @eventLowEpisode.
  ///
  /// In en, this message translates to:
  /// **'Low episode'**
  String get eventLowEpisode;

  /// No description provided for @eventRecoveryToRange.
  ///
  /// In en, this message translates to:
  /// **'Recovery to range'**
  String get eventRecoveryToRange;

  /// No description provided for @eventStableWindow.
  ///
  /// In en, this message translates to:
  /// **'Stable window'**
  String get eventStableWindow;

  /// No description provided for @eventFirstReading.
  ///
  /// In en, this message translates to:
  /// **'First reading of day'**
  String get eventFirstReading;

  /// No description provided for @eventDawnPhenomenon.
  ///
  /// In en, this message translates to:
  /// **'Dawn phenomenon'**
  String get eventDawnPhenomenon;

  /// No description provided for @tagHighEpisode.
  ///
  /// In en, this message translates to:
  /// **'high episode'**
  String get tagHighEpisode;

  /// No description provided for @tagLowEpisode.
  ///
  /// In en, this message translates to:
  /// **'low episode'**
  String get tagLowEpisode;

  /// No description provided for @tagInRange.
  ///
  /// In en, this message translates to:
  /// **'in range'**
  String get tagInRange;

  /// No description provided for @tagElevated.
  ///
  /// In en, this message translates to:
  /// **'elevated'**
  String get tagElevated;

  /// No description provided for @eventsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'GLUCOSE EVENTS'**
  String get eventsSectionTitle;

  /// No description provided for @eventsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No events recorded'**
  String get eventsEmpty;

  /// No description provided for @eventBackInRange.
  ///
  /// In en, this message translates to:
  /// **'Back in range'**
  String get eventBackInRange;

  /// No description provided for @eventNocturnalLow.
  ///
  /// In en, this message translates to:
  /// **'Nocturnal low'**
  String get eventNocturnalLow;

  /// No description provided for @eventRatePrefix.
  ///
  /// In en, this message translates to:
  /// **'rate {rate}'**
  String eventRatePrefix(String rate);
}

class _HistoryLocalizationsDelegate
    extends LocalizationsDelegate<HistoryLocalizations> {
  const _HistoryLocalizationsDelegate();

  @override
  Future<HistoryLocalizations> load(Locale locale) {
    return SynchronousFuture<HistoryLocalizations>(
        lookupHistoryLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_HistoryLocalizationsDelegate old) => false;
}

HistoryLocalizations lookupHistoryLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return HistoryLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return HistoryLocalizationsEn();
    case 'zh':
      return HistoryLocalizationsZh();
  }

  throw FlutterError(
      'HistoryLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
