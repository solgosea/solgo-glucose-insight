import '../domain/statistics_analysis_window_id.dart';

class StatisticsPeriodQuery {
  final String subjectId;
  final StatisticsAnalysisWindowId windowId;

  const StatisticsPeriodQuery({
    required this.subjectId,
    required this.windowId,
  });

  String get cacheKey => '$subjectId:${windowId.code}';
}
