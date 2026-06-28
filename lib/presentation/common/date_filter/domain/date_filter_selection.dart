class DateFilterSelection {
  final DateTime start;
  final DateTime end;

  DateFilterSelection({
    required DateTime start,
    required DateTime end,
  })  : start = _dateOnly(start.isAfter(end) ? end : start),
        end = _dateOnly(start.isAfter(end) ? start : end);

  factory DateFilterSelection.single(DateTime day) =>
      DateFilterSelection(start: day, end: day);

  bool get isSingleDay => _sameDay(start, end);

  DateTime get exclusiveEnd => end.add(const Duration(days: 1));

  bool contains(DateTime day) {
    final d = _dateOnly(day);
    return !d.isBefore(start) && !d.isAfter(end);
  }

  bool isStart(DateTime day) => _sameDay(start, day);

  bool isEnd(DateTime day) => _sameDay(end, day);

  DateFilterSelection copyWith({
    DateTime? start,
    DateTime? end,
  }) {
    return DateFilterSelection(
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  static DateTime _dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  static bool _sameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
