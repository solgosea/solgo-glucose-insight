import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'episode_detail_localizations_en.dart';
import 'episode_detail_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of EpisodeDetailLocalizations
/// returned by `EpisodeDetailLocalizations.of(context)`.
///
/// Applications need to include `EpisodeDetailLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/episode_detail_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: EpisodeDetailLocalizations.localizationsDelegates,
///   supportedLocales: EpisodeDetailLocalizations.supportedLocales,
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
/// be consistent with the languages listed in the EpisodeDetailLocalizations.supportedLocales
/// property.
abstract class EpisodeDetailLocalizations {
  EpisodeDetailLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static EpisodeDetailLocalizations of(BuildContext context) {
    return Localizations.of<EpisodeDetailLocalizations>(
        context, EpisodeDetailLocalizations)!;
  }

  static const LocalizationsDelegate<EpisodeDetailLocalizations> delegate =
      _EpisodeDetailLocalizationsDelegate();

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
  /// **'Episode Detail'**
  String get pluginTitle;

  /// No description provided for @pluginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'High and low episode interpretation and reports.'**
  String get pluginSubtitle;

  /// No description provided for @pluginDescription.
  ///
  /// In en, this message translates to:
  /// **'High and low episode interpretation and reports.'**
  String get pluginDescription;

  /// No description provided for @pluginReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Episode Detail Report'**
  String get pluginReportTitle;

  /// No description provided for @reportBrandName.
  ///
  /// In en, this message translates to:
  /// **'Solgo Insight'**
  String get reportBrandName;

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

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @dataQuality.
  ///
  /// In en, this message translates to:
  /// **'Data quality'**
  String get dataQuality;

  /// No description provided for @highEpisodeTitle.
  ///
  /// In en, this message translates to:
  /// **'High Episode'**
  String get highEpisodeTitle;

  /// No description provided for @lowEpisodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Low Episode'**
  String get lowEpisodeTitle;

  /// No description provided for @noMatchingHighEpisode.
  ///
  /// In en, this message translates to:
  /// **'No matching high episode'**
  String get noMatchingHighEpisode;

  /// No description provided for @noMatchingLowEpisode.
  ///
  /// In en, this message translates to:
  /// **'No matching low episode'**
  String get noMatchingLowEpisode;

  /// No description provided for @noRecentHighEpisode.
  ///
  /// In en, this message translates to:
  /// **'No recent high episode'**
  String get noRecentHighEpisode;

  /// No description provided for @noRecentLowEpisode.
  ///
  /// In en, this message translates to:
  /// **'No recent low episode'**
  String get noRecentLowEpisode;

  /// No description provided for @monthJan.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get monthJan;

  /// No description provided for @monthFeb.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get monthFeb;

  /// No description provided for @monthMar.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get monthMar;

  /// No description provided for @monthApr.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get monthApr;

  /// No description provided for @monthMay.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get monthMay;

  /// No description provided for @monthJun.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get monthJun;

  /// No description provided for @monthJul.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get monthJul;

  /// No description provided for @monthAug.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get monthAug;

  /// No description provided for @monthSep.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get monthSep;

  /// No description provided for @monthOct.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get monthOct;

  /// No description provided for @monthNov.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get monthNov;

  /// No description provided for @monthDec.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get monthDec;

  /// No description provided for @episodeTimeline.
  ///
  /// In en, this message translates to:
  /// **'Episode timeline'**
  String get episodeTimeline;

  /// No description provided for @cgmContextBeforeEpisode.
  ///
  /// In en, this message translates to:
  /// **'CGM context - 2h before episode'**
  String get cgmContextBeforeEpisode;

  /// No description provided for @patternAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Pattern analysis'**
  String get patternAnalysis;

  /// No description provided for @repeatByTimeOfDay.
  ///
  /// In en, this message translates to:
  /// **'Repeat by time of day'**
  String get repeatByTimeOfDay;

  /// No description provided for @episodeCount.
  ///
  /// In en, this message translates to:
  /// **'Episode count'**
  String get episodeCount;

  /// No description provided for @highDriverDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration is the main burden driver.'**
  String get highDriverDuration;

  /// No description provided for @timeBelowRange.
  ///
  /// In en, this message translates to:
  /// **'Time below range'**
  String get timeBelowRange;

  /// No description provided for @visibleInWindow.
  ///
  /// In en, this message translates to:
  /// **'In visible window'**
  String get visibleInWindow;

  /// No description provided for @lowDriverMixed.
  ///
  /// In en, this message translates to:
  /// **'The episode has a mixed low-burden profile.'**
  String get lowDriverMixed;

  /// No description provided for @toAboveLowThreshold.
  ///
  /// In en, this message translates to:
  /// **'to above low threshold'**
  String get toAboveLowThreshold;

