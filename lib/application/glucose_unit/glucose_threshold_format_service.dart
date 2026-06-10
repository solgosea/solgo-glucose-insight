import '../../domain/entities/app_settings.dart';
import 'glucose_unit_format_service.dart';

class GlucoseThresholdFormatService {
  final GlucoseUnitFormatService formatter;

  const GlucoseThresholdFormatService({
    this.formatter = const GlucoseUnitFormatService(),
  });

  String targetRange(AppSettings settings) {
    return formatter
        .range(settings.lowThreshold, settings.highThreshold, settings.unit)
        .fullLabel;
  }

  String highLabel(AppSettings settings) {
    return '>${formatter.value(settings.highThreshold, settings.unit).valueLabel}';
  }

  String lowLabel(AppSettings settings) {
    return '<${formatter.value(settings.lowThreshold, settings.unit).valueLabel}';
  }

  String veryHighLabel(AppSettings settings) {
    return '>${formatter.value(settings.veryHighThreshold, settings.unit).valueLabel}';
  }
}
