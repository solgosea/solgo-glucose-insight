import '../statistics_analysis_window.dart';
import '../statistics_analysis_window_id.dart';

class StatisticsPeriodOption {
  final StatisticsAnalysisWindowId id;
  final String label;
  final bool selected;

  const StatisticsPeriodOption({
    required this.id,
    required this.label,
    required this.selected,
  });
}

class StatisticsPeriodSection {
  final StatisticsAnalysisWindow selectedWindow;
  final List<StatisticsPeriodOption> options;
  final String metricsHeader;
  final String? rangeLabel;

  const StatisticsPeriodSection({
    required this.selectedWindow,
    required this.options,
    required this.metricsHeader,
    this.rangeLabel,
  });
}
