import 'calculators/statistics_agp_calculator.dart';
import 'calculators/statistics_dawn_calculator.dart';
import 'calculators/statistics_heatmap_calculator.dart';
import 'calculators/statistics_period_variability_calculator.dart';
import 'calculators/statistics_tir_calculator.dart';
import 'section_builders/statistics_agp_section_builder.dart';
import 'section_builders/statistics_heatmap_section_builder.dart';
import 'section_builders/statistics_metrics_section_builder.dart';
import 'section_builders/statistics_period_section_builder.dart';
import 'section_builders/statistics_tir_breakdown_section_builder.dart';
import 'statistics_engine_input.dart';
import 'statistics_engine_output.dart';

class StatisticsEngine {
  final StatisticsTirCalculator tirCalculator;
  final StatisticsAgpCalculator agpCalculator;
  final StatisticsDawnCalculator dawnCalculator;
  final StatisticsPeriodVariabilityCalculator variabilityCalculator;
  final StatisticsHeatmapCalculator heatmapCalculator;
  final StatisticsPeriodSectionBuilder periodSectionBuilder;
  final StatisticsMetricsSectionBuilder metricsSectionBuilder;
  final StatisticsTirBreakdownSectionBuilder tirBreakdownSectionBuilder;
  final StatisticsAgpSectionBuilder agpSectionBuilder;
  final StatisticsHeatmapSectionBuilder heatmapSectionBuilder;

  const StatisticsEngine({
    this.tirCalculator = const StatisticsTirCalculator(),
    this.agpCalculator = const StatisticsAgpCalculator(),
    this.dawnCalculator = const StatisticsDawnCalculator(),
    this.variabilityCalculator = const StatisticsPeriodVariabilityCalculator(),
    this.heatmapCalculator = const StatisticsHeatmapCalculator(),
    this.periodSectionBuilder = const StatisticsPeriodSectionBuilder(),
    this.metricsSectionBuilder = const StatisticsMetricsSectionBuilder(),
    this.tirBreakdownSectionBuilder =
        const StatisticsTirBreakdownSectionBuilder(),
    this.agpSectionBuilder = const StatisticsAgpSectionBuilder(),
    this.heatmapSectionBuilder = const StatisticsHeatmapSectionBuilder(),
  });

  StatisticsEngineOutput run(StatisticsEngineInput input) {
    final currentTir = tirCalculator.calculate(
      input.currentReadings,
      input.settings,
    );
    final previousTir = tirCalculator.calculate(
      input.previousReadings,
      input.settings,
    );
    final agpSlots = agpCalculator.calculate(input.currentReadings);
    final hourlyTir = heatmapCalculator.calculateHourlyTir(
      readings: input.currentReadings,
      settings: input.settings,
    );

    return StatisticsEngineOutput(
      settings: input.settings,
      periodSection: periodSectionBuilder.build(
        selectedWindow: input.selectedWindow,
        windows: input.windows,
        rangeLabel: input.rangeLabel,
      ),
      metricsSection: metricsSectionBuilder.build(
        current: currentTir,
        previous: previousTir,
      ),
      tirBreakdownSection: tirBreakdownSectionBuilder.build(currentTir),
      agpSection: agpSectionBuilder.build(
        window: input.selectedWindow,
        readings: input.currentReadings,
        slots: agpSlots,
        dawn: dawnCalculator.calculate(input.currentReadings),
        variablePeriods: variabilityCalculator.calculate(
          readings: input.currentReadings,
          settings: input.settings,
        ),
      ),
      heatmapSection: heatmapSectionBuilder.build(hourlyTir),
    );
  }
}