  /// No description provided for @highEpisodeReportTitle.
  ///
  /// In en, this message translates to:
  /// **'High Episode Report'**
  String get highEpisodeReportTitle;

  /// No description provided for @returnLabel.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get returnLabel;

  /// No description provided for @lowReportContextBody.
  ///
  /// In en, this message translates to:
  /// **'This report cannot determine compression lows, meals, insulin, activity, calibration, or sensor-specific context unless notes are available.'**
  String get lowReportContextBody;

  /// No description provided for @printSave.
  ///
  /// In en, this message translates to:
  /// **'Print / Save'**
  String get printSave;

  /// No description provided for @highDriverRepeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat timing is the main review signal.'**
  String get highDriverRepeat;

  /// No description provided for @lowTime.
  ///
  /// In en, this message translates to:
  /// **'Low time'**
  String get lowTime;

  /// No description provided for @highDriverMixed.
  ///
  /// In en, this message translates to:
  /// **'The episode has a mixed burden profile.'**
  String get highDriverMixed;

  /// No description provided for @lowDriverNadir.
  ///
  /// In en, this message translates to:
  /// **'Nadir is the main low-burden driver.'**
  String get lowDriverNadir;

  /// No description provided for @largestGap.
  ///
  /// In en, this message translates to:
  /// **'Largest gap'**
  String get largestGap;

  /// No description provided for @representativeEpisodeCurve.
  ///
  /// In en, this message translates to:
  /// **'Representative episode curve'**
  String get representativeEpisodeCurve;

  /// No description provided for @highDriverSlowRecovery.
  ///
  /// In en, this message translates to:
  /// **'Slow recovery is the main burden driver.'**
  String get highDriverSlowRecovery;

  /// No description provided for @highExposureSummary.
  ///
  /// In en, this message translates to:
  /// **'High exposure summary'**
  String get highExposureSummary;

  /// No description provided for @lowestValue.
  ///
  /// In en, this message translates to:
  /// **'Lowest value'**
  String get lowestValue;

  /// No description provided for @lowExposureSummary.
  ///
  /// In en, this message translates to:
  /// **'Low exposure summary'**
  String get lowExposureSummary;

  /// No description provided for @highReportNoCauseBody.
  ///
  /// In en, this message translates to:
  /// **'Review alongside meals, insulin, activity, site changes, stress, and sensor context if available.'**
  String get highReportNoCauseBody;

  /// No description provided for @episodeLifecycle.
  ///
  /// In en, this message translates to:
  /// **'Episode lifecycle'**
  String get episodeLifecycle;

  /// No description provided for @toBelowHighThreshold.
  ///
  /// In en, this message translates to:
  /// **'to below high threshold'**
  String get toBelowHighThreshold;

  /// No description provided for @medianRecovery.
  ///
  /// In en, this message translates to:
  /// **'Median recovery'**
  String get medianRecovery;

  /// No description provided for @repeatPattern.
  ///
  /// In en, this message translates to:
  /// **'Repeat pattern'**
  String get repeatPattern;

  /// No description provided for @belowLowThreshold.
  ///
  /// In en, this message translates to:
  /// **'below low threshold'**
  String get belowLowThreshold;

  /// No description provided for @timeAboveRange.
  ///
  /// In en, this message translates to:
  /// **'Time above range'**
  String get timeAboveRange;

  /// No description provided for @nadir.
  ///
  /// In en, this message translates to:
  /// **'Nadir'**
  String get nadir;

  /// No description provided for @detectedEvents.
  ///
  /// In en, this message translates to:
  /// **'detected events'**
  String get detectedEvents;

  /// No description provided for @highReportDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Local report. Generated on device and shared only when you choose. This report observes high episodes only; it is not medical advice and does not replace CGM alerts, xDrip+, Nightscout, or care-team guidance.'**
  String get highReportDisclaimer;

  /// No description provided for @betweenReadings.
  ///
  /// In en, this message translates to:
  /// **'between readings'**
  String get betweenReadings;

  /// No description provided for @coverage.
  ///
  /// In en, this message translates to:
  /// **'Coverage'**
  String get coverage;

  /// No description provided for @lowDriverRepeat.
  ///
  /// In en, this message translates to:
  /// **'Repeat timing is the main review signal.'**
  String get lowDriverRepeat;

  /// No description provided for @lowEpisodeReportTitle.
  ///
  /// In en, this message translates to:
  /// **'Low Episode Report'**
  String get lowEpisodeReportTitle;

  /// No description provided for @backToEpisode.
  ///
  /// In en, this message translates to:
  /// **'Back to episode'**
  String get backToEpisode;

