import 'package:flutter/foundation.dart';

import '../sync/glucose_sync_result.dart';
import '../../domain/sync_status/subject_sync_status_snapshot.dart';

class SubjectSyncStatusStore extends ChangeNotifier {
  final Map<String, SubjectSyncStatusSnapshot> _snapshots = {};

  Map<String, SubjectSyncStatusSnapshot> get snapshots =>
      Map.unmodifiable(_snapshots);

  SubjectSyncStatusSnapshot? snapshotFor(String subjectId) {
    return _snapshots[subjectId];
  }

  void markStarted({
    required String subjectId,
    required DateTime at,
  }) {
    final current =
        _snapshots[subjectId] ?? SubjectSyncStatusSnapshot.idle(subjectId);
    _snapshots[subjectId] = current.started(at);
    notifyListeners();
  }

  void markStartedForAll({
    required Iterable<String> subjectIds,
    required DateTime at,
  }) {
    var changed = false;
    for (final subjectId in subjectIds) {
      final id = subjectId.trim();
      if (id.isEmpty) continue;
      final current = _snapshots[id] ?? SubjectSyncStatusSnapshot.idle(id);
      _snapshots[id] = current.started(at);
      changed = true;
    }
    if (changed) notifyListeners();
  }

  void applyResults({
    required Iterable<GlucoseSyncResult> results,
    required DateTime completedAt,
  }) {
    var changed = false;
    for (final result in results) {
      final subjectId = result.subjectId.trim();
      if (subjectId.isEmpty) continue;
      final previous =
          _snapshots[subjectId] ?? SubjectSyncStatusSnapshot.idle(subjectId);
      _snapshots[subjectId] = SubjectSyncStatusSnapshot(
        subjectId: subjectId,
        phase: result.success
            ? SubjectSyncStatusPhase.synced
            : SubjectSyncStatusPhase.failed,
        lastAttemptAt: completedAt,
        lastSuccessAt: result.success ? completedAt : previous.lastSuccessAt,
        lastFetchedCount: result.fetchedCount,
        lastStoredCount: result.storedCount,
        lastError: result.success ? null : result.error,
      );
      changed = true;
    }
    if (changed) notifyListeners();
  }

  void clear() {
    if (_snapshots.isEmpty) return;
    _snapshots.clear();
    notifyListeners();
  }
}
