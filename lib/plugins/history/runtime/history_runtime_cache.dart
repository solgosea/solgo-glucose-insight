import '../application/history_day_query.dart';
import '../models/history_view_model.dart';

class HistoryRuntimeSnapshot {
  final HistoryDayQuery query;
  final HistoryViewModel viewModel;
  final DateTime updatedAt;

  const HistoryRuntimeSnapshot({
    required this.query,
    required this.viewModel,
    required this.updatedAt,
  });
}

class HistoryRuntimeCache {
  final Map<String, HistoryRuntimeSnapshot> _snapshots = {};
  bool _stale = true;
  String? _staleReason;

  bool get stale => _stale;
  String? get staleReason => _staleReason;

  List<HistoryRuntimeSnapshot> get snapshots =>
      List.unmodifiable(_snapshots.values);

  void put(HistoryRuntimeSnapshot snapshot) {
    _snapshots[snapshot.query.cacheKey] = snapshot;
    _stale = false;
    _staleReason = null;
  }

  void markStale(String reason) {
    _stale = true;
    _staleReason = reason;
  }

  HistoryViewModel? freshViewModel({
    required String subjectId,
    required DateTime day,
  }) {
    if (_stale) return null;
    final query = HistoryDayQuery(subjectId: subjectId, day: day);
    return _snapshots[query.cacheKey]?.viewModel;
  }
}
