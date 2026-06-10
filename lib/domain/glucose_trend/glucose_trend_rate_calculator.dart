import '../entities/glucose_reading.dart';

class GlucoseTrendRateCalculator {
  final Duration minInterval;
  final Duration maxInterval;

  const GlucoseTrendRateCalculator({
    this.minInterval = const Duration(minutes: 2),
    this.maxInterval = const Duration(minutes: 20),
  });

  double? ratePerMin({
    required GlucoseReading previous,
    required GlucoseReading current,
  }) {
    final interval = current.timestamp.difference(previous.timestamp);
    if (interval < minInterval || interval > maxInterval) return null;

    final minutes = interval.inMilliseconds / Duration.millisecondsPerMinute;
    if (minutes <= 0) return null;
    return (current.value - previous.value) / minutes;
  }
}
