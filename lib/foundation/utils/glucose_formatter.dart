import '../../application/glucose_unit/glucose_unit_format_service.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/glucose_trend/glucose_trend_visual_mapper.dart';
import '../../domain/glucose_unit/glucose_unit_converter.dart';

class GlucoseFormatter {
  static const _formatService = GlucoseUnitFormatService();
  static const _converter = GlucoseUnitConverter();
  static const _trendVisualMapper = GlucoseTrendVisualMapper();

  static String format(
    double mmol, {
    GlucoseUnit unit = GlucoseUnit.mmolL,
    bool showUnit = false,
  }) {
    final display = _formatService.value(mmol, unit);
    return showUnit ? display.fullLabel : display.valueLabel;
  }

  static String range(
    double lowMmol,
    double highMmol, {
    GlucoseUnit unit = GlucoseUnit.mmolL,
  }) {
    return _formatService.range(lowMmol, highMmol, unit).fullLabel;
  }

  static String rate(
    double mmolPerMin, {
    GlucoseUnit unit = GlucoseUnit.mmolL,
  }) {
    return _formatService.rate(mmolPerMin, unit).fullLabel;
  }

  static String area(
    double mmolMinutes, {
    GlucoseUnit unit = GlucoseUnit.mmolL,
  }) {
    return _formatService.area(mmolMinutes, unit).fullLabel;
  }

  static double mgToMmol(double mg) =>
      _converter.valueToMmol(mg, GlucoseUnit.mgDl);

  static double mmolToMg(double mmol) =>
      _converter.valueFromMmol(mmol, GlucoseUnit.mgDl);

  static String trend(double ratePerMin) {
    return _trendVisualMapper.map(ratePerMin).arrow;
  }

  static String duration(int minutes) {
    if (minutes < 60) return '${minutes}m';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '${h}h' : '${h}h ${m}m';
  }
}
