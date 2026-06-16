import '../domain/statistics_analysis_window_id.dart';

class StatisticsWindowPolicy {
  final StatisticsAnalysisWindowId defaultWindowId;

  const StatisticsWindowPolicy({
    this.defaultWindowId = StatisticsAnalysisWindowId.last14Days,
  });
}
