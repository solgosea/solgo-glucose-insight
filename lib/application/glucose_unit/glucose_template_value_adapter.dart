import '../../domain/entities/app_settings.dart';
import 'glucose_unit_format_service.dart';

class GlucoseTemplateValueAdapter {
  final GlucoseUnitFormatService formatter;

  const GlucoseTemplateValueAdapter({
    this.formatter = const GlucoseUnitFormatService(),
  });

  Map<String, Object> displayFactsFor(AppSettings settings) {
    return {
      'glucoseUnit': formatter.unitLabel(settings.unit),
      'glucoseRateUnit': formatter.rateUnitLabel(settings.unit),
      'targetRange':
          formatter
              .range(
                settings.lowThreshold,
                settings.highThreshold,
                settings.unit,
              )
              .fullLabel,
      'lowThreshold':
          formatter.value(settings.lowThreshold, settings.unit).valueLabel,
      'highThreshold':
          formatter.value(settings.highThreshold, settings.unit).valueLabel,
      'veryHighThreshold':
          formatter.value(settings.veryHighThreshold, settings.unit).valueLabel,
    };
  }
}
