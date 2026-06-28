enum StatusTargetSyncPhase {
  unavailable,
  idle,
  running,
  synced,
  failed,
}

class StatusTargetSyncState {
  final String? targetId;
  final String label;
  final StatusTargetSyncPhase phase;
  final DateTime? lastAttemptAt;
  final DateTime? lastSuccessAt;
  final DateTime? nextDueAt;
  final int? lastFetchedCount;
  final int? lastStoredCount;
  final String? failureLabel;

  const StatusTargetSyncState({
    required this.targetId,
    required this.label,
    required this.phase,
    this.lastAttemptAt,
    this.lastSuccessAt,
    this.nextDueAt,
    this.lastFetchedCount,
    this.lastStoredCount,
    this.failureLabel,
  });

  const StatusTargetSyncState.unavailable({
    this.targetId,
    this.label = 'No sync target',
    this.failureLabel,
  })  : phase = StatusTargetSyncPhase.unavailable,
        lastAttemptAt = null,
        lastSuccessAt = null,
        nextDueAt = null,
        lastFetchedCount = null,
        lastStoredCount = null;

  bool get available => phase != StatusTargetSyncPhase.unavailable;
}
