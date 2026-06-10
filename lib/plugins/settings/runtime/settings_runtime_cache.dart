import '../models/settings_analysis_result.dart';
import '../models/settings_view_model.dart';

class SettingsRuntimeSnapshot {
  final SettingsViewModel viewModel;
  final SettingsAnalysisResult analysis;
  final DateTime updatedAt;

  const SettingsRuntimeSnapshot({
    required this.viewModel,
    required this.analysis,
    required this.updatedAt,
  });
}

class SettingsRuntimeCache {
  SettingsRuntimeSnapshot? _snapshot;
  bool _stale = true;
  String? _staleReason;

  bool get stale => _stale;
  String? get staleReason => _staleReason;
  SettingsRuntimeSnapshot? get snapshot => _stale ? null : _snapshot;
  SettingsRuntimeSnapshot? get latestSnapshot => _snapshot;

  void put(SettingsRuntimeSnapshot snapshot) {
    _snapshot = snapshot;
    _stale = false;
    _staleReason = null;
  }

  void markStale(String reason) {
    _stale = true;
    _staleReason = reason;
  }
}
