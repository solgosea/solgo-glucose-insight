import 'dart:math' as math;

import '../../../../../domain/entities/glucose_reading.dart';

class StatusMath {
  const StatusMath();

  double cv(List<GlucoseReading> readings) {
    if (readings.isEmpty) return 0;
    final mean =
        readings.map((reading) => reading.value).reduce((a, b) => a + b) /
            readings.length;
    if (mean <= 0) return 0;
    final variance = readings
            .map((reading) => math.pow(reading.value - mean, 2).toDouble())
            .reduce((a, b) => a + b) /
        readings.length;
    return math.sqrt(variance) / mean * 100;
  }

  int suddenChanges(List<GlucoseReading> readings) {
    return suddenChangeTimestamps(readings).length;
  }

  List<DateTime> suddenChangeTimestamps(List<GlucoseReading> readings) {
    if (readings.length < 2) return const [];
    final timestamps = <DateTime>[];
    for (var i = 1; i < readings.length; i++) {
      final previous = readings[i - 1];
      final current = readings[i];
      final minutes =
          current.timestamp.difference(previous.timestamp).inMinutes.abs();
      if (minutes <= 5 && (current.value - previous.value).abs() > 5.0) {
        timestamps.add(current.timestamp);
      }
    }
    return timestamps;
  }

  Duration longestFlatLine(List<GlucoseReading> readings) {
    if (readings.length < 2) return Duration.zero;
    Duration longest = Duration.zero;
    DateTime? currentStart;
    for (var i = 1; i < readings.length; i++) {
      final previous = readings[i - 1];
      final current = readings[i];
      final flat = (current.value - previous.value).abs() < .1;
      if (flat) {
        currentStart ??= previous.timestamp;
        final duration = current.timestamp.difference(currentStart).abs();
        if (duration > longest) longest = duration;
      } else {
        currentStart = null;
      }
    }
    return longest;
  }

  double completenessRatio(List<GlucoseReading> readings) {
    const expectedPer24h = 288;
    return (readings.length / expectedPer24h).clamp(0.0, 1.0);
  }
}
