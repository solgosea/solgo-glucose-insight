import 'dart:math' as math;

import 'package:smart_xdrip/domain/entities/glucose_event.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';

class EpisodeWindowAnalysis {
  final DateTime start;
  final DateTime preMidpoint;
  final DateTime end;
  final List<GlucoseReading> readings;
  final List<GlucoseReading> earlyPreReadings;
  final List<GlucoseReading> leadUpReadings;
  final GlucoseReading? extremeReading;
  final double? leadUpSlope;
  final double? baselineLow;
  final double? baselineHigh;
  final double? currentWindowCv;

  const EpisodeWindowAnalysis({
    required this.start,
    required this.preMidpoint,
    required this.end,
    required this.readings,
    required this.earlyPreReadings,
    required this.leadUpReadings,
    required this.extremeReading,
    required this.leadUpSlope,
    required this.baselineLow,
    required this.baselineHigh,
    required this.currentWindowCv,
  });
}

class EpisodeWindowAnalyzer {
  const EpisodeWindowAnalyzer();

  EpisodeWindowAnalysis analyze({
    required GlucoseEvent event,
    required List<GlucoseReading> allReadings,
    required bool high,
  }) {
    final start = event.time.subtract(const Duration(hours: 2));
    final preMidpoint = event.time.subtract(
      high ? const Duration(minutes: 55) : const Duration(minutes: 20),
    );
    final end = (event.endTime ?? event.time).add(const Duration(hours: 2));
    final readings =
        allReadings
            .where(
              (r) => !r.timestamp.isBefore(start) && !r.timestamp.isAfter(end),
            )
            .toList();
    final earlyPre =
        readings
            .where(
              (r) =>
                  !r.timestamp.isBefore(start) &&
                  r.timestamp.isBefore(preMidpoint),
            )
            .toList();
    final leadUp =
        readings
            .where(
              (r) =>
                  !r.timestamp.isBefore(preMidpoint) &&
                  r.timestamp.isBefore(event.time),
            )
            .toList();
    final extreme =
        readings.isEmpty
            ? null
            : readings.reduce(
              (a, b) =>
                  high
                      ? (a.value > b.value ? a : b)
                      : (a.value < b.value ? a : b),
            );

    return EpisodeWindowAnalysis(
      start: start,
      preMidpoint: preMidpoint,
      end: end,
      readings: readings,
      earlyPreReadings: earlyPre,
      leadUpReadings: leadUp,
      extremeReading: extreme,
      leadUpSlope: slope(leadUp),
      baselineLow: minValue(earlyPre),
      baselineHigh: maxValue(earlyPre),
      currentWindowCv: cv(readings),
    );
  }

  double? slope(List<GlucoseReading> rows) {
    if (rows.length < 2) return null;
    final minutes =
        rows.last.timestamp.difference(rows.first.timestamp).inMinutes;
    if (minutes <= 0) return null;
    return (rows.last.value - rows.first.value) / minutes;
  }

  double? minValue(List<GlucoseReading> rows) {
    if (rows.isEmpty) return null;
    return rows.map((r) => r.value).reduce(math.min);
  }

  double? maxValue(List<GlucoseReading> rows) {
    if (rows.isEmpty) return null;
    return rows.map((r) => r.value).reduce(math.max);
  }

  double? cv(List<GlucoseReading> rows) {
    if (rows.length < 2) return null;
    final mean = rows.map((r) => r.value).reduce((a, b) => a + b) / rows.length;
    if (mean == 0) return null;
    final variance =
        rows.map((r) => math.pow(r.value - mean, 2)).reduce((a, b) => a + b) /
        rows.length;
    return math.sqrt(variance) / mean * 100;
  }
}
