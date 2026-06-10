import 'dart:math';

import '../../domain/entities/glucose_reading.dart';

/// Deterministic CGM dataset for development and UI debugging.
///
/// The generated readings intentionally cover the analysis surface:
/// - 90 days of 5-minute CGM samples for Home, History, Stats, and Insights.
/// - Sustained high and low windows for event pages.
/// - Rapid-rise windows for transition detection.
/// - Stable windows for normal-state cards.
/// - Missing-sample gaps for source-quality diagnostics.
///
/// The data remains source-neutral: every module consumes only GlucoseReading.
class MockGlucoseGenerator {
  static const int days = 90;
  static const int intervalMinutes = 5;
  static const int readingsPerDay = 24 * 60 ~/ intervalMinutes;

  static List<GlucoseReading> generate90Days({DateTime? anchor}) {
    final readings = <GlucoseReading>[];
    final now = anchor ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final start = today.subtract(const Duration(days: days - 1));

    for (var dayOffset = 0; dayOffset < days; dayOffset++) {
      final day = start.add(Duration(days: dayOffset));
      for (var sample = 0; sample < readingsPerDay; sample++) {
        final timestamp = day.add(Duration(minutes: sample * intervalMinutes));
        if (timestamp.isAfter(now)) break;
        if (_isPlannedGap(timestamp, dayOffset)) continue;

        readings.add(
          GlucoseReading(
            timestamp: timestamp,
            value: _valueAt(timestamp, dayOffset, sample).clamp(2.4, 16.8),
          ),
        );
      }
    }

    return _withRateOfChange(readings);
  }

  static List<GlucoseReading> forDay(List<GlucoseReading> all, DateTime day) {
    return all
        .where(
          (r) =>
              r.timestamp.year == day.year &&
              r.timestamp.month == day.month &&
              r.timestamp.day == day.day,
        )
        .toList();
  }

  static double _valueAt(DateTime timestamp, int dayOffset, int sample) {
    final h = timestamp.hour + timestamp.minute / 60.0;
    final weekday = timestamp.weekday;
    final phase = dayOffset / 8.0;

    final longTermDrift = sin(dayOffset / 11.0) * 0.25;
    final weekdayBias = weekday >= 6 ? 0.45 : 0.0;
    final dayBias = _cycle(dayOffset * 19, amplitude: 0.22);
    final sampleNoise = _cycle(dayOffset * 977 + sample * 37, amplitude: 0.16);

    var value = 6.1 + longTermDrift + weekdayBias + dayBias + sampleNoise;

    value += _pulse(h, center: 5.8, width: 1.1, amplitude: 1.25);
    value += _pulse(h, center: 9.2, width: 1.0, amplitude: 1.35);
    value += _pulse(h, center: 14.0, width: 1.25, amplitude: 1.05);
    value += _pulse(h, center: 20.3, width: 1.3, amplitude: 1.2);
    value -= _pulse(h, center: 3.1, width: 1.0, amplitude: 0.35);

    if (_hasHighWindow(dayOffset)) {
      value += _pulse(h, center: 20.6, width: 0.75, amplitude: 4.2);
    }
    if (_isCurrentDebugDay(dayOffset)) {
      value += _pulse(h, center: 6.55, width: 0.55, amplitude: 4.85);
      value += _pulse(h, center: 7.75, width: 0.72, amplitude: 4.55);
    }
    if (_hasMorningHighWindow(dayOffset)) {
      value += _pulse(h, center: 8.5, width: 0.65, amplitude: 3.5);
    }
    if (_hasLowWindow(dayOffset)) {
      value -= _pulse(h, center: 2.4, width: 0.55, amplitude: 3.25);
    }
    if (_isCurrentDebugDay(dayOffset)) {
      value -= _pulse(h, center: 3.35, width: 0.42, amplitude: 3.15);
    }
    if (_hasDaytimeLowWindow(dayOffset)) {
      value -= _pulse(h, center: 16.1, width: 0.45, amplitude: 2.7);
    }
    if (_hasRapidRiseWindow(dayOffset)) {
      value += _ramp(h, start: 11.15, end: 11.55, amplitude: 2.35);
      value += _pulse(h, center: 11.75, width: 0.42, amplitude: 1.1);
    }
    if (_hasStableDay(dayOffset)) {
      value =
          6.25 +
          _pulse(h, center: 6.0, width: 1.0, amplitude: 0.35) +
          _pulse(h, center: 20.0, width: 1.0, amplitude: 0.25) +
          _cycle(dayOffset * 101 + sample, amplitude: 0.08);
    }

    return value + sin(phase + h * 0.35) * 0.12;
  }

  static bool _hasHighWindow(int dayOffset) =>
      dayOffset >= days - 14 && dayOffset % 4 == 1;

  static bool _isCurrentDebugDay(int dayOffset) => dayOffset == days - 1;

  static bool _hasMorningHighWindow(int dayOffset) =>
      dayOffset >= days - 30 && dayOffset % 9 == 2;

  static bool _hasLowWindow(int dayOffset) =>
      dayOffset >= days - 14 && dayOffset % 6 == 3;

  static bool _hasDaytimeLowWindow(int dayOffset) =>
      dayOffset >= days - 45 && dayOffset % 13 == 5;

  static bool _hasRapidRiseWindow(int dayOffset) =>
      dayOffset >= days - 21 && dayOffset % 5 == 0;

  static bool _hasStableDay(int dayOffset) =>
      dayOffset >= days - 21 && dayOffset % 10 == 7;

  static bool _isPlannedGap(DateTime timestamp, int dayOffset) {
    final h = timestamp.hour + timestamp.minute / 60.0;
    if (dayOffset >= days - 21 && dayOffset % 11 == 4) {
      return h >= 10.0 && h < 11.25;
    }
    if (dayOffset >= days - 45 && dayOffset % 17 == 8) {
      return h >= 1.5 && h < 2.25;
    }
    return false;
  }

  static double _pulse(
    double h, {
    required double center,
    required double width,
    required double amplitude,
  }) {
    final z = (h - center) / width;
    return amplitude * exp(-z * z);
  }

  static double _ramp(
    double h, {
    required double start,
    required double end,
    required double amplitude,
  }) {
    if (h < start) return 0;
    if (h > end) return amplitude;
    return amplitude * ((h - start) / (end - start));
  }

  static double _cycle(int seed, {required double amplitude}) {
    final x = sin(seed * 12.9898) * 43758.5453;
    final fraction = x - x.floorToDouble();
    return (fraction - 0.5) * 2 * amplitude;
  }

  static List<GlucoseReading> _withRateOfChange(List<GlucoseReading> rows) {
    if (rows.isEmpty) return const [];
    final result = <GlucoseReading>[
      GlucoseReading(
        timestamp: rows.first.timestamp,
        value: rows.first.value,
        ratePerMin: 0,
      ),
    ];

    for (var i = 1; i < rows.length; i++) {
      final previous = rows[i - 1];
      final current = rows[i];
      final minutes =
          current.timestamp.difference(previous.timestamp).inMinutes;
      final rate =
          minutes <= 0 ? 0.0 : (current.value - previous.value) / minutes;
      result.add(
        GlucoseReading(
          timestamp: current.timestamp,
          value: current.value,
          ratePerMin: rate,
        ),
      );
    }
    return result;
  }
}
