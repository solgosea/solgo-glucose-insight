class CanonicalGlucoseCandidate {
  final int bucketMs;
  final DateTime timestamp;
  final double value;
  final double? ratePerMin;
  final String source;
  final String rawId;
  final int sourcePriority;
  final DateTime updatedAt;

  const CanonicalGlucoseCandidate({
    required this.bucketMs,
    required this.timestamp,
    required this.value,
    required this.source,
    required this.rawId,
    required this.sourcePriority,
    required this.updatedAt,
    this.ratePerMin,
  });
}
