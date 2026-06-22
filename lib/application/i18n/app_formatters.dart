import '../../domain/time/date_range_granularity.dart';
import '../../domain/time/day_period.dart';
import '../../l10n/generated/app_localizations.dart';
import 'localized_date_time_formatter.dart';
import 'localized_day_period_formatter.dart';
import 'localized_duration_formatter.dart';
import 'localized_relative_time_formatter.dart';

class AppFormatters {
  final AppLocalizations l10n;
  late final LocalizedDateTimeFormatter dateTime;
  late final LocalizedRelativeTimeFormatter relativeTime;
  late final LocalizedDayPeriodFormatter dayPeriods;
  late final LocalizedDurationFormatter durations;

  AppFormatters(this.l10n) {
    dateTime = LocalizedDateTimeFormatter(l10n.localeName);
    relativeTime = LocalizedRelativeTimeFormatter(l10n);
    dayPeriods = LocalizedDayPeriodFormatter(l10n, relativeTime);
    durations = LocalizedDurationFormatter(l10n);
  }

  String dateShort(DateTime date) => dateTime.dateShort(date);

  String dateFull(DateTime date) => dateTime.dateFull(date);

  String dateTimeLabel(DateTime date) => dateTime.dateTime(date);

  String time(DateTime date) => dateTime.time(date);

  String weekdayFull(DateTime date) => dateTime.weekdayFull(date);

  String weekdayShort(DateTime date) => dateTime.weekdayShort(date);

  String dateRange(
    DateTime start,
    DateTime end, {
    DateRangeGranularity granularity = DateRangeGranularity.short,
  }) {
    return dateTime.dateRange(start, end, granularity: granularity);
  }

  String relative(DateTime? date, {DateTime? now}) {
    return relativeTime.relative(date, now: now);
  }

  String dayPeriod(DayPeriod period) => dayPeriods.dayPeriod(period);

  String relativeDayPeriod(
    DateTime date,
    DayPeriod period, {
    DateTime? now,
  }) {
    return dayPeriods.relativeDayPeriod(date, period, now: now);
  }

  String durationShort(Duration duration) => durations.short(duration);
}
