import '../domain/date_filter_day_bucket.dart';

class DateFilterMonthBuilder {
  const DateFilterMonthBuilder();

  List<DateFilterDayBucket> build({
    required DateTime month,
    required Map<DateTime, int> readingCounts,
    DateTime? maxDate,
  }) {
    final days = DateTime(month.year, month.month + 1, 0).day;
    final limit = maxDate == null
        ? null
        : DateTime(maxDate.year, maxDate.month, maxDate.day);
    return List.generate(days, (index) {
      final date = DateTime(month.year, month.month, index + 1);
      final count = readingCounts[date] ?? 0;
      return DateFilterDayBucket(
        date: date,
        readingCount: count,
        tone: _tone(count),
        disabled: limit != null && date.isAfter(limit),
      );
    });
  }

  DateFilterDayTone _tone(int count) {
    if (count <= 0) return DateFilterDayTone.none;
    if (count < 48) return DateFilterDayTone.sparse;
    if (count < 180) return DateFilterDayTone.partial;
    return DateFilterDayTone.full;
  }
}
