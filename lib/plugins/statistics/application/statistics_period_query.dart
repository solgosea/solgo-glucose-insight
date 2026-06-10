class StatisticsPeriodQuery {
  final String subjectId;
  final int periodDays;

  const StatisticsPeriodQuery({
    required this.subjectId,
    required this.periodDays,
  });

  String get cacheKey => '$subjectId:${periodDays}d';
}
