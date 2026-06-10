import 'package:smart_xdrip/application/glucose_unit/glucose_unit_format_service.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';

class EpisodeDetailFormatters {
  const EpisodeDetailFormatters._();

  static const _glucoseFormatter = GlucoseUnitFormatService();

  static String hm(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:'
      '${t.minute.toString().padLeft(2, '0')}';

  static String shortDate(DateTime t) {
    const months = [
      '',
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
    return '${months[t.month]} ${t.day}';
  }

  static String headerDate(DateTime t) => '${shortDate(t)} | ${hm(t)}';

  static String range(DateTime start, DateTime end) =>
      '${hm(start)}-${hm(end)}';

  static String rate(
    double value, {
    GlucoseUnit unit = GlucoseUnit.mmolL,
    bool forcePositive = false,
  }) {
    final display = _glucoseFormatter.rate(value.abs(), unit);
    final sign = value < 0 ? '-' : (forcePositive ? '+' : '');
    return '$sign${display.valueLabel} ${display.unitLabel}';
  }

  static String signedRate(
    double value, {
    GlucoseUnit unit = GlucoseUnit.mmolL,
  }) {
    final display = _glucoseFormatter.rate(value.abs(), unit);
    return '${value >= 0 ? '+' : '-'}${display.valueLabel}/min';
  }

  static String pct(double value) => '${value.round()}%';
}
