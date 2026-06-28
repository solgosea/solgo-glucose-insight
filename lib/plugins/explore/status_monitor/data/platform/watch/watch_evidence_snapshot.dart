class WatchEvidenceSnapshot {
  final bool receiverConfigured;
  final bool evidenceObserved;
  final DateTime? latestEvidenceAt;
  final String? bridgeName;
  final bool displayObserved;
  final List<DateTime> timeline;

  const WatchEvidenceSnapshot({
    required this.receiverConfigured,
    required this.evidenceObserved,
    this.latestEvidenceAt,
    this.bridgeName,
    this.displayObserved = false,
    this.timeline = const [],
  });
}
