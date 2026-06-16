import '../application/statistics_period_query.dart';
import '../domain/statistics_analysis_window_id.dart';
import '../models/statistics_view_model.dart';

class StatisticsRuntimeSnapshot {
  final StatisticsPeriodQuery query;
  final StatisticsViewModel viewModel;
  final DateTime updatedAt;

  const StatisticsRuntimeSnapshot({
    required this.query,
    required this.viewModel,
    required this.updatedAt,
  });
}

class StatisticsRuntimeCache {
  final Map<String, StatisticsRuntimeSnapshot> _snapshots = {};
  bool _stale = true;
  String? _staleReason;

  bool get stale => _stale;
  String? get staleReason => _staleReason;

  List<StatisticsRuntimeSnapshot> get snapshots =>
      List.unmodifiable(_snapshots.values);

  void put(StatisticsRuntimeSnapshot snapshot) {
    _snapshots[snapshot.query.cacheKey] = snapshot;
    _stale = false;
    _staleReason = null;
  }

  void markStale(String reason) {
    _stale = true;
    _staleReason = reason;
  }

  StatisticsViewModel? freshViewModel({
    required String subjectId,
    required StatisticsAnalysisWindowId windowId,
  }) {
    if (_stale) return null;
    final query = StatisticsPeriodQuery(
      subjectId: subjectId,
      windowId: windowId,
    );
    return _snapshots[query.cacheKey]?.viewModel;
  }
}
