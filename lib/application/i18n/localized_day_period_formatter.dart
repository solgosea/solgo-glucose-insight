import '../../domain/time/day_period.dart';
import '../../domain/time/relative_day.dart';
import '../../l10n/generated/app_localizations.dart';
import 'localized_relative_time_formatter.dart';

class LocalizedDayPeriodFormatter {
  final AppLocalizations l10n;
  final LocalizedRelativeTimeFormatter relativeFormatter;

  const LocalizedDayPeriodFormatter(
    this.l10n,
    this.relativeFormatter,
  );

  String dayPeriod(DayPeriod period) {
    return switch (period) {
      DayPeriod.dawn => l10n.dayPeriodDawn,
      DayPeriod.morning => l10n.dayPeriodMorning,
      DayPeriod.afternoon => l10n.dayPeriodAfternoon,
      DayPeriod.evening => l10n.dayPeriodEvening,
      DayPeriod.night => l10n.dayPeriodNight,
    };
  }

  String dayPeriodFor(DateTime date) {
    return dayPeriod(DayPeriod.fromHour(date.hour));
  }

  String relativeDayPeriod(
    DateTime date,
    DayPeriod period, {
    DateTime? now,
  }) {
    final periodLabel = dayPeriod(period);
    return switch (relativeFormatter.relativeDay(date, now: now)) {
      RelativeDay.today => l10n.relativeDayPeriodToday(periodLabel),
      RelativeDay.yesterday => l10n.relativeDayPeriodYesterday(periodLabel),
      RelativeDay.tomorrow => l10n.relativeDayPeriodTomorrow(periodLabel),
      RelativeDay.date => periodLabel,
    };
  }
}
