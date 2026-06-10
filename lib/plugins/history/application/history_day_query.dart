class HistoryDayQuery {
  final String subjectId;
  final DateTime day;

  const HistoryDayQuery({required this.subjectId, required this.day});

  DateTime get normalizedDay => DateTime(day.year, day.month, day.day);

  String get cacheKey {
    final normalized = normalizedDay;
    final year = normalized.year.toString().padLeft(4, '0');
    final month = normalized.month.toString().padLeft(2, '0');
    final date = normalized.day.toString().padLeft(2, '0');
    return '$subjectId:$year-$month-$date';
  }
}
