import '../entities/app_settings.dart';

class GlucoseThresholdContext {
  final double veryLow;
  final double low;
  final double high;
  final double veryHigh;

  const GlucoseThresholdContext({
    this.veryLow = 3.0,
    required this.low,
    required this.high,
    required this.veryHigh,
  });

  factory GlucoseThresholdContext.fromSettings(AppSettings settings) =>
      GlucoseThresholdContext(
        low: settings.lowThreshold,
        high: settings.highThreshold,
        veryHigh: settings.veryHighThreshold,
      );

  bool isVeryLow(double value) => value < veryLow;

  bool isLow(double value) => value < low;

  bool isInRange(double value) => value >= low && value <= high;

  bool isHigh(double value) => value > high;

  bool isVeryHigh(double value) => value > veryHigh;

  double distanceOutOfRange(double value) {
    if (value < low) return low - value;
    if (value > high) return value - high;
    return 0;
  }
}
