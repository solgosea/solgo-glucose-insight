enum DateFilterDayTone {
  none,
  sparse,
  partial,
  full,
}

class DateFilterDayBucket {
  final DateTime date;
  final int readingCount;
  final DateFilterDayTone tone;
  final bool disabled;

  const DateFilterDayBucket({
    required this.date,
    required this.readingCount,
    this.tone = DateFilterDayTone.none,
    this.disabled = false,
  });
}
