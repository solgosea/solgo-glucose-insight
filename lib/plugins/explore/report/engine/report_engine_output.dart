import '../../../../domain/entities/app_settings.dart';
import '../../../../domain/entities/glucose_reading.dart';
import '../domain/sections/report_agp_section.dart';
import '../domain/sections/report_daily_curves_section.dart';
import '../domain/sections/report_episodes_section.dart';
import '../domain/sections/report_header_section.dart';
import '../domain/sections/report_metrics_section.dart';
import '../domain/sections/report_period_analysis_section.dart';
import '../domain/sections/report_ranges_section.dart';
import '../models/report_period.dart';

class ReportEngineOutput {
  final ReportPeriod period;
  final DateTime start;
  final DateTime end;
  final AppSettings settings;
  final List<GlucoseReading> readings;
  final DateTime generatedAt;
  final ReportHeaderSection headerSection;
  final ReportMetricsSection metricsSection;
  final ReportRangesSection rangesSection;
  final ReportAgpSection agpSection;
  final ReportDailyCurvesSection dailyCurvesSection;
  final ReportPeriodAnalysisSection periodAnalysisSection;
  final ReportEpisodesSection episodesSection;

  const ReportEngineOutput({
    required this.period,
    required this.start,
    required this.end,
    required this.settings,
    required this.readings,
    required this.generatedAt,
    required this.headerSection,
    required this.metricsSection,
    required this.rangesSection,
    required this.agpSection,
    required this.dailyCurvesSection,
    required this.periodAnalysisSection,
    required this.episodesSection,
  });

  bool get hasData => readings.isNotEmpty;
}
