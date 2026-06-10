import '../models/home_chart_range.dart';
import '../models/home_view_model.dart';

class HomeRuntimeSnapshot {
  final String subjectId;
  final HomeChartRange range;
  final HomeViewModel viewModel;
  final DateTime updatedAt;

  const HomeRuntimeSnapshot({
    required this.subjectId,
    required this.range,
    required this.viewModel,
    required this.updatedAt,
  });
}

class HomeRuntimeCache {
  final Map<HomeChartRange, HomeRuntimeSnapshot> _snapshots = {};
  bool _stale = true;
  String? _staleReason;

  bool get stale => _stale;
  String? get staleReason => _staleReason;

  List<HomeRuntimeSnapshot> get snapshots =>
      List.unmodifiable(_snapshots.values);

  void put(HomeRuntimeSnapshot snapshot) {
    _snapshots[snapshot.range] = snapshot;
    _stale = false;
    _staleReason = null;
  }

  void markStale(String reason) {
    _stale = true;
    _staleReason = reason;
  }

  HomeViewModel? freshViewModel({
    required String subjectId,
    required HomeChartRange range,
  }) {
    if (_stale) return null;
    final snapshot = _snapshots[range];
    if (snapshot == null || snapshot.subjectId != subjectId) return null;
    return snapshot.viewModel;
  }
}
