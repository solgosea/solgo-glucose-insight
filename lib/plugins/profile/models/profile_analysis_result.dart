class ProfileAnalysisResult {
  final double tir14d;
  final double average14d;
  final double cv14d;
  final DateTime? latestReadingAt;
  final int? lastReceivedMinutesAgo;
  final List<ProfileTargetRange> targetRanges;

  const ProfileAnalysisResult({
    required this.tir14d,
    required this.average14d,
    required this.cv14d,
    required this.latestReadingAt,
    required this.lastReceivedMinutesAgo,
    required this.targetRanges,
  });
}

class ProfileTargetRange {
  final ProfileTargetRangeKind kind;
  final String label;
  final String description;
  final double value;
  final double? upperValue;
  final String unit;

  const ProfileTargetRange({
    required this.kind,
    required this.label,
    required this.description,
    required this.value,
    this.upperValue,
    required this.unit,
  });
}

enum ProfileTargetRangeKind { target, low, high, veryHigh }
