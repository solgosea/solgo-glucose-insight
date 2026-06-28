// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'statistics_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class StatisticsLocalizationsEn extends StatisticsLocalizations {
  StatisticsLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get pluginTitle => 'Stats';

  @override
  String get pluginSubtitle => 'Glucose metrics, TIR, AGP, and heatmap.';

  @override
  String get pluginDescription => 'Glucose metrics, TIR, AGP, and heatmap.';

  @override
  String get pluginReportTitle => 'Stats Report';

  @override
  String get pluginLoading => 'Loading';

  @override
  String get pluginNoData => 'No data available yet.';

  @override
  String get pluginUnavailable => 'Unavailable';

  @override
  String get pageTitle => 'Stats';

  @override
  String get exportAction => 'Export ->';

  @override
  String get dateFilterTooltip => 'Choose dates';

  @override
  String get dateFilterTitle => 'Analysis period';

  @override
  String get dateFilterSubtitle =>
      'Choose a preset or drag across dates to analyze a range.';

  @override
  String get dateFilterApply => 'Apply filter';

  @override
  String get dateFilterReset => 'Today';

  @override
  String get dateFilterCancel => 'Cancel';

  @override
  String get dateFilterSelectedDates => 'Selected period';

  @override
  String get dateFilterDay => 'day';

  @override
  String get dateFilterDays => 'days';

  @override
  String get dateFilterReadings => 'readings';

  @override
  String get dateFilterDragHint =>
      'Use presets for common windows, or drag across dates for a custom analysis period.';

  @override
  String get tirBreakdownTitle => 'Time in range breakdown';

  @override
  String agpTitle(String window) {
    return 'AGP - Ambulatory Glucose Profile - $window pattern';
  }

  @override
  String get agpAnnotationDawn => 'Dawn';

  @override
  String get agpAnnotationPhenomenon => 'phenomenon';

  @override
  String get periodNight => 'Night';

  @override
  String get periodMorning => 'Morning';

  @override
  String get periodAfternoon => 'Afternoon';

  @override
  String get periodEvening => 'Evening';

  @override
  String minutesPerDay(Object minutes) {
    return '~$minutes min/day';
  }

  @override
  String get windowShortLast24Hours => '24h';

  @override
  String get windowShortLast3Days => '3d';

  @override
  String get windowShortLast7Days => '7d';

  @override
  String get windowShortLast14Days => '14d';

  @override
  String get windowShortLast30Days => '30d';

  @override
  String get windowShortLast90Days => '90d';

  @override
  String get windowHeaderLast24Hours => 'LAST 24 HOURS';

  @override
  String get windowHeaderLast3Days => 'LAST 3 DAYS';

  @override
  String get windowHeaderLast7Days => 'LAST 7 DAYS';

  @override
  String get windowHeaderLast14Days => 'LAST 14 DAYS';

  @override
  String get windowHeaderLast30Days => 'LAST 30 DAYS';

  @override
  String get windowHeaderLast90Days => 'LAST 90 DAYS';

  @override
  String get deltaSame => 'same';

  @override
  String deltaVsPrevious(String delta, String window) {
    return '$delta vs prev $window';
  }
}
