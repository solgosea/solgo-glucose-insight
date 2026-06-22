import '../../../../domain/entities/app_settings.dart';
import '../../../../application/i18n/localized_date_time_formatter.dart';

class EpisodeDetailFormatters {
  const EpisodeDetailFormatters._();

  static String hm(DateTime time, {String? localeName}) =>
      LocalizedDateTimeFormatter(localeName ?? 'en').time(time);

  static String range(DateTime start, DateTime end, {String? localeName}) =>
      '${hm(start, localeName: localeName)} - ${hm(end, localeName: localeName)}';

  static String headerDate(DateTime time, {String? localeName}) =>
      LocalizedDateTimeFormatter(localeName ?? 'en').dateFull(time);

  static String headerEpisodeRange(
    DateTime start,
    DateTime? end, {
    String? localeName,
  }) {
    final date = shortDate(start, localeName: localeName);
    if (end == null) return '$date · ${hm(start, localeName: localeName)}';
    return '$date · ${range(start, end, localeName: localeName)}';
  }

  static String shortDate(DateTime time, {String? localeName}) =>
      LocalizedDateTimeFormatter(localeName ?? 'en').dateShort(time);

  static String rate(
    double? rate, {
    required GlucoseUnit unit,
    bool forcePositive = false,
  }) {
    if (rate == null || rate.isNaN) return '--';
    final value = unit == GlucoseUnit.mgDl ? rate * 18.0 : rate;
    final sign = value > 0 || forcePositive ? '+' : '';
    final decimals = unit == GlucoseUnit.mgDl ? 1 : 2;
    return '$sign${value.toStringAsFixed(decimals)} ${unit == GlucoseUnit.mgDl ? 'mg/dL' : 'mmol/L'}/min';
  }

  static String signedRate(double rate, {required GlucoseUnit unit}) =>
      EpisodeDetailFormatters.rate(rate, unit: unit, forcePositive: rate >= 0);
}
