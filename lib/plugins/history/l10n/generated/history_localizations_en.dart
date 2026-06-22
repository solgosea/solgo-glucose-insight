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
  String get pluginSubtitle => 'Daily glucose curve, events, and episode review.';

  @override
  String get pluginDescription => 'Daily glucose curve, events, and episode review.';

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
