class SourceSyncState {
  final String sourceKey;
  final DateTime? lastSuccessAt;
  final DateTime? lastAttemptAt;
  final String? lastCursor;
  final String? lastError;
  final DateTime updatedAt;

  const SourceSyncState({
    required this.sourceKey,
    required this.updatedAt,
    this.lastSuccessAt,
    this.lastAttemptAt,
    this.lastCursor,
    this.lastError,
  });
}
