// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'episode_detail_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class EpisodeDetailLocalizationsEn extends EpisodeDetailLocalizations {
  EpisodeDetailLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get pluginTitle => 'Episode Detail';

  @override
  String get pluginSubtitle => 'High and low episode interpretation and reports.';

  @override
  String get pluginDescription => 'High and low episode interpretation and reports.';

  @override
  String get pluginReportTitle => 'Episode Detail Report';

  @override
  String get reportBrandName => 'Solgo Insight';

  @override
  String get pluginLoading => 'Loading';

  @override
  String get pluginNoData => 'No data available yet.';

  @override
  String get pluginUnavailable => 'Unavailable';

  @override
  String get retry => 'Retry';

  @override
  String get dataQuality => 'Data quality';

  @override
  String get highEpisodeTitle => 'High Episode';

  @override
  String get lowEpisodeTitle => 'Low Episode';

  @override
  String get noMatchingHighEpisode => 'No matching high episode';

  @override
  String get noMatchingLowEpisode => 'No matching low episode';

  @override
  String get noRecentHighEpisode => 'No recent high episode';

  @override
  String get noRecentLowEpisode => 'No recent low episode';

  @override
  String get monthJan => 'Jan';

  @override
  String get monthFeb => 'Feb';

  @override
  String get monthMar => 'Mar';

  @override
  String get monthApr => 'Apr';

  @override
  String get monthMay => 'May';

  @override
  String get monthJun => 'Jun';

  @override
  String get monthJul => 'Jul';

  @override
  String get monthAug => 'Aug';

  @override
  String get monthSep => 'Sep';

  @override
  String get monthOct => 'Oct';

  @override
  String get monthNov => 'Nov';

  @override
  String get monthDec => 'Dec';

  @override
  String get episodeTimeline => 'Episode timeline';

  @override
  String get cgmContextBeforeEpisode => 'CGM context - 2h before episode';

  @override
  String get patternAnalysis => 'Pattern analysis';

  @override
  String get repeatByTimeOfDay => 'Repeat by time of day';

  @override
  String get episodeCount => 'Episode count';

  @override
  String get highDriverDuration => 'Duration is the main burden driver.';

  @override
  String get timeBelowRange => 'Time below range';

  @override
  String get visibleInWindow => 'In visible window';

  @override
  String get lowDriverMixed => 'The episode has a mixed low-burden profile.';

  @override
  String get toAboveLowThreshold => 'to above low threshold';

  @override
  String get highEpisodeReportTitle => 'High Episode Report';

  @override
  String get returnLabel => 'Return';

  @override
  String get lowReportContextBody => 'This report cannot determine compression lows, meals, insulin, activity, calibration, or sensor-specific context unless notes are available.';

  @override
  String get printSave => 'Print / Save';

  @override
  String get highDriverRepeat => 'Repeat timing is the main review signal.';

  @override
  String get lowTime => 'Low time';

  @override
  String get highDriverMixed => 'The episode has a mixed burden profile.';

  @override
  String get lowDriverNadir => 'Nadir is the main low-burden driver.';

  @override
  String get largestGap => 'Largest gap';

  @override
  String get representativeEpisodeCurve => 'Representative episode curve';

  @override
  String get highDriverSlowRecovery => 'Slow recovery is the main burden driver.';

  @override
  String get highExposureSummary => 'High exposure summary';

  @override
  String get lowestValue => 'Lowest value';

  @override
  String get lowExposureSummary => 'Low exposure summary';

  @override
  String get highReportNoCauseBody => 'Review alongside meals, insulin, activity, site changes, stress, and sensor context if available.';

  @override
  String get episodeLifecycle => 'Episode lifecycle';

  @override
  String get toBelowHighThreshold => 'to below high threshold';

  @override
  String get medianRecovery => 'Median recovery';

  @override
  String get repeatPattern => 'Repeat pattern';

  @override
  String get belowLowThreshold => 'below low threshold';

  @override
  String get timeAboveRange => 'Time above range';

  @override
  String get nadir => 'Nadir';

  @override
  String get detectedEvents => 'detected events';

  @override
  String get highReportDisclaimer => 'Local report. Generated on device and shared only when you choose. This report observes high episodes only; it is not medical advice and does not replace CGM alerts, xDrip+, Nightscout, or care-team guidance.';

  @override
  String get betweenReadings => 'between readings';

  @override
  String get coverage => 'Coverage';

  @override
  String get lowDriverRepeat => 'Repeat timing is the main review signal.';

  @override
  String get lowEpisodeReportTitle => 'Low Episode Report';

  @override
  String get backToEpisode => 'Back to episode';

  @override
  String get confidence => 'Confidence';

  @override
  String get share => 'Share';

  @override
  String get lowDriverNocturnal => 'Nocturnal timing is the main review signal.';

  @override
  String get highestPeak => 'Highest peak';

  @override
  String get lowReportDisclaimer => 'Local report. Generated on device and shared only when you choose. This report observes low episodes only; it is not medical advice and does not replace CGM alerts, xDrip+, Nightscout, or care-team guidance.';

  @override
  String get highDriverFastRise => 'Fast rise is the main burden driver.';

  @override
  String get repeatTimingVisible => 'Repeat timing is visible.';

  @override
  String highReportAboveRangeDuration(String duration) {
    return 'The representative episode stayed above range for $duration.';
  }

  @override
  String lowReportBelowRangeDuration(String duration) {
    return 'The representative episode stayed below range for $duration.';
  }

  @override
  String lowReportBelowRangeDurationNadir(String duration, String nadir) {
    return 'The representative episode stayed below range for $duration and reached $nadir.';
  }

  @override
  String highReportRepeatCount(String count, int days) {
    return '$count high episodes appeared in the past $days days.';
  }

  @override
  String lowReportRepeatCount(String count, int days) {
    return '$count low episodes appeared in the past $days days.';
  }

  @override
  String get repeatTimingInsufficientData => 'There was not enough repeat-pattern data for a strong timing note.';

  @override
  String get readings => 'Readings';

  @override
  String get descent => 'Descent';

  @override
  String get duration => 'Duration';

  @override
  String get lowDriverSlowRecovery => 'Slow recovery is the main review signal.';

  @override
  String get exporting => 'Exporting...';

  @override
  String get recovery => 'Recovery';

  @override
  String get lowReportContextTitle => 'Use with context.';

  @override
  String get repeatTimingLimited => 'Repeat timing is limited.';

  @override
  String get highEpisodes => 'High episodes';

  @override
  String get lowDriverFastDescent => 'Fast descent is the main low-burden driver.';

  @override
  String get medianReturn => 'Median return';

  @override
  String get couldNotExportReport => 'Could not export report';

  @override
  String get rise => 'Rise';

  @override
  String get highDriverPeak => 'Peak is the main burden driver.';

  @override
  String get episodeWindow => 'episode window';

  @override
  String get baseline => 'Baseline';

  @override
  String get peak => 'Peak';

  @override
  String get insufficientData => 'insufficient data';

  @override
  String get lowEpisodes => 'Low episodes';

  @override
  String get highReportNoCauseTitle => 'The report does not infer cause.';

  @override
  String get lowDriverDuration => 'Duration is the main low-burden driver.';

  @override
  String get reviewNotes => 'Review notes';

  @override
  String get episodeReview => 'episode review';

  @override
  String get selectedLowUnavailable => 'The selected low episode may no longer be available.';

  @override
  String get selectedHighUnavailable => 'The selected high episode may no longer be available.';

  @override
  String get couldNotBuildReport => 'Could not build this report';

  @override
  String get areaAboveTarget => 'Area above target';

  @override
  String get descentRate => 'Descent rate';

  @override
  String get preOnsetBaseline => 'Pre-onset baseline';

  @override
  String get nadirValue => 'Nadir Value';

  @override
  String get exposure => 'Exposure';

  @override
  String get nadirVsUsualDailyNadir => 'Nadir vs usual daily nadir';

  @override
  String get dropPerMinute => 'Drop/min';

  @override
  String get similarEpisodes => 'Similar episodes';

  @override
  String get peakVsUsualDailyPeak => 'Peak vs usual daily peak';

  @override
  String get preEpisodeBaseline => 'Pre-episode baseline';

  @override
  String get peakValue => 'Peak Value';

  @override
  String get areaBelowTarget => 'Area below target';

  @override
  String get area => 'Area';

  @override
  String get onsetRate => 'Onset rate';

  @override
  String get recovered => 'Recovered';

  @override
  String get nadirGap => 'Nadir gap';

  @override
  String get episodeSummary => 'Episode summary';

  @override
  String get episodeChart => 'Episode chart';

  @override
  String get previewReport => 'Preview report';

  @override
  String get noReportAvailable => 'No report available';

  @override
  String get backToLatestEpisode => 'Back to latest episode';

  @override
  String get reviewPriority => 'Review priority';

  @override
  String get notVisible => 'Not visible';

  @override
  String get value => 'Value';

  @override
  String get thirtyDayOccurrenceStrip => '30-day occurrence strip';

  @override
  String get olderToToday => 'Older -> today';

  @override
  String get noEpisode => 'no episode';

  @override
  String get episode => 'episode';

  @override
  String get current => 'current';

  @override
  String get personalContext => 'Personal context';

  @override
  String get burdenBreakdown => 'Burden breakdown';

  @override
  String get mainDriver => 'Main driver';

  @override
  String get recoveryQuality => 'Recovery quality';

  @override
  String get belowTarget => 'Below target';

  @override
  String get whyReview => 'Why review';

  @override
  String get night => 'Night';

  @override
  String get returnedInRange => 'Returned in range';

  @override
  String get recoveryNotVisible => 'Recovery not visible';

  @override
  String recoveredAt(Object time) {
    return 'Recovered at $time';
  }

  @override
  String get note => 'Note';

  @override
  String get veryHigh => 'Very high';

  @override
  String get veryLow => 'Very low';

  @override
  String get none => 'none';

  @override
  String get high => 'high';

  @override
  String get low => 'low';

  @override
  String get strongHigh => 'strong high';

  @override
  String get similarVerySimilar => 'Very similar';

  @override
  String get similarSimilar => 'Similar';

  @override
  String get similarLooseMatch => 'Loose match';

  @override
  String get clusterNight => 'Night cluster';

  @override
  String get clusterAm => 'AM cluster';

  @override
  String get clusterPm => 'PM cluster';

  @override
  String get clusterEvening => 'Evening cluster';

  @override
  String focusedMissingEpisode(Object kind, Object time) {
    return 'No matching $kind episode found$time.';
  }

  @override
  String focusedMissingTime(Object time) {
    return ' for $time';
  }

  @override
  String get unknown => 'Unknown';

  @override
  String get priorityInfo => 'Info';

  @override
  String get priorityNotable => 'Notable';

  @override
  String get priorityImportant => 'Important';

  @override
  String get driverPeak => 'peak';

  @override
  String get driverDuration => 'duration';

  @override
  String get driverFastRise => 'fast rise';

  @override
  String get driverSlowRecovery => 'slow recovery';

  @override
  String get driverRepeatTiming => 'repeat timing';

  @override
  String get driverMixedSignals => 'mixed signals';

  @override
  String get confidenceHigh => 'High confidence';

  @override
  String get confidenceMedium => 'Medium confidence';

  @override
  String get confidenceLow => 'Low confidence';

  @override
  String get driverNadir => 'nadir';

  @override
  String get driverFastDescent => 'fast descent';

  @override
  String get driverNocturnalTiming => 'nocturnal timing';

  @override
  String get recoveryQuick => 'Quick';

  @override
  String get recoveryGradual => 'Gradual';

  @override
  String get recoverySlow => 'Slow';

  @override
  String usualRate(Object rate) {
    return 'usual $rate';
  }

  @override
  String similarEpisodesPastDays(Object days) {
    return 'Similar episodes (past $days days)';
  }

  @override
  String get similarEmptyPast30 => 'No similar episodes were found in the past 30 days.';

  @override
  String similarChartNote(Object metric) {
    return 'Slide across the chart to snap to the nearest episode. X-axis is time of day, Y-axis is $metric glucose, and bubble size reflects duration.';
  }

  @override
  String get reportRepresentative => 'Representative';

  @override
  String get reportLimited => 'Limited';

  @override
  String get reportInsufficient => 'Insufficient';

  @override
  String get episodeTimeUnavailable => 'Episode time unavailable';

  @override
  String get similarHighs => 'Similar highs';

  @override
  String pastDays(Object days) {
    return 'Past $days days';
  }

  @override
  String get medianPeak => 'Median peak';

  @override
  String get glucosePeak => 'glucose peak';

  @override
  String get medianDuration => 'Median duration';

  @override
  String get aboveRange => 'above range';

  @override
  String get belowRange => 'below range';

  @override
  String get pdfPreviewSuffix => 'PDF Preview';

  @override
  String get reportPeriod => 'Report period';

  @override
  String get episodeAnalyzed => 'Episode analyzed';

  @override
  String get reportGenerated => 'Generated';

  @override
  String get reportDataSource => 'Data source';

  @override
  String get thresholds => 'Thresholds';

  @override
  String get episodeView => 'episode view';

  @override
  String get sequence => 'sequence';

  @override
  String get past30Days => 'past 30 days';

  @override
  String get timeVsPeak => 'time vs peak';

  @override
  String get highReportHeroSummary => 'A focused hyperglycemia exposure report with event curve, peak, duration, return-to-range, repeat timing, similar episodes, and data quality.';

  @override
  String get lowReportHeroSummary => 'A focused hypoglycemia exposure report with event curve, nadir, duration, descent, recovery, repeat timing, and data quality.';

  @override
  String highThresholds(Object high, Object veryHigh) {
    return 'High >$high / Very high >$veryHigh';
  }

  @override
  String lowThresholds(Object low, Object veryLow) {
    return 'Low <$low / Very low <$veryLow';
  }

  @override
  String get repeatLimitedPast30 => 'Repeat pattern was limited in the past 30 days.';

  @override
  String get start => 'start';

  @override
  String get recover => 'recover';

  @override
  String overTarget(Object amount) {
    return '$amount over target';
  }

  @override
  String get returnTowardRange => 'Return toward range';

  @override
  String get baselineUnavailable => 'Baseline unavailable';

  @override
  String baselineValue(Object range) {
    return 'baseline $range';
  }

  @override
  String get above => 'Above';

  @override
  String get within => 'Within';

  @override
  String get stable => 'Stable';

  @override
  String get rising => 'Rising';

  @override
  String get variable => 'Variable';

  @override
  String get dropping => 'Dropping';

  @override
  String get fast => 'Fast';

  @override
  String get typical => 'Typical';

  @override
  String get lower => 'Lower';

  @override
  String get timeWindowVariability => 'Time-window variability';

  @override
  String variabilityLabel(Object label) {
    return '$label variability';
  }

  @override
  String get notEnoughHistory => 'Not enough history';

  @override
  String cvRank(Object cv, Object rank, Object total) {
    return 'CV $cv% · rank $rank/$total';
  }

  @override
  String get samePartOfDay => 'the same part of day';

  @override
  String get dayWithRepeatedHighs => 'day with repeated highs';

  @override
  String get daysWithRepeatedHighs => 'days with repeated highs';

  @override
  String get dayWithRepeatedLows => 'day with repeated lows';

  @override
  String get daysWithRepeatedLows => 'days with repeated lows';

  @override
  String get noClearRepeat => 'No clear repeat';

  @override
  String get patternTakeaway => 'Pattern takeaway';

  @override
  String get timeBlockNight => 'Night';

  @override
  String get timeBlockDawn => 'Dawn';

  @override
  String get timeBlockMorning => 'Morning';

  @override
  String get timeBlockAfternoon => 'Afternoon';

  @override
  String get timeBlockEvening => 'Evening';

  @override
  String clusterTitle(Object label) {
    return '$label cluster';
  }

  @override
  String repeatedHighsAround(Object label, Object range) {
    return 'Most repeated highs are visible around $label$range.';
  }

  @override
  String repeatedLowsAround(Object label, Object range) {
    return 'Most repeated lows are visible around $label$range.';
  }

  @override
  String get peakRecovery => 'Peak + recovery';

  @override
  String get peakOnly => 'Peak only';

  @override
  String get nadirRecovery => 'Nadir + recovery';

  @override
  String get nadirOnly => 'Nadir only';

  @override
  String get partial => 'Partial';

  @override
  String get dataConfidence => 'Data confidence';

  @override
  String get leadUpDescent => 'Lead-up descent';

  @override
  String get overnightSlope => 'Overnight slope';

  @override
  String get daytimeSlope => 'Daytime slope';

  @override
  String get usualUnavailable => 'usual unavailable';

  @override
  String get noCluster => 'No cluster';

  @override
  String get peakGlucose => 'Peak glucose';

  @override
  String get nadirGlucose => 'Nadir glucose';

  @override
  String similarCount(Object count) {
    return '$count similar';
  }

  @override
  String get noMedian => 'No median';

  @override
  String minutesMedian(Object minutes) {
    return '${minutes}m median';
  }

  @override
  String get noMedianValue => 'No median value';

  @override
  String valueMedian(Object value) {
    return '$value median';
  }

  @override
  String selectedDate(Object date) {
    return 'Selected · $date';
  }

  @override
  String selectedEpisode(Object range, Object kind) {
    return '$range · $kind episode';
  }
}