  /// No description provided for @confidence.
  ///
  /// In en, this message translates to:
  /// **'Confidence'**
  String get confidence;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @lowDriverNocturnal.
  ///
  /// In en, this message translates to:
  /// **'Nocturnal timing is the main review signal.'**
  String get lowDriverNocturnal;

  /// No description provided for @highestPeak.
  ///
  /// In en, this message translates to:
  /// **'Highest peak'**
  String get highestPeak;

  /// No description provided for @lowReportDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Local report. Generated on device and shared only when you choose. This report observes low episodes only; it is not medical advice and does not replace CGM alerts, xDrip+, Nightscout, or care-team guidance.'**
  String get lowReportDisclaimer;

  /// No description provided for @highDriverFastRise.
  ///
  /// In en, this message translates to:
  /// **'Fast rise is the main burden driver.'**
  String get highDriverFastRise;

  /// No description provided for @repeatTimingVisible.
  ///
  /// In en, this message translates to:
  /// **'Repeat timing is visible.'**
  String get repeatTimingVisible;

  /// No description provided for @highReportAboveRangeDuration.
  ///
  /// In en, this message translates to:
  /// **'The representative episode stayed above range for {duration}.'**
  String highReportAboveRangeDuration(String duration);

  /// No description provided for @lowReportBelowRangeDuration.
  ///
  /// In en, this message translates to:
  /// **'The representative episode stayed below range for {duration}.'**
  String lowReportBelowRangeDuration(String duration);

  /// No description provided for @lowReportBelowRangeDurationNadir.
  ///
  /// In en, this message translates to:
  /// **'The representative episode stayed below range for {duration} and reached {nadir}.'**
  String lowReportBelowRangeDurationNadir(String duration, String nadir);

  /// No description provided for @highReportRepeatCount.
  ///
  /// In en, this message translates to:
  /// **'{count} high episodes appeared in the past {days} days.'**
  String highReportRepeatCount(String count, int days);

  /// No description provided for @lowReportRepeatCount.
  ///
  /// In en, this message translates to:
  /// **'{count} low episodes appeared in the past {days} days.'**
  String lowReportRepeatCount(String count, int days);

  /// No description provided for @repeatTimingInsufficientData.
  ///
  /// In en, this message translates to:
  /// **'There was not enough repeat-pattern data for a strong timing note.'**
  String get repeatTimingInsufficientData;

  /// No description provided for @readings.
  ///
  /// In en, this message translates to:
  /// **'Readings'**
  String get readings;

  /// No description provided for @descent.
  ///
  /// In en, this message translates to:
  /// **'Descent'**
  String get descent;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @lowDriverSlowRecovery.
  ///
  /// In en, this message translates to:
  /// **'Slow recovery is the main review signal.'**
  String get lowDriverSlowRecovery;

  /// No description provided for @exporting.
  ///
  /// In en, this message translates to:
  /// **'Exporting...'**
  String get exporting;

  /// No description provided for @recovery.
  ///
  /// In en, this message translates to:
  /// **'Recovery'**
  String get recovery;

  /// No description provided for @lowReportContextTitle.
  ///
  /// In en, this message translates to:
  /// **'Use with context.'**
  String get lowReportContextTitle;

  /// No description provided for @repeatTimingLimited.
  ///
  /// In en, this message translates to:
  /// **'Repeat timing is limited.'**
  String get repeatTimingLimited;

  /// No description provided for @highEpisodes.
  ///
  /// In en, this message translates to:
  /// **'High episodes'**
  String get highEpisodes;

  /// No description provided for @lowDriverFastDescent.
  ///
  /// In en, this message translates to:
  /// **'Fast descent is the main low-burden driver.'**
  String get lowDriverFastDescent;

  /// No description provided for @medianReturn.
  ///
  /// In en, this message translates to:
  /// **'Median return'**
  String get medianReturn;

  /// No description provided for @couldNotExportReport.
  ///
  /// In en, this message translates to:
  /// **'Could not export report'**
  String get couldNotExportReport;

  /// No description provided for @rise.
  ///
  /// In en, this message translates to:
  /// **'Rise'**
  String get rise;

  /// No description provided for @highDriverPeak.
  ///
  /// In en, this message translates to:
  /// **'Peak is the main burden driver.'**
  String get highDriverPeak;

  /// No description provided for @episodeWindow.
  ///
  /// In en, this message translates to:
  /// **'episode window'**
  String get episodeWindow;

  /// No description provided for @baseline.
  ///
  /// In en, this message translates to:
  /// **'Baseline'**
  String get baseline;

  /// No description provided for @peak.
  ///
  /// In en, this message translates to:
  /// **'Peak'**
  String get peak;

  /// No description provided for @insufficientData.
  ///
  /// In en, this message translates to:
  /// **'insufficient data'**
  String get insufficientData;

  /// No description provided for @lowEpisodes.
  ///
  /// In en, this message translates to:
  /// **'Low episodes'**
  String get lowEpisodes;

