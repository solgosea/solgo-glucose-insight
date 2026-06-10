class GlucoseConstants {
  static const double defaultLow = 3.9;
  static const double defaultHigh = 10.0;
  static const double defaultVeryHigh = 13.9;
  static const double targetCvStable = 36.0;
  static const int readingsPerDay = 288; // 5-min intervals
  static const Duration readingInterval = Duration(minutes: 5);
}
