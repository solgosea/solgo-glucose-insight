import '../entities/app_settings.dart';

class GlucoseUnitConverter {
  static const mgDlPerMmolL = 18.0;

  const GlucoseUnitConverter();

  double valueFromMmol(double mmol, GlucoseUnit unit) {
    return switch (unit) {
      GlucoseUnit.mmolL => mmol,
      GlucoseUnit.mgDl => mmol * mgDlPerMmolL,
    };
  }

  double valueToMmol(double value, GlucoseUnit unit) {
    return switch (unit) {
      GlucoseUnit.mmolL => value,
      GlucoseUnit.mgDl => value / mgDlPerMmolL,
    };
  }

  double rateFromMmolPerMin(double mmolPerMin, GlucoseUnit unit) {
    return switch (unit) {
      GlucoseUnit.mmolL => mmolPerMin,
      GlucoseUnit.mgDl => mmolPerMin * mgDlPerMmolL,
    };
  }

  double areaFromMmolMinutes(double mmolMinutes, GlucoseUnit unit) {
    return switch (unit) {
      GlucoseUnit.mmolL => mmolMinutes,
      GlucoseUnit.mgDl => mmolMinutes * mgDlPerMmolL,
    };
  }
}