  /// No description provided for @highReportNoCauseTitle.
  ///
  /// In en, this message translates to:
  /// **'The report does not infer cause.'**
  String get highReportNoCauseTitle;

  /// No description provided for @lowDriverDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration is the main low-burden driver.'**
  String get lowDriverDuration;

  /// No description provided for @reviewNotes.
  ///
  /// In en, this message translates to:
  /// **'Review notes'**
  String get reviewNotes;

  /// No description provided for @episodeReview.
  ///
  /// In en, this message translates to:
  /// **'episode review'**
  String get episodeReview;

  /// No description provided for @selectedLowUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The selected low episode may no longer be available.'**
  String get selectedLowUnavailable;

  /// No description provided for @selectedHighUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The selected high episode may no longer be available.'**
  String get selectedHighUnavailable;

  /// No description provided for @couldNotBuildReport.
  ///
  /// In en, this message translates to:
  /// **'Could not build this report'**
  String get couldNotBuildReport;

  /// No description provided for @areaAboveTarget.
  ///
  /// In en, this message translates to:
  /// **'Area above target'**
  String get areaAboveTarget;

  /// No description provided for @descentRate.
  ///
  /// In en, this message translates to:
  /// **'Descent rate'**
  String get descentRate;

  /// No description provided for @preOnsetBaseline.
  ///
  /// In en, this message translates to:
  /// **'Pre-onset baseline'**
  String get preOnsetBaseline;

  /// No description provided for @nadirValue.
  ///
  /// In en, this message translates to:
  /// **'Nadir Value'**
  String get nadirValue;

  /// No description provided for @exposure.
  ///
  /// In en, this message translates to:
  /// **'Exposure'**
  String get exposure;

  /// No description provided for @nadirVsUsualDailyNadir.
  ///
  /// In en, this message translates to:
  /// **'Nadir vs usual daily nadir'**
  String get nadirVsUsualDailyNadir;

  /// No description provided for @dropPerMinute.
  ///
  /// In en, this message translates to:
  /// **'Drop/min'**
  String get dropPerMinute;

  /// No description provided for @similarEpisodes.
  ///
  /// In en, this message translates to:
  /// **'Similar episodes'**
  String get similarEpisodes;

  /// No description provided for @peakVsUsualDailyPeak.
  ///
  /// In en, this message translates to:
  /// **'Peak vs usual daily peak'**
  String get peakVsUsualDailyPeak;

  /// No description provided for @preEpisodeBaseline.
  ///
  /// In en, this message translates to:
  /// **'Pre-episode baseline'**
  String get preEpisodeBaseline;

  /// No description provided for @peakValue.
  ///
  /// In en, this message translates to:
  /// **'Peak Value'**
  String get peakValue;

  /// No description provided for @areaBelowTarget.
  ///
  /// In en, this message translates to:
  /// **'Area below target'**
  String get areaBelowTarget;

  /// No description provided for @area.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get area;

  /// No description provided for @onsetRate.
  ///
  /// In en, this message translates to:
  /// **'Onset rate'**
  String get onsetRate;

  /// No description provided for @recovered.
  ///
  /// In en, this message translates to:
  /// **'Recovered'**
  String get recovered;

  /// No description provided for @nadirGap.
  ///
  /// In en, this message translates to:
  /// **'Nadir gap'**
  String get nadirGap;

  /// No description provided for @episodeSummary.
  ///
  /// In en, this message translates to:
  /// **'Episode summary'**
  String get episodeSummary;

  /// No description provided for @episodeChart.
  ///
  /// In en, this message translates to:
  /// **'Episode chart'**
  String get episodeChart;

  /// No description provided for @previewReport.
  ///
  /// In en, this message translates to:
  /// **'Preview report'**
  String get previewReport;

  /// No description provided for @noReportAvailable.
  ///
  /// In en, this message translates to:
  /// **'No report available'**
  String get noReportAvailable;

  /// No description provided for @backToLatestEpisode.
  ///
  /// In en, this message translates to:
  /// **'Back to latest episode'**
  String get backToLatestEpisode;

  /// No description provided for @reviewPriority.
  ///
  /// In en, this message translates to:
  /// **'Review priority'**
  String get reviewPriority;

  /// No description provided for @notVisible.
  ///
  /// In en, this message translates to:
  /// **'Not visible'**
  String get notVisible;

  /// No description provided for @value.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get value;

  /// No description provided for @thirtyDayOccurrenceStrip.
  ///
  /// In en, this message translates to:
  /// **'30-day occurrence strip'**
  String get thirtyDayOccurrenceStrip;

  /// No description provided for @olderToToday.
  ///
  /// In en, this message translates to:
  /// **'Older -> today'**
  String get olderToToday;

