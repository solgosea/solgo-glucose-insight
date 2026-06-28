import 'package:flutter/material.dart';
import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/presentation/common/widgets/charts/agp_chart.dart';
import '../domain/statistics_analysis_window_id.dart';

enum StatisticsDeltaTone { up, down, flat }

class StatisticsViewModel {
  final StatisticsAnalysisWindowId selectedWindowId;
  final String dateFilterLabel;
  final List<StatisticsPeriodOptionViewModel> periodOptions;
  final String metricsHeader;
  final List<StatisticsMetricCardViewModel> metrics;
  final StatisticsTirBreakdownViewModel tirBreakdown;
  final StatisticsAgpViewModel agp;
  final StatisticsHeatmapViewModel heatmap;

  const StatisticsViewModel({
    required this.selectedWindowId,
    this.dateFilterLabel = '',
    required this.periodOptions,
    required this.metricsHeader,
    required this.metrics,
    required this.tirBreakdown,
    required this.agp,
    required this.heatmap,
  });
}

class StatisticsPeriodOptionViewModel {
  final StatisticsAnalysisWindowId id;
  final String label;
  final bool selected;

  const StatisticsPeriodOptionViewModel({
    required this.id,
    required this.label,
    required this.selected,
  });
}

class StatisticsMetricCardViewModel {
  final String label;
  final String value;
  final String? suffix;
  final Color valueColor;
  final String unit;
  final String deltaText;
  final StatisticsDeltaTone deltaTone;

  const StatisticsMetricCardViewModel({
    required this.label,
    required this.value,
    required this.valueColor,
    required this.unit,
    required this.deltaText,
    required this.deltaTone,
    this.suffix,
  });
}

class StatisticsTirBreakdownViewModel {
  final List<StatisticsTirSegmentViewModel> segments;
  final List<StatisticsLegendItemViewModel> legends;
  final List<StatisticsExtremeCellViewModel> extremes;

  const StatisticsTirBreakdownViewModel({
    required this.segments,
    required this.legends,
    required this.extremes,
  });
}

class StatisticsTirSegmentViewModel {
  final Color color;
  final double fraction;

  const StatisticsTirSegmentViewModel({
    required this.color,
    required this.fraction,
  });
}

class StatisticsLegendItemViewModel {
  final Color color;
  final String text;

  const StatisticsLegendItemViewModel({
    required this.color,
    required this.text,
  });
}

class StatisticsExtremeCellViewModel {
  final String label;
  final String value;
  final String subtitle;

  const StatisticsExtremeCellViewModel({
    required this.label,
    required this.value,
    required this.subtitle,
  });
}

class StatisticsAgpViewModel {
  final String title;
  final String guidanceText;
  final List<AnalysisAgpSlot> slots;
  final GlucoseUnit unit;
  final double lowThreshold;
  final double highThreshold;
  final List<AgpAnnotation> annotations;
  final String note;

  const StatisticsAgpViewModel({
    required this.title,
    this.guidanceText = '',
    required this.slots,
    required this.unit,
    required this.lowThreshold,
    required this.highThreshold,
    required this.annotations,
    required this.note,
  });
}

class StatisticsHeatmapViewModel {
  final String title;
  final List<StatisticsHeatmapCellViewModel> cells;
  final List<String> labels;

  const StatisticsHeatmapViewModel({
    required this.title,
    required this.cells,
    required this.labels,
  });
}

class StatisticsHeatmapCellViewModel {
  final int hour;
  final double tirPct;
  final Color color;
  final String timeLabel;
  final String tirLabel;
  final String tagLabel;
  final Color tagColor;

  const StatisticsHeatmapCellViewModel({
    required this.hour,
    required this.tirPct,
    required this.color,
    required this.timeLabel,
    required this.tirLabel,
    required this.tagLabel,
    required this.tagColor,
  });
}
