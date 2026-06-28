class AapsEvidenceSnapshot {
  final bool receiverConfigured;
  final bool evidenceObserved;
  final DateTime? latestEvidenceAt;
  final String? bgSource;
  final bool devicestatusObserved;
  final bool loopContextObserved;
  final String? loopState;
  final List<DateTime> timeline;

  const AapsEvidenceSnapshot({
    required this.receiverConfigured,
    required this.evidenceObserved,
    this.latestEvidenceAt,
    this.bgSource,
    this.devicestatusObserved = false,
    this.loopContextObserved = false,
    this.loopState,
    this.timeline = const [],
  });
}
