import '../../domain/entities/app_settings.dart';
import '../../domain/glucose_unit/glucose_display_area.dart';
import '../../domain/glucose_unit/glucose_display_range.dart';
import '../../domain/glucose_unit/glucose_display_rate.dart';
import '../../domain/glucose_unit/glucose_display_value.dart';
import '../../domain/glucose_unit/glucose_unit_converter.dart';
import '../../domain/glucose_unit/glucose_unit_precision_policy.dart';

class GlucoseUnitFormatService {
  final GlucoseUnitConverter converter;
  final GlucoseUnitPrecisionPolicy precisionPolicy;

  const GlucoseUnitFormatService({
    this.converter = const GlucoseUnitConverter(),
    this.precisionPolicy = const GlucoseUnitPrecisionPolicy(),
  });

  String unitLabel(GlucoseUnit unit) {
    return switch (unit) {
      GlucoseUnit.mmolL => 'mmol/L',
      GlucoseUnit.mgDl => 'mg/dL',
    };
  }

  String rateUnitLabel(GlucoseUnit unit) {
    return switch (unit) {
      GlucoseUnit.mmolL => 'mmol/L/min',
      GlucoseUnit.mgDl => 'mg/dL/min',
    };
  }

  String areaUnitLabel(GlucoseUnit unit) {
    return switch (unit) {
      GlucoseUnit.mmolL => 'mmol-min',
      GlucoseUnit.mgDl => 'mg/dL-min',
    };
  }

  GlucoseDisplayValue value(double mmol, GlucoseUnit unit) {
    final displayValue = converter.valueFromMmol(mmol, unit);
    final label = displayValue.toStringAsFixed(
      precisionPolicy.valueDecimals(unit),
    );
    final unitText = unitLabel(unit);
    return GlucoseDisplayValue(
      value: displayValue,
      valueLabel: label,
      unitLabel: unitText,
      fullLabel: '$label $unitText',
    );
  }

  GlucoseDisplayRange range(double lowMmol, double highMmol, GlucoseUnit unit) {
    final low = value(lowMmol, unit);
    final high = value(highMmol, unit);
    return GlucoseDisplayRange(
      low: low.value,
      high: high.value,
      lowLabel: low.valueLabel,
      highLabel: high.valueLabel,
      unitLabel: low.unitLabel,
      fullLabel: '${low.valueLabel}-${high.valueLabel} ${low.unitLabel}',
    );
  }

  GlucoseDisplayRate rate(double mmolPerMin, GlucoseUnit unit) {
    final displayValue = converter.rateFromMmolPerMin(mmolPerMin, unit);
    final sign = displayValue >= 0 ? '+' : '';
    final label =
        '$sign${displayValue.toStringAsFixed(precisionPolicy.rateDecimals(unit))}';
    final unitText = rateUnitLabel(unit);
    return GlucoseDisplayRate(
      value: displayValue,
      valueLabel: label,
      unitLabel: unitText,
      fullLabel: '$label $unitText',
    );
  }

  GlucoseDisplayArea area(double mmolMinutes, GlucoseUnit unit) {
    final displayValue = converter.areaFromMmolMinutes(mmolMinutes, unit);
    final label = displayValue.toStringAsFixed(
      precisionPolicy.areaDecimals(unit),
    );
    final unitText = areaUnitLabel(unit);
    return GlucoseDisplayArea(
      value: displayValue,
      valueLabel: label,
      unitLabel: unitText,
      fullLabel: '$label $unitText',
    );
  }
}
