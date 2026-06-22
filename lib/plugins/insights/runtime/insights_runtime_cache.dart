import '../models/insights_view_model.dart';
import '../engine/insights_engine_output.dart';

class InsightsRuntimeSnapshot {
  final String subjectId;
  final InsightsEngineOutput output;
  final InsightsViewModel viewModel;
  final DateTime updatedAt;

  const InsightsRuntimeSnapshot({
    required this.subjectId,
    required this.output,
    required this.viewModel,
    required this.updatedAt,
  });
}

class InsightsRuntimeCache {
  final Map<String, InsightsRuntimeSnapshot> _snapshots = {};
  bool _stale = true;
  String? _staleReason;

  bool get stale => _stale;
  String? get staleReason => _staleReason;

  List<InsightsRuntimeSnapshot> get snapshots =>
      List.unmodifiable(_snapshots.values);

  void put(InsightsRuntimeSnapshot snapshot) {
    _snapshots[snapshot.subjectId] = snapshot;
    _stale = false;
    _staleReason = null;
  }

  void markStale(String reason) {
    _stale = true;
    _staleReason = reason;
  }

  InsightsViewModel? freshViewModel({required String subjectId}) {
    if (_stale) return null;
    return _snapshots[subjectId]?.viewModel;
  }

  InsightsEngineOutput? freshOutput({required String subjectId}) {
    if (_stale) return null;
    return _snapshots[subjectId]?.output;
  }
}
