enum StatisticsAnalysisWindowId {
  last24Hours('24h'),
  last3Days('3d'),
  last7Days('7d'),
  last14Days('14d'),
  last30Days('30d'),
  last90Days('90d');

  final String code;

  const StatisticsAnalysisWindowId(this.code);

  static StatisticsAnalysisWindowId fromCode(String code) {
    return StatisticsAnalysisWindowId.values.firstWhere(
      (id) => id.code == code,
      orElse: () => StatisticsAnalysisWindowId.last14Days,
    );
  }
}
