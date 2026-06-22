// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'home_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class HomeLocalizationsEn extends HomeLocalizations {
  HomeLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get homeHeaderSubtitle => 'Home title and active sync status.';

  @override
  String get homeHeroTitle => 'Current Glucose';

  @override
  String get homeTirSubtitle => 'Current range summary';

  @override
  String get homeHeroSubtitle => 'Latest glucose value';

  @override
  String get homeTirDescription =>
      'Time-in-range summary for the current view.';

  @override
  String get homeRangeChartDescription => 'Recent glucose range chart.';

  @override
  String get homeHeroDescription => 'Latest glucose value and trend summary.';

  @override
  String get homeStatsDescription => 'Compact mean, CV, and event stat row.';

  @override
  String get homeInsightDescription => 'Compact generated insight entry point.';

  @override
  String get homeStatsTitle => 'Home Stats';

  @override
  String get homeHeaderDescription => 'Home title and active sync status.';

  @override
  String get homeRangeChartTitle => 'Range Chart';

  @override
  String get homeHeaderTitle => 'Home Header';

  @override
  String get homeTirTitle => 'Time In Range';

  @override
  String get homeStatsSubtitle => 'Mean, CV, and event stats';

  @override
  String get homeInsightTitle => 'Home Insight';

  @override
  String get homeRangeChartSubtitle => 'Recent glucose trend';

  @override
  String get homeInsightSubtitle => 'Generated insight entry point';

  @override
  String get pluginUnavailable => 'Unavailable';

  @override
  String get pluginReportTitle => 'Home Report';

  @override
  String get pluginSubtitle => 'Dashboard widgets and glucose overview.';

  @override
  String get pluginTitle => 'Home';

  @override
  String get pluginDescription => 'Dashboard widgets and glucose overview.';

  @override
  String get pluginNoData => 'No data available yet.';

  @override
  String get pluginLoading => 'Loading';

  @override
  String homeStatAverage(Object window) {
    return 'Avg $window';
  }

  @override
  String homeStatTir(Object window) {
    return 'TIR $window';
  }

  @override
  String homeStatCv(Object window) {
    return 'CV $window';
  }

  @override
  String get homeInRange => 'in range';

  @override
  String get homeStable => 'stable';

  @override
  String homeHighWithThreshold(Object threshold) {
    return 'High $threshold';
  }

  @override
  String homeLowWithThreshold(Object threshold) {
    return 'Low $threshold';
  }

  @override
  String get homeLast24h => 'Last 24h';

  @override
  String get homeNotEnoughData => 'Not enough CGM data yet.';

  @override
  String get homeCheckingSync => 'Checking sync';

  @override
  String get homeCompanionEyebrow => 'CGM COMPANION';

  @override
  String get homeTodaysInsight => 'TODAY\'S INSIGHT';

  @override
  String get homeSeeFullAnalysis => 'See full analysis  >';

  @override
  String get homeMyDevice => 'My device';

  @override
  String get homeInspectingPast => 'INSPECTING PAST - release for now';

  @override
  String get homeRangeOneHour => '1h';

  @override
  String get homeRangeFourHours => '4h';

  @override
  String get homeRangeEightHours => '8h';

  @override
  String get homeRangeTwentyFourHours => '24h';

  @override
  String get homeRangeTitleOneHour => 'LAST 1H';

  @override
  String get homeRangeTitleFourHours => 'LAST 4H';

  @override
  String get homeRangeTitleEightHours => 'LAST 8H';

  @override
  String get homeRangeTitleTwentyFourHours => 'LAST 24H';
}
