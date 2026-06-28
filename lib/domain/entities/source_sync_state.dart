class SourceSyncState {
  final String sourceKey;
  final DateTime? lastSuccessAt;
  final DateTime? lastAttemptAt;
  final String? lastCursor;
  final String? lastError;
  final int? lastFetchedCount;
  final int? lastStoredCount;
  final DateTime? coveredFrom;
  final DateTime? coveredTo;
  final int? syncWindowDays;
  final DateTime updatedAt;

  const SourceSyncState({
    required this.sourceKey,
    required this.updatedAt,
    this.lastSuccessAt,
    this.lastAttemptAt,
    this.lastCursor,
    this.lastError,
    this.lastFetchedCount,
    this.lastStoredCount,
    this.coveredFrom,
    this.coveredTo,
    this.syncWindowDays,
  });
}
