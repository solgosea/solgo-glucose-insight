import '../glucose_trend/glucose_trend_visual_mapper.dart';

class GlucoseReading {
  final DateTime timestamp;
  final double value; // mmol/L
  final double? ratePerMin;

  const GlucoseReading({
    required this.timestamp,
    required this.value,
    this.ratePerMin,
  });

  String get trendArrow {
    return const GlucoseTrendVisualMapper().map(ratePerMin).arrow;
  }
}
