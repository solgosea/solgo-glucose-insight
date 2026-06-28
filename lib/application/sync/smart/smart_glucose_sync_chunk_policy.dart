class SmartGlucoseSyncChunkPolicy {
  final Duration chunkSize;
  final Duration minChunkSize;

  const SmartGlucoseSyncChunkPolicy({
    this.chunkSize = const Duration(days: 1),
    this.minChunkSize = const Duration(minutes: 15),
  });
}