  /// No description provided for @noEpisode.
  ///
  /// In en, this message translates to:
  /// **'no episode'**
  String get noEpisode;

  /// No description provided for @episode.
  ///
  /// In en, this message translates to:
  /// **'episode'**
  String get episode;

  /// No description provided for @current.
  ///
  /// In en, this message translates to:
  /// **'current'**
  String get current;

  /// No description provided for @personalContext.
  ///
  /// In en, this message translates to:
  /// **'Personal context'**
  String get personalContext;

  /// No description provided for @burdenBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Burden breakdown'**
  String get burdenBreakdown;

  /// No description provided for @mainDriver.
  ///
  /// In en, this message translates to:
  /// **'Main driver'**
  String get mainDriver;

  /// No description provided for @recoveryQuality.
  ///
  /// In en, this message translates to:
  /// **'Recovery quality'**
  String get recoveryQuality;

  /// No description provided for @belowTarget.
  ///
  /// In en, this message translates to:
  /// **'Below target'**
  String get belowTarget;

  /// No description provided for @whyReview.
  ///
  /// In en, this message translates to:
  /// **'Why review'**
  String get whyReview;

  /// No description provided for @night.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get night;

  /// No description provided for @returnedInRange.
  ///
  /// In en, this message translates to:
  /// **'Returned in range'**
  String get returnedInRange;

  /// No description provided for @recoveryNotVisible.
  ///
  /// In en, this message translates to:
  /// **'Recovery not visible'**
  String get recoveryNotVisible;

  /// No description provided for @recoveredAt.
  ///
  /// In en, this message translates to:
  /// **'Recovered at {time}'**
  String recoveredAt(Object time);

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @veryHigh.
  ///
  /// In en, this message translates to:
  /// **'Very high'**
  String get veryHigh;

  /// No description provided for @veryLow.
  ///
  /// In en, this message translates to:
  /// **'Very low'**
  String get veryLow;

  /// No description provided for @none.
  ///
  /// In en, this message translates to:
  /// **'none'**
  String get none;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'high'**
  String get high;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'low'**
  String get low;

  /// No description provided for @strongHigh.
  ///
  /// In en, this message translates to:
  /// **'strong high'**
  String get strongHigh;

  /// No description provided for @similarVerySimilar.
  ///
  /// In en, this message translates to:
  /// **'Very similar'**
  String get similarVerySimilar;

  /// No description provided for @similarSimilar.
  ///
  /// In en, this message translates to:
  /// **'Similar'**
  String get similarSimilar;

  /// No description provided for @similarLooseMatch.
  ///
  /// In en, this message translates to:
  /// **'Loose match'**
  String get similarLooseMatch;

  /// No description provided for @clusterNight.
  ///
  /// In en, this message translates to:
  /// **'Night cluster'**
  String get clusterNight;

  /// No description provided for @clusterAm.
  ///
  /// In en, this message translates to:
  /// **'AM cluster'**
  String get clusterAm;

  /// No description provided for @clusterPm.
  ///
  /// In en, this message translates to:
  /// **'PM cluster'**
  String get clusterPm;

  /// No description provided for @clusterEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening cluster'**
  String get clusterEvening;

  /// No description provided for @focusedMissingEpisode.
  ///
  /// In en, this message translates to:
  /// **'No matching {kind} episode found{time}.'**
  String focusedMissingEpisode(Object kind, Object time);

  /// No description provided for @focusedMissingTime.
  ///
  /// In en, this message translates to:
  /// **' for {time}'**
  String focusedMissingTime(Object time);

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @priorityInfo.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get priorityInfo;

  /// No description provided for @priorityNotable.
  ///
  /// In en, this message translates to:
  /// **'Notable'**
  String get priorityNotable;

  /// No description provided for @priorityImportant.
  ///
  /// In en, this message translates to:
  /// **'Important'**
  String get priorityImportant;

  /// No description provided for @driverPeak.
  ///
  /// In en, this message translates to:
  /// **'peak'**
  String get driverPeak;

  /// No description provided for @driverDuration.
  ///
  /// In en, this message translates to:
  /// **'duration'**
  String get driverDuration;

  /// No description provided for @driverFastRise.
  ///
  /// In en, this message translates to:
  /// **'fast rise'**
  String get driverFastRise;

  /// No description provided for @driverSlowRecovery.
  ///
  /// In en, this message translates to:
  /// **'slow recovery'**
  String get driverSlowRecovery;

  /// No description provided for @driverRepeatTiming.
  ///
  /// In en, this message translates to:
  /// **'repeat timing'**
  String get driverRepeatTiming;

  /// No description provided for @driverMixedSignals.
  ///
  /// In en, this message translates to:
  /// **'mixed signals'**
  String get driverMixedSignals;

