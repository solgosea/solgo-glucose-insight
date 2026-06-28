class GlucoseSyncWorkerError {
  final String targetId;
  final Object error;
  final StackTrace stackTrace;

  const GlucoseSyncWorkerError({
    required this.targetId,
    required this.error,
    required this.stackTrace,
  });
}
