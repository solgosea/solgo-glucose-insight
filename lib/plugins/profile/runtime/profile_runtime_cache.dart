import '../../../domain/data_source/data_source_connection_snapshot.dart';
import '../models/profile_view_model.dart';

class ProfileRuntimeSnapshot {
  final String subjectId;
  final ProfileViewModel viewModel;
  final List<DataSourceConnectionSnapshot> sourceSnapshots;
  final DateTime updatedAt;

  const ProfileRuntimeSnapshot({
    required this.subjectId,
    required this.viewModel,
    required this.sourceSnapshots,
    required this.updatedAt,
  });
}

class ProfileRuntimeCache {
  final Map<String, ProfileRuntimeSnapshot> _snapshots = {};
  bool _stale = true;
  String? _staleReason;

  bool get stale => _stale;
  String? get staleReason => _staleReason;

  List<ProfileRuntimeSnapshot> get snapshots =>
      List.unmodifiable(_snapshots.values);

  void put(ProfileRuntimeSnapshot snapshot) {
    _snapshots[snapshot.subjectId] = snapshot;
    _stale = false;
    _staleReason = null;
  }

  void markStale(String reason) {
    _stale = true;
    _staleReason = reason;
  }

  ProfileRuntimeSnapshot? freshSnapshot({required String subjectId}) {
    if (_stale) return null;
    return _snapshots[subjectId];
  }
}
