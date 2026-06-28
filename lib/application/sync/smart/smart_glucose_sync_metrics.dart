class SmartGlucoseSyncMetrics {
  final int chunkCount;
  final int rawFetchedCount;
  final int mergedCount;

  const SmartGlucoseSyncMetrics({
    required this.chunkCount,
    required this.rawFetchedCount,
    required this.mergedCount,
  });
}
