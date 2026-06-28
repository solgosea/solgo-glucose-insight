// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'history_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class HistoryLocalizationsEn extends HistoryLocalizations {
  HistoryLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get pluginTitle => 'History';

  @override
  String get pluginSubtitle =>
      'Daily glucose curve, events, and episode review.';

  @override
  String get pluginDescription =>
      'Daily glucose curve, events, and episode review.';

  @override
  String get pluginReportTitle => 'History Report';

  @override
  String get pluginLoading => 'Loading';

  @override
  String get pluginNoData => 'No data available yet.';

  @override
  String get pluginUnavailable => 'Unavailable';

  @override
  String get dayView => 'DAY VIEW';

  @override
  String get today => 'TODAY';

  @override
  String get dateFilterTooltip => 'Choose dates';

  @override
  String get dateFilterTitle => 'Choose dates';

  @override
  String get dateFilterSubtitle =>
      'Tap a day or drag across dates to filter history.';

  @override
  String get dateFilterRangeSubtitle => 'DATE RANGE';

  @override
  String get dateFilterApply => 'Apply';

  @override
  String get dateFilterReset => 'Today';

  @override
  String get dateFilterCancel => 'Cancel';

  @override
  String get dateFilterSelectedDates => 'Selected dates';

  @override
  String get dateFilterDay => 'day';

  @override
  String get dateFilterDays => 'days';

  @override
  String get dateFilterReadings => 'readings';

  @override
  String get dateFilterDragHint =>
      'Tap a day for a single day, or drag across dates to select a range.';

  @override
  String get dateFilterToday => 'Today';

  @override
  String get dateFilterYesterday => 'Yesterday';

  @override
  String get dateFilterLast7Days => 'Last 7 days';

  @override
  String get dateFilterLast14Days => 'Last 14 days';

  @override
  String get dateFilterThisMonth => 'This month';

  @override
  String get summaryTir => 'TIR';

  @override
  String get summaryPeak => 'Peak';

  @override
  String get summaryCv => 'CV';

  @override
  String get summaryAverage => 'Avg';

  @override
  String get statTir => 'TIR';

  @override
  String get statAverage => 'AVG';

  @override
  String get statPeak => 'PEAK';

  @override
  String get statCv => 'CV';

  @override
  String get curveTitle => '24-HOUR CURVE';

  @override
  String get legendInRange => 'In range';

  @override
  String get legendHigh => 'High';

  @override
  String get legendLow => 'Low';

  @override
  String filterFocusedAround(String time) {
    return 'Focused around $time';
  }

  @override
  String get filterClear => 'Clear';

  @override
  String get episodeHigh => 'High episode';

  @override
  String get episodeLow => 'Low episode';

  @override
  String get episodeAction => 'View episode analysis ->';

  @override
  String get episodesPanelTitle => 'EPISODES';

  @override
  String get episodesFilterAll => 'All';

  @override
  String get episodesFilterHighs => 'Highs';

  @override
  String get episodesFilterLows => 'Lows';

  @override
  String episodesShowAll(int count) {
    return 'Show all $count episodes';
  }

  @override
  String get episodesShowLess => 'Show less';

  @override
  String get episodeMinutes => 'min';

  @override
  String episodeAboveThreshold(String threshold) {
    return 'above $threshold';
  }

  @override
  String episodeBelowThreshold(String threshold) {
    return 'below $threshold';
  }

  @override
  String get episodeNocturnal => 'nocturnal';

  @override
  String get eventRiseDetected => 'Rise detected';

  @override
  String get eventLowEpisode => 'Low episode';

  @override
  String get eventRecoveryToRange => 'Recovery to range';

  @override
  String get eventStableWindow => 'Stable window';

  @override
  String get eventFirstReading => 'First reading of day';

  @override
  String get eventDawnPhenomenon => 'Dawn phenomenon';

  @override
  String get tagHighEpisode => 'high episode';

  @override
  String get tagLowEpisode => 'low episode';

  @override
  String get tagInRange => 'in range';

  @override
  String get tagElevated => 'elevated';

  @override
  String get eventsSectionTitle => 'GLUCOSE EVENTS';

  @override
  String get eventsEmpty => 'No events recorded';

  @override
  String get eventBackInRange => 'Back in range';

  @override
  String get eventNocturnalLow => 'Nocturnal low';

  @override
  String eventRatePrefix(String rate) {
    return 'rate $rate';
  }
}
