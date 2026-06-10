import '../entities/app_settings.dart';

class GlucoseUnitPrecisionPolicy {
  const GlucoseUnitPrecisionPolicy();

  int valueDecimals(GlucoseUnit unit) {
    return switch (unit) {
      GlucoseUnit.mmolL => 1,
      GlucoseUnit.mgDl => 0,
    };
  }

  int rateDecimals(GlucoseUnit unit) {
    return switch (unit) {
      GlucoseUnit.mmolL => 2,
      GlucoseUnit.mgDl => 1,
    };
  }

  int areaDecimals(GlucoseUnit unit) {
    return switch (unit) {
      GlucoseUnit.mmolL => 1,
      GlucoseUnit.mgDl => 0,
    };
  }
}
