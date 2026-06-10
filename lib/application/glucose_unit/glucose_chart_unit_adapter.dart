import '../../domain/entities/app_settings.dart';
import '../../domain/entities/glucose_reading.dart';
import '../../domain/glucose_unit/glucose_unit_converter.dart';

class GlucoseChartUnitAdapter {
  final GlucoseUnitConverter converter;

  const GlucoseChartUnitAdapter({
    this.converter = const GlucoseUnitConverter(),
  });

  double value(double mmol, GlucoseUnit unit) {
    return converter.valueFromMmol(mmol, unit);
  }

  double threshold(double mmol, GlucoseUnit unit) {
    return converter.valueFromMmol(mmol, unit);
  }

  List<GlucoseReading> readings(List<GlucoseReading> source, GlucoseUnit unit) {
    if (unit == GlucoseUnit.mmolL) return source;
    return source
        .map(
          (reading) => GlucoseReading(
            timestamp: reading.timestamp,
            value: converter.valueFromMmol(reading.value, unit),
            ratePerMin:
                reading.ratePerMin == null
                    ? null
                    : converter.rateFromMmolPerMin(reading.ratePerMin!, unit),
          ),
        )
        .toList();
  }

  double minY(GlucoseUnit unit) {
    return converter.valueFromMmol(2.0, unit);
  }

  double maxY(GlucoseUnit unit) {
    return converter.valueFromMmol(14.0, unit);
  }
}
