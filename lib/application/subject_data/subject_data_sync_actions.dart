class SubjectDataSyncActions {
  final Future<void> Function({
    required String trigger,
    Map<String, Object?> payload,
  })
  syncAllTargets;

  const SubjectDataSyncActions({required this.syncAllTargets});
}
