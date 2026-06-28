class GlucoseSyncSchedulerMetrics {
  final int enqueuedCount;
  final int runningCount;
  final int completedCount;
  final int skippedCount;
  final int failedCount;
  final int fetchedCount;
  final int storedCount;

  const GlucoseSyncSchedulerMetrics({
    this.enqueuedCount = 0,
    this.runningCount = 0,
    this.completedCount = 0,
    this.skippedCount = 0,
    this.failedCount = 0,
    this.fetchedCount = 0,
    this.storedCount = 0,
  });

  GlucoseSyncSchedulerMetrics copyWith({
    int? enqueuedCount,
    int? runningCount,
    int? completedCount,
    int? skippedCount,
    int? failedCount,
    int? fetchedCount,
    int? storedCount,
  }) {
    return GlucoseSyncSchedulerMetrics(
      enqueuedCount: enqueuedCount ?? this.enqueuedCount,
      runningCount: runningCount ?? this.runningCount,
      completedCount: completedCount ?? this.completedCount,
      skippedCount: skippedCount ?? this.skippedCount,
      failedCount: failedCount ?? this.failedCount,
      fetchedCount: fetchedCount ?? this.fetchedCount,
      storedCount: storedCount ?? this.storedCount,
    );
  }
}