  /// No description provided for @confidenceHigh.
  ///
  /// In en, this message translates to:
  /// **'High confidence'**
  String get confidenceHigh;

  /// No description provided for @confidenceMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium confidence'**
  String get confidenceMedium;

  /// No description provided for @confidenceLow.
  ///
  /// In en, this message translates to:
  /// **'Low confidence'**
  String get confidenceLow;

  /// No description provided for @driverNadir.
  ///
  /// In en, this message translates to:
  /// **'nadir'**
  String get driverNadir;

  /// No description provided for @driverFastDescent.
  ///
  /// In en, this message translates to:
  /// **'fast descent'**
  String get driverFastDescent;

  /// No description provided for @driverNocturnalTiming.
  ///
  /// In en, this message translates to:
  /// **'nocturnal timing'**
  String get driverNocturnalTiming;

  /// No description provided for @recoveryQuick.
  ///
  /// In en, this message translates to:
  /// **'Quick'**
  String get recoveryQuick;

  /// No description provided for @recoveryGradual.
  ///
  /// In en, this message translates to:
  /// **'Gradual'**
  String get recoveryGradual;

  /// No description provided for @recoverySlow.
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get recoverySlow;

  /// No description provided for @usualRate.
  ///
  /// In en, this message translates to:
  /// **'usual {rate}'**
  String usualRate(Object rate);

  /// No description provided for @similarEpisodesPastDays.
  ///
  /// In en, this message translates to:
  /// **'Similar episodes (past {days} days)'**
  String similarEpisodesPastDays(Object days);

  /// No description provided for @similarEmptyPast30.
  ///
  /// In en, this message translates to:
  /// **'No similar episodes were found in the past 30 days.'**
  String get similarEmptyPast30;

  /// No description provided for @similarChartNote.
  ///
  /// In en, this message translates to:
  /// **'Slide across the chart to snap to the nearest episode. X-axis is time of day, Y-axis is {metric} glucose, and bubble size reflects duration.'**
  String similarChartNote(Object metric);

  /// No description provided for @reportRepresentative.
  ///
  /// In en, this message translates to:
  /// **'Representative'**
  String get reportRepresentative;

  /// No description provided for @reportLimited.
  ///
  /// In en, this message translates to:
  /// **'Limited'**
  String get reportLimited;

  /// No description provided for @reportInsufficient.
  ///
  /// In en, this message translates to:
  /// **'Insufficient'**
  String get reportInsufficient;

  /// No description provided for @episodeTimeUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Episode time unavailable'**
  String get episodeTimeUnavailable;

  /// No description provided for @similarHighs.
  ///
  /// In en, this message translates to:
  /// **'Similar highs'**
  String get similarHighs;

  /// No description provided for @pastDays.
  ///
  /// In en, this message translates to:
  /// **'Past {days} days'**
  String pastDays(Object days);

  /// No description provided for @medianPeak.
  ///
  /// In en, this message translates to:
  /// **'Median peak'**
  String get medianPeak;

  /// No description provided for @glucosePeak.
  ///
  /// In en, this message translates to:
  /// **'glucose peak'**
  String get glucosePeak;

  /// No description provided for @medianDuration.
  ///
  /// In en, this message translates to:
  /// **'Median duration'**
  String get medianDuration;

  /// No description provided for @aboveRange.
  ///
  /// In en, this message translates to:
  /// **'above range'**
  String get aboveRange;

  /// No description provided for @belowRange.
  ///
  /// In en, this message translates to:
  /// **'below range'**
  String get belowRange;

  /// No description provided for @pdfPreviewSuffix.
  ///
  /// In en, this message translates to:
  /// **'PDF Preview'**
  String get pdfPreviewSuffix;

  /// No description provided for @reportPeriod.
  ///
  /// In en, this message translates to:
  /// **'Report period'**
  String get reportPeriod;

  /// No description provided for @episodeAnalyzed.
  ///
  /// In en, this message translates to:
  /// **'Episode analyzed'**
  String get episodeAnalyzed;

  /// No description provided for @reportGenerated.
  ///
  /// In en, this message translates to:
  /// **'Generated'**
  String get reportGenerated;

  /// No description provided for @reportDataSource.
  ///
  /// In en, this message translates to:
  /// **'Data source'**
  String get reportDataSource;

  /// No description provided for @thresholds.
  ///
  /// In en, this message translates to:
  /// **'Thresholds'**
  String get thresholds;

  /// No description provided for @episodeView.
  ///
  /// In en, this message translates to:
  /// **'episode view'**
  String get episodeView;

  /// No description provided for @sequence.
  ///
  /// In en, this message translates to:
  /// **'sequence'**
  String get sequence;

  /// No description provided for @past30Days.
  ///
  /// In en, this message translates to:
  /// **'past 30 days'**
  String get past30Days;

