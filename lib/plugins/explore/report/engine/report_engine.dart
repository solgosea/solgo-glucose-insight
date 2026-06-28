import '../../../../engine/statistics/agp_calculator.dart';
import '../../../../engine/statistics/tir_calculator.dart';
import '../../../../domain/entities/glucose_reading.dart';
import 'calculators/report_coverage_calculator.dart';
import 'calculators/report_daily_curve_calculator.dart';
import 'calculators/report_episode_summary_calculator.dart';
import 'calculators/report_period_analysis_calculator.dart';
import 'calculators/report_reading_normalizer.dart';
import 'report_engine_input.dart';
import 'report_engine_output.dart';
import 'section_builders/report_agp_section_builder.dart';
import 'section_builders/report_header_section_builder.dart';
import 'section_builders/report_metrics_section_builder.dart';
import 'section_builders/report_ranges_section_builder.dart';

class ReportEngine {
  final ReportReadingNormalizer normalizer;
  final ReportCoverageCalculator coverageCalculator;
  final ReportDailyCurveCalculator dailyCurveCalculator;
  final ReportPeriodAnalysisCalculator periodAnalysisCalculator;
  final ReportEpisodeSummaryCalculator episodeSummaryCalculator;
  final ReportHeaderSectionBuilder headerSectionBuilder;
  final ReportMetricsSectionBuilder metricsSectionBuilder;
  final ReportRangesSectionBuilder rangesSectionBuilder;
  final ReportAgpSectionBuilder agpSectionBuilder;

  const ReportEngine({
    this.normalizer = const ReportReadingNormalizer(),
    this.coverageCalculator = const ReportCoverageCalculator(),
    this.dailyCurveCalculator = const ReportDailyCurveCalculator(),
    this.periodAnalysisCalculator = const ReportPeriodAnalysisCalculator(),
    this.episodeSummaryCalculator = const ReportEpisodeSummaryCalculator(),
    this.headerSectionBuilder = const ReportHeaderSectionBuilder(),
    this.metricsSectionBuilder = const ReportMetricsSectionBuilder(),
    this.rangesSectionBuilder = const ReportRangesSectionBuilder(),
    this.agpSectionBuilder = const ReportAgpSectionBuilder(),
  });

  ReportEngineOutput run(ReportEngineInput input) {
    final normalized = normalizer.normalize(_readingsInRange(input));
    final rows = normalized.readings;
    final reportEnd = rows.isNotEmpty ? rows.last.timestamp : input.generatedAt;
    final periodDays = input.end.difference(input.start).inDays + 1;
    final quality = coverageCalculator.calculate(
      rows,
      settings: input.settings,
      periodDays: periodDays,
      duplicateCount: normalized.duplicateCount,
    );
    final tir = TirCalculator.calculate(
      rows,
      low: input.settings.lowThreshold,
      high: input.settings.highThreshold,
      veryHigh: input.settings.veryHighThreshold,
      veryLow: ReportCoverageCalculator.veryLowMmol,
    );

    return ReportEngineOutput(
      period: input.period,
      start: input.start,
      end: input.end,
      settings: input.settings,
      readings: rows,
      generatedAt: input.generatedAt,
      headerSection: headerSectionBuilder.build(
        readings: rows,
        period: input.period,
        start: input.start,
        end: input.end,
        generatedAt: input.generatedAt,
        quality: quality,
      ),
      metricsSection: metricsSectionBuilder.build(tir: tir, quality: quality),
      rangesSection: rangesSectionBuilder.build(
        quality: quality,
        period: input.period,
        periodDays: periodDays,
      ),
      agpSection: agpSectionBuilder.build(AgpCalculator.calculate(rows)),
      dailyCurvesSection:
          dailyCurveCalculator.calculate(rows, input.settings, reportEnd),
      periodAnalysisSection:
          periodAnalysisCalculator.calculate(rows, input.settings),
      episodesSection: episodeSummaryCalculator.calculate(rows, input.settings),
    );
  }

  List<GlucoseReading> _readingsInRange(ReportEngineInput input) {
    final exclusiveEnd = input.end.add(const Duration(days: 1));
    return input.readings
        .where(
          (reading) =>
              !reading.timestamp.isBefore(input.start) &&
              reading.timestamp.isBefore(exclusiveEnd),
        )
        .toList();
  }
}
