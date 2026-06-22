class ReportDataQualitySummary {
  final double? coveragePercent;
  final int? readingCount;
  final int? expectedReadingCount;
  final int? largestGapMinutes;
  final String label;

  const ReportDataQualitySummary({
    required this.label,
    this.coveragePercent,
    this.readingCount,
    this.expectedReadingCount,
    this.largestGapMinutes,
  });
}
