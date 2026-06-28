class SyncWindowCoverage {
  final String subjectId;
  final String sourceKey;
  final DateTime? coveredFrom;
  final DateTime? coveredTo;
  final int? syncWindowDays;

  const SyncWindowCoverage({
    required this.subjectId,
    required this.sourceKey,
    this.coveredFrom,
    this.coveredTo,
    this.syncWindowDays,
  });
}
