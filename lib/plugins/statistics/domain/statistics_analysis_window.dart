import 'statistics_analysis_window_id.dart';

class StatisticsAnalysisWindow {
  final StatisticsAnalysisWindowId id;
  final String label;
  final String headerLabel;
  final Duration duration;
  final Duration comparisonDuration;
  final bool isAgpRecommended;

  const StatisticsAnalysisWindow({
    required this.id,
    required this.label,
    required this.headerLabel,
    required this.duration,
    required this.comparisonDuration,
    required this.isAgpRecommended,
  });
}
