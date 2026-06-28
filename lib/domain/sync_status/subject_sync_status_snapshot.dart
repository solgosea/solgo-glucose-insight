enum SubjectSyncStatusPhase {
  idle,
  syncing,
  synced,
  failed,
}

class SubjectSyncStatusSnapshot {
  final String subjectId;
  final SubjectSyncStatusPhase phase;
  final DateTime? lastAttemptAt;
  final DateTime? lastSuccessAt;
  final int lastFetchedCount;
  final int lastStoredCount;
  final String? lastError;

  const SubjectSyncStatusSnapshot({
    required this.subjectId,
    required this.phase,
    this.lastAttemptAt,
    this.lastSuccessAt,
    this.lastFetchedCount = 0,
    this.lastStoredCount = 0,
    this.lastError,
  });

  factory SubjectSyncStatusSnapshot.idle(String subjectId) {
    return SubjectSyncStatusSnapshot(
      subjectId: subjectId,
      phase: SubjectSyncStatusPhase.idle,
    );
  }

  SubjectSyncStatusSnapshot started(DateTime at) {
    return SubjectSyncStatusSnapshot(
      subjectId: subjectId,
      phase: SubjectSyncStatusPhase.syncing,
      lastAttemptAt: at,
      lastSuccessAt: lastSuccessAt,
      lastFetchedCount: lastFetchedCount,
      lastStoredCount: lastStoredCount,
      lastError: null,
    );
  }
}
