import '../../domain/time/relative_day.dart';
import '../../l10n/generated/app_localizations.dart';

class LocalizedRelativeTimeFormatter {
  final AppLocalizations l10n;

  const LocalizedRelativeTimeFormatter(this.l10n);

  String relative(
    DateTime? date, {
    DateTime? now,
    bool compact = true,
  }) {
    if (date == null) return l10n.timeNever;
    final delta = (now ?? DateTime.now()).difference(date);
    if (delta.inSeconds < 60) return l10n.timeJustNow;
    if (delta.inMinutes < 60) return l10n.timeMinutesAgo(delta.inMinutes);
    if (delta.inHours < 24) return l10n.timeHoursAgo(delta.inHours);
    return l10n.timeDaysAgo(delta.inDays);
  }

  RelativeDay relativeDay(DateTime date, {DateTime? now}) {
    final anchor = _dateOnly(now ?? DateTime.now());
    final target = _dateOnly(date);
    final diff = target.difference(anchor).inDays;
    return switch (diff) {
      0 => RelativeDay.today,
      -1 => RelativeDay.yesterday,
      1 => RelativeDay.tomorrow,
      _ => RelativeDay.date,
    };
  }

  String relativeDayLabel(DateTime date, {DateTime? now}) {
    return switch (relativeDay(date, now: now)) {
      RelativeDay.today => l10n.dateToday,
      RelativeDay.yesterday => l10n.dateYesterday,
      RelativeDay.tomorrow => l10n.dateTomorrow,
      RelativeDay.date => '',
    };
  }

  DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }
}
