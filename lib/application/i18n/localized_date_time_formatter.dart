import '../../domain/time/date_range_granularity.dart';

class LocalizedDateTimeFormatter {
  final String localeName;

  const LocalizedDateTimeFormatter(this.localeName);

  String dateShort(DateTime date) {
    final local = date.toLocal();
    if (_isChinese) return '${local.month}月${local.day}日';
    return '${_shortMonth(local.month)} ${local.day}';
  }

  String dateFull(DateTime date) {
    final local = date.toLocal();
    if (_isChinese) return '${local.year}年${local.month}月${local.day}日';
    return '${_shortMonth(local.month)} ${local.day}, ${local.year}';
  }

  String dateTime(DateTime date) {
    return '${dateFull(date)} ${time(date)}';
  }

  String time(DateTime date) {
    final local = date.toLocal();
    return '${local.hour.toString().padLeft(2, '0')}:'
        '${local.minute.toString().padLeft(2, '0')}';
  }

  String weekdayFull(DateTime date) {
    final local = date.toLocal();
    if (_isChinese) {
      const weekdays = ['星期一', '星期二', '星期三', '星期四', '星期五', '星期六', '星期日'];
      return weekdays[(local.weekday - 1).clamp(0, weekdays.length - 1)];
    }
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return weekdays[(local.weekday - 1).clamp(0, weekdays.length - 1)];
  }

  String weekdayShort(DateTime date) {
    final local = date.toLocal();
    if (_isChinese) {
      const weekdays = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
      return weekdays[(local.weekday - 1).clamp(0, weekdays.length - 1)];
    }
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[(local.weekday - 1).clamp(0, weekdays.length - 1)];
  }

  String dateRange(
    DateTime start,
    DateTime end, {
    DateRangeGranularity granularity = DateRangeGranularity.short,
  }) {
    final localStart = start.toLocal();
    final localEnd = end.toLocal();
    final startLabel = switch (granularity) {
      DateRangeGranularity.full => dateFull(localStart),
      DateRangeGranularity.month => _yearMonth(localStart),
      DateRangeGranularity.day => '${localStart.day}',
      DateRangeGranularity.short => _rangeStart(localStart, localEnd),
    };
    final endLabel = switch (granularity) {
      DateRangeGranularity.full => dateFull(localEnd),
      DateRangeGranularity.month => _yearMonth(localEnd),
      DateRangeGranularity.day => '${localEnd.day}',
      DateRangeGranularity.short => dateShort(localEnd),
    };
    return '$startLabel - $endLabel';
  }

  String _rangeStart(DateTime start, DateTime end) {
    if (start.year == end.year) return dateShort(start);
    return dateFull(start);
  }

  bool get _isChinese {
    final normalized = localeName.toLowerCase().replaceAll('_', '-');
    return normalized == 'zh' || normalized.startsWith('zh-');
  }

  String _yearMonth(DateTime date) {
    final local = date.toLocal();
    if (_isChinese) return '${local.year}年${local.month}月';
    return '${_fullMonth(local.month)} ${local.year}';
  }

  String _shortMonth(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[(month - 1).clamp(0, months.length - 1)];
  }

  String _fullMonth(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[(month - 1).clamp(0, months.length - 1)];
  }
}
