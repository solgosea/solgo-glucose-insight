import 'dart:math' as math;

import 'package:smart_xdrip/domain/entities/glucose_reading.dart';

class PeriodVariability {
  final String label;
  final String windowText;
  final double cv;
  final int rank;
  final int total;

  const PeriodVariability({
    required this.label,
    required this.windowText,
    required this.cv,
    required this.rank,
    required this.total,
  });
}

class EpisodeContextAnalyzer {
  const EpisodeContextAnalyzer();

  double? typicalSlopeForHours(
    List<GlucoseReading> readings, {
    required int startHour,
    required int endHour,
  }) {
    final slopes = <double>[];
    final sorted = [...readings]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    for (var i = 1; i < sorted.length; i++) {
      final previous = sorted[i - 1];
      final current = sorted[i];
      if (!_isInsideHourWindow(previous.timestamp.hour, startHour, endHour) ||
          !_isInsideHourWindow(current.timestamp.hour, startHour, endHour)) {
        continue;
      }
      final minutes =
          current.timestamp.difference(previous.timestamp).inMinutes;
      if (minutes <= 0 || minutes > 30) continue;
      slopes.add((current.value - previous.value) / minutes);
    }
    if (slopes.isEmpty) return null;
    return slopes.reduce((a, b) => a + b) / slopes.length;
  }

  PeriodVariability? variabilityForHour(
    List<GlucoseReading> readings,
    int hour,
  ) {
    final periods = <_PeriodBucket>[
      const _PeriodBucket('Overnight', '00:00-06:00', 0, 6),
      const _PeriodBucket('Morning', '06:00-12:00', 6, 12),
      const _PeriodBucket('Afternoon', '12:00-18:00', 12, 18),
      const _PeriodBucket('Evening', '18:00-24:00', 18, 24),
    ];
    final ranked = <PeriodVariability>[];
    for (final bucket in periods) {
      final rows =
          readings
              .where(
                (r) => _isInsideHourWindow(
                  r.timestamp.hour,
                  bucket.start,
                  bucket.end,
                ),
              )
              .toList();
      final cv = _cv(rows);
      if (cv == null) continue;
      ranked.add(
        PeriodVariability(
          label: bucket.label,
          windowText: bucket.windowText,
          cv: cv,
          rank: 0,
          total: 0,
        ),
      );
    }
    if (ranked.isEmpty) return null;
    ranked.sort((a, b) => b.cv.compareTo(a.cv));
    final target = periods.firstWhere(
      (p) => _isInsideHourWindow(hour, p.start, p.end),
      orElse: () => periods.first,
    );
    for (var i = 0; i < ranked.length; i++) {
      final item = ranked[i];
      if (item.label == target.label) {
        return PeriodVariability(
          label: item.label,
          windowText: item.windowText,
          cv: item.cv,
          rank: i + 1,
          total: ranked.length,
        );
      }
    }
    return null;
  }

  bool _isInsideHourWindow(int hour, int start, int end) {
    if (end == 24) return hour >= start && hour < 24;
    return hour >= start && hour < end;
  }

  double? _cv(List<GlucoseReading> rows) {
    if (rows.length < 2) return null;
    final mean = rows.map((r) => r.value).reduce((a, b) => a + b) / rows.length;
    if (mean == 0) return null;
    final variance =
        rows.map((r) => math.pow(r.value - mean, 2)).reduce((a, b) => a + b) /
        rows.length;
    return math.sqrt(variance) / mean * 100;
  }
}

class _PeriodBucket {
  final String label;
  final String windowText;
  final int start;
  final int end;

  const _PeriodBucket(this.label, this.windowText, this.start, this.end);
}
