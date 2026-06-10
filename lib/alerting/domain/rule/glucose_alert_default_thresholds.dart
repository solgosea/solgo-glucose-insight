class GlucoseAlertDefaultThresholds {
  static const urgentLowMmol = 3.0; // 54 mg/dL
  static const lowMmol = 3.9; // 70 mg/dL
  static const highMmol = 10.0; // 180 mg/dL
  static const rapidFallRateMmolPerMin = -0.10;
  static const rapidFallGuardMmol = 6.0;
  static const noDataMinutes = 20.0;

  const GlucoseAlertDefaultThresholds._();
}
