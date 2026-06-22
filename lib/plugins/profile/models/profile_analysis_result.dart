class ProfileAnalysisResult {
  final double tir14d;
  final double average14d;
  final double cv14d;
  final DateTime? latestReadingAt;
  final int? lastReceivedMinutesAgo;

  const ProfileAnalysisResult({
    required this.tir14d,
    required this.average14d,
    required this.cv14d,
    required this.latestReadingAt,
    required this.lastReceivedMinutesAgo,
  });
}