  /// No description provided for @timeVsPeak.
  ///
  /// In en, this message translates to:
  /// **'time vs peak'**
  String get timeVsPeak;

  /// No description provided for @highReportHeroSummary.
  ///
  /// In en, this message translates to:
  /// **'A focused hyperglycemia exposure report with event curve, peak, duration, return-to-range, repeat timing, similar episodes, and data quality.'**
  String get highReportHeroSummary;

  /// No description provided for @lowReportHeroSummary.
  ///
  /// In en, this message translates to:
  /// **'A focused hypoglycemia exposure report with event curve, nadir, duration, descent, recovery, repeat timing, and data quality.'**
  String get lowReportHeroSummary;

  /// No description provided for @highThresholds.
  ///
  /// In en, this message translates to:
  /// **'High >{high} / Very high >{veryHigh}'**
  String highThresholds(Object high, Object veryHigh);

  /// No description provided for @lowThresholds.
  ///
  /// In en, this message translates to:
  /// **'Low <{low} / Very low <{veryLow}'**
  String lowThresholds(Object low, Object veryLow);

  /// No description provided for @repeatLimitedPast30.
  ///
  /// In en, this message translates to:
  /// **'Repeat pattern was limited in the past 30 days.'**
  String get repeatLimitedPast30;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'start'**
  String get start;

  /// No description provided for @recover.
  ///
  /// In en, this message translates to:
  /// **'recover'**
  String get recover;

  /// No description provided for @overTarget.
  ///
  /// In en, this message translates to:
  /// **'{amount} over target'**
  String overTarget(Object amount);

  /// No description provided for @returnTowardRange.
  ///
  /// In en, this message translates to:
  /// **'Return toward range'**
  String get returnTowardRange;

  /// No description provided for @baselineUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Baseline unavailable'**
  String get baselineUnavailable;

  /// No description provided for @baselineValue.
  ///
  /// In en, this message translates to:
  /// **'baseline {range}'**
  String baselineValue(Object range);

  /// No description provided for @above.
  ///
  /// In en, this message translates to:
  /// **'Above'**
  String get above;

  /// No description provided for @within.
  ///
  /// In en, this message translates to:
  /// **'Within'**
  String get within;

  /// No description provided for @stable.
  ///
  /// In en, this message translates to:
  /// **'Stable'**
  String get stable;

  /// No description provided for @rising.
  ///
  /// In en, this message translates to:
  /// **'Rising'**
  String get rising;

  /// No description provided for @variable.
  ///
  /// In en, this message translates to:
  /// **'Variable'**
  String get variable;

  /// No description provided for @dropping.
  ///
  /// In en, this message translates to:
  /// **'Dropping'**
  String get dropping;

  /// No description provided for @fast.
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get fast;

  /// No description provided for @typical.
  ///
  /// In en, this message translates to:
  /// **'Typical'**
  String get typical;

  /// No description provided for @lower.
  ///
  /// In en, this message translates to:
  /// **'Lower'**
  String get lower;

  /// No description provided for @timeWindowVariability.
  ///
  /// In en, this message translates to:
  /// **'Time-window variability'**
  String get timeWindowVariability;

  /// No description provided for @variabilityLabel.
  ///
  /// In en, this message translates to:
  /// **'{label} variability'**
  String variabilityLabel(Object label);

  /// No description provided for @notEnoughHistory.
  ///
  /// In en, this message translates to:
  /// **'Not enough history'**
  String get notEnoughHistory;

  /// No description provided for @cvRank.
  ///
  /// In en, this message translates to:
  /// **'CV {cv}% · rank {rank}/{total}'**
  String cvRank(Object cv, Object rank, Object total);

  /// No description provided for @samePartOfDay.
  ///
  /// In en, this message translates to:
  /// **'the same part of day'**
  String get samePartOfDay;

  /// No description provided for @dayWithRepeatedHighs.
  ///
  /// In en, this message translates to:
  /// **'day with repeated highs'**
  String get dayWithRepeatedHighs;

  /// No description provided for @daysWithRepeatedHighs.
  ///
  /// In en, this message translates to:
  /// **'days with repeated highs'**
  String get daysWithRepeatedHighs;

  /// No description provided for @dayWithRepeatedLows.
  ///
  /// In en, this message translates to:
  /// **'day with repeated lows'**
  String get dayWithRepeatedLows;

  /// No description provided for @daysWithRepeatedLows.
  ///
  /// In en, this message translates to:
  /// **'days with repeated lows'**
  String get daysWithRepeatedLows;

  /// No description provided for @noClearRepeat.
  ///
  /// In en, this message translates to:
  /// **'No clear repeat'**
  String get noClearRepeat;

