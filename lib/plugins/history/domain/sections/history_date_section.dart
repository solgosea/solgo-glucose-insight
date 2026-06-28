class HistoryDateSection {
  final DateTime selectedDay;
  final DateTime rangeStart;
  final DateTime rangeEnd;
  final bool isToday;

  const HistoryDateSection({
    required this.selectedDay,
    required this.rangeStart,
    required this.rangeEnd,
    required this.isToday,
  });

  bool get isSingleDay =>
      rangeStart.year == rangeEnd.year &&
      rangeStart.month == rangeEnd.month &&
      rangeStart.day == rangeEnd.day;
}
