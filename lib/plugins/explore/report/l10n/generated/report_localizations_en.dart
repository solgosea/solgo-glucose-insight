// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'report_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class ReportLocalizationsEn extends ReportLocalizations {
  ReportLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get pluginTitle => 'Glucose Report';

  @override
  String get pluginSubtitle =>
      'Doctor-ready glucose report with print and share.';

  @override
  String get pluginDescription =>
      'Doctor-ready glucose report with print and share.';

  @override
  String get pluginReportTitle => 'Glucose Report Report';

  @override
  String get pluginLoading => 'Loading';

  @override
  String get pluginNoData => 'No data available yet.';

  @override
  String get pluginUnavailable => 'Unavailable';

  @override
  String get pageSubtitle => 'AGP-standard - local - export to PDF or share';

  @override
  String get dateFilterTooltip => 'Choose report dates';

  @override
  String get dateFilterTitle => 'Report period';

  @override
  String get dateFilterSubtitle =>
      'Choose a standard doctor-ready window, or drag across dates for a custom report range.';

  @override
  String get dateFilterApply => 'Apply period';

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
      'Glucose Report works best with 14-90 days. Custom ranges are exported exactly as selected.';

  @override
  String get windowShortLast14Days => '14d';

  @override
  String get windowShortLast30Days => '30d';

  @override
  String get windowShortLast90Days => '90d';

  @override
  String get sectionKeyMetrics => 'Key Metrics';

  @override
  String get sectionTimeInRanges => 'Time in Ranges';

  @override
  String get sectionAgp => 'Ambulatory Glucose Profile';

  @override
  String get sectionDailyCurves => 'Daily Curves';

  @override
  String get sectionIncludeInReport => 'Include in Report';

  @override
  String get sectionExport => 'Export';

  @override
  String get reportDocumentTitle => 'Glucose Report Document';

  @override
  String reportWearLabel(String wear) {
    return '$wear% wear';
  }

  @override
  String get headerPeriod => 'Period';

  @override
  String get headerReadings => 'Readings';

  @override
  String get headerCoverage => 'Coverage';

  @override
  String get headerDataSource => 'Data source';

  @override
  String get headerTargetRange => 'Target range';

  @override
  String get headerGenerated => 'Generated';

  @override
  String get exportPrivacyNote =>
      'Reports are generated locally from CGM readings stored on this device. No insulin, carb, medication, or meal data is included.';

  @override
  String get exportDescription =>
      'Doctor-ready PDF output packages this report for saving or sharing. The interactive report remains available in the app.';

  @override
  String get exportSavePdf => 'Save as PDF';

  @override
  String get exportShareSend => 'Share / Send';

  @override
  String get exportGenerating => 'Generating...';

  @override
  String get metricTir => 'TIR';

  @override
  String get metricAverage => 'Avg';

  @override
  String get metricWear => 'Wear';

  @override
  String get metricCv => 'CV';

  @override
  String get metricGmi => 'GMI';

  @override
  String get metricSd => 'SD';

  @override
  String get metricTargetUnit => 'target >=70%';

  @override
  String get metricOnTarget => 'On target';

  @override
  String get metricBelowTarget => 'Below target';

  @override
  String get metricSensorActive => 'sensor active';

  @override
  String get metricCvTargetUnit => 'target <36%';

  @override
  String get metricGmiUnit => 'est. A1C';

  @override
  String get rangeVeryHigh => 'Very High';

  @override
  String get rangeHigh => 'High';

  @override
  String get rangeInRange => 'In Range';

  @override
  String get rangeLow => 'Low';

  @override
  String get rangeVeryLow => 'Very Low';

  @override
  String get emptyNoReportData =>
      'No report data yet. Connect xDrip+ Local or Nightscout API and sync readings first.';

  @override
  String get periodAnalysisInsufficient =>
      'Insufficient data for period analysis.';

  @override
  String get episodeSummaryInsufficient =>
      'Insufficient data for episode summary.';

  @override
  String periodAnalysisSummary(
      String bestPeriod, String bestTir, String variablePeriod, String cv) {
    return '$bestPeriod had the highest TIR ($bestTir%). $variablePeriod was the most variable period (CV $cv%).';
  }

  @override
  String episodeSummary(int highCount, int lowCount) {
    return '$highCount high episodes and $lowCount low episodes were detected in this report window.';
  }

  @override
  String unitDays(int days) {
    return '$days days';
  }

  @override
  String unitReadings(String count) {
    return '$count readings';
  }

  @override
  String unitWearActive(String wear, int minutes) {
    return '$wear% wear - $minutes active min';
  }

  @override
  String get toggleKeyMetricsTitle => 'Key Metrics';

  @override
  String get toggleKeyMetricsSubtitle => 'TIR, average, wear, CV and GMI';

  @override
  String get toggleAgpChartTitle => 'AGP Chart';

  @override
  String get toggleAgpChartSubtitle => '24-hour percentile overlay';

  @override
  String get toggleDailyCurvesTitle => 'Daily Curves';

  @override
  String get toggleDailyCurvesSubtitle => 'Last 14 days with sparse-data marks';

  @override
  String get togglePeriodAnalysisTitle => 'Period Analysis';

  @override
  String get togglePeriodAnalysisSubtitle => 'Add day-part pattern summary';

  @override
  String get toggleEpisodesSummaryTitle => 'Episodes Summary';

  @override
  String get toggleEpisodesSummarySubtitle => 'Add low/high episode counts';

  @override
  String get sourceNightscoutXdrip => 'Nightscout API + xDrip+ Local';

  @override
  String get sourceXdrip => 'xDrip+ Local HTTP';

  @override
  String get sourceNightscout => 'Nightscout API';

  @override
  String get sourceLocalCache => 'Local canonical cache';

  @override
  String get sourceNoData => 'No data source';

  @override
  String get agpOverlayLabel => '24-HOUR OVERLAY - ALL DAYS COMBINED';

  @override
  String get agpLegendMedian => 'Median';

  @override
  String get agpLegendIqr => 'IQR';
}