  /// No description provided for @patternTakeaway.
  ///
  /// In en, this message translates to:
  /// **'Pattern takeaway'**
  String get patternTakeaway;

  /// No description provided for @timeBlockNight.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get timeBlockNight;

  /// No description provided for @timeBlockDawn.
  ///
  /// In en, this message translates to:
  /// **'Dawn'**
  String get timeBlockDawn;

  /// No description provided for @timeBlockMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get timeBlockMorning;

  /// No description provided for @timeBlockAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get timeBlockAfternoon;

  /// No description provided for @timeBlockEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get timeBlockEvening;

  /// No description provided for @clusterTitle.
  ///
  /// In en, this message translates to:
  /// **'{label} cluster'**
  String clusterTitle(Object label);

  /// No description provided for @repeatedHighsAround.
  ///
  /// In en, this message translates to:
  /// **'Most repeated highs are visible around {label}{range}.'**
  String repeatedHighsAround(Object label, Object range);

  /// No description provided for @repeatedLowsAround.
  ///
  /// In en, this message translates to:
  /// **'Most repeated lows are visible around {label}{range}.'**
  String repeatedLowsAround(Object label, Object range);

  /// No description provided for @peakRecovery.
  ///
  /// In en, this message translates to:
  /// **'Peak + recovery'**
  String get peakRecovery;

  /// No description provided for @peakOnly.
  ///
  /// In en, this message translates to:
  /// **'Peak only'**
  String get peakOnly;

  /// No description provided for @nadirRecovery.
  ///
  /// In en, this message translates to:
  /// **'Nadir + recovery'**
  String get nadirRecovery;

  /// No description provided for @nadirOnly.
  ///
  /// In en, this message translates to:
  /// **'Nadir only'**
  String get nadirOnly;

  /// No description provided for @partial.
  ///
  /// In en, this message translates to:
  /// **'Partial'**
  String get partial;

  /// No description provided for @dataConfidence.
  ///
  /// In en, this message translates to:
  /// **'Data confidence'**
  String get dataConfidence;

  /// No description provided for @leadUpDescent.
  ///
  /// In en, this message translates to:
  /// **'Lead-up descent'**
  String get leadUpDescent;

  /// No description provided for @overnightSlope.
  ///
  /// In en, this message translates to:
  /// **'Overnight slope'**
  String get overnightSlope;

  /// No description provided for @daytimeSlope.
  ///
  /// In en, this message translates to:
  /// **'Daytime slope'**
  String get daytimeSlope;

  /// No description provided for @usualUnavailable.
  ///
  /// In en, this message translates to:
  /// **'usual unavailable'**
  String get usualUnavailable;

  /// No description provided for @noCluster.
  ///
  /// In en, this message translates to:
  /// **'No cluster'**
  String get noCluster;

  /// No description provided for @peakGlucose.
  ///
  /// In en, this message translates to:
  /// **'Peak glucose'**
  String get peakGlucose;

  /// No description provided for @nadirGlucose.
  ///
  /// In en, this message translates to:
  /// **'Nadir glucose'**
  String get nadirGlucose;

  /// No description provided for @similarCount.
  ///
  /// In en, this message translates to:
  /// **'{count} similar'**
  String similarCount(Object count);

  /// No description provided for @noMedian.
  ///
  /// In en, this message translates to:
  /// **'No median'**
  String get noMedian;

  /// No description provided for @minutesMedian.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m median'**
  String minutesMedian(Object minutes);

  /// No description provided for @noMedianValue.
  ///
  /// In en, this message translates to:
  /// **'No median value'**
  String get noMedianValue;

  /// No description provided for @valueMedian.
  ///
  /// In en, this message translates to:
  /// **'{value} median'**
  String valueMedian(Object value);

  /// No description provided for @selectedDate.
  ///
  /// In en, this message translates to:
  /// **'Selected · {date}'**
  String selectedDate(Object date);

  /// No description provided for @selectedEpisode.
  ///
  /// In en, this message translates to:
  /// **'{range} · {kind} episode'**
  String selectedEpisode(Object range, Object kind);
}

class _EpisodeDetailLocalizationsDelegate
    extends LocalizationsDelegate<EpisodeDetailLocalizations> {
  const _EpisodeDetailLocalizationsDelegate();

  @override
  Future<EpisodeDetailLocalizations> load(Locale locale) {
    return SynchronousFuture<EpisodeDetailLocalizations>(
        lookupEpisodeDetailLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_EpisodeDetailLocalizationsDelegate old) => false;
}

EpisodeDetailLocalizations lookupEpisodeDetailLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return EpisodeDetailLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return EpisodeDetailLocalizationsEn();
    case 'zh':
      return EpisodeDetailLocalizationsZh();
  }

  throw FlutterError(
      'EpisodeDetailLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
