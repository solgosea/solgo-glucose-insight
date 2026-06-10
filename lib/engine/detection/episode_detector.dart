import '../../domain/entities/glucose_event.dart';
import '../../domain/entities/glucose_reading.dart';

class EpisodeDetector {
  static List<GlucoseEvent> detect(
    List<GlucoseReading> readings, {
    double low = 3.9,
    double high = 10.0,
    int minHighReadings = 6,
    int minLowReadings = 2,
    int stableWindowReadings = 12,
    double riseDelta = 1.7,
    int riseWindowMinutes = 20,
  }) {
    if (readings.isEmpty) return const [];

    final ordered = [...readings]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final events = <GlucoseEvent>[
      ..._detectEpisodes(
        ordered,
        low: low,
        high: high,
        minHighReadings: minHighReadings,
        minLowReadings: minLowReadings,
      ),
      ..._detectFirstReadings(ordered),
      ..._detectRises(
        ordered,
        riseDelta: riseDelta,
        riseWindowMinutes: riseWindowMinutes,
      ),
      ..._detectStableWindows(
        ordered,
        low: low,
        high: high,
        stableWindowReadings: stableWindowReadings,
      ),
      ..._detectDawnWindows(ordered),
    ];

    events.sort((a, b) => a.time.compareTo(b.time));
    return _deduplicate(events);
  }

  static List<GlucoseEvent> _detectEpisodes(
    List<GlucoseReading> readings, {
    required double low,
    required double high,
    required int minHighReadings,
    required int minLowReadings,
  }) {
    final events = <GlucoseEvent>[];
    var i = 0;
    while (i < readings.length) {
      final r = readings[i];

      if (r.value > high) {
        var j = i;
        while (j < readings.length && readings[j].value > high) {
          j++;
        }
        if (j - i >= minHighReadings) {
          final segment = readings.sublist(i, j);
          final peak = segment
              .map((r) => r.value)
              .reduce((a, b) => a > b ? a : b);
          final event = GlucoseEvent(
            type: GlucoseEventType.highEpisode,
            time: segment.first.timestamp,
            value: segment.first.value,
            endTime: segment.last.timestamp,
            peakOrNadir: peak,
            ratePerMin: segment.first.ratePerMin,
            isNocturnal: _isNocturnal(segment.first.timestamp),
            areaOutOfRange: _areaOutOfRange(segment, high, above: true),
          );
          events.add(event);
          final recovery = _findRecovery(readings, j, event, low, high);
          if (recovery != null) events.add(recovery);
        }
        i = j;
      } else if (r.value < low) {
        var j = i;
        while (j < readings.length && readings[j].value < low) {
          j++;
        }
        if (j - i >= minLowReadings) {
          final segment = readings.sublist(i, j);
          final nadir = segment
              .map((r) => r.value)
              .reduce((a, b) => a < b ? a : b);
          final event = GlucoseEvent(
            type: GlucoseEventType.lowEpisode,
            time: segment.first.timestamp,
            value: segment.first.value,
            endTime: segment.last.timestamp,
            peakOrNadir: nadir,
            ratePerMin: segment.first.ratePerMin,
            lowSeverity: _severity(nadir),
            isNocturnal: _isNocturnal(segment.first.timestamp),
            areaOutOfRange: _areaOutOfRange(segment, low, above: false),
          );
          events.add(event);
          final recovery = _findRecovery(readings, j, event, low, high);
          if (recovery != null) events.add(recovery);
        }
        i = j;
      } else {
        i++;
      }
    }
    return events;
  }

  static GlucoseEvent? _findRecovery(
    List<GlucoseReading> readings,
    int startIndex,
    GlucoseEvent source,
    double low,
    double high,
  ) {
    for (var i = startIndex; i < readings.length; i++) {
      final r = readings[i];
      if (r.value >= low && r.value <= high) {
        return GlucoseEvent(
          type: GlucoseEventType.recovery,
          time: r.timestamp,
          value: r.value,
          endTime: r.timestamp,
          peakOrNadir: r.value,
          ratePerMin: r.ratePerMin,
          isNocturnal: _isNocturnal(r.timestamp),
        );
      }
      if (r.timestamp.difference(source.time).inHours >= 6) {
        break;
      }
    }
    return null;
  }

  static List<GlucoseEvent> _detectFirstReadings(
    List<GlucoseReading> readings,
  ) {
    final events = <GlucoseEvent>[];
    DateTime? currentDay;
    for (final r in readings) {
      final day = DateTime(
        r.timestamp.year,
        r.timestamp.month,
        r.timestamp.day,
      );
      if (currentDay == day) continue;
      currentDay = day;
      events.add(
        GlucoseEvent(
          type: GlucoseEventType.firstReading,
          time: r.timestamp,
          value: r.value,
          peakOrNadir: r.value,
          ratePerMin: r.ratePerMin,
          isNocturnal: _isNocturnal(r.timestamp),
        ),
      );
    }
    return events;
  }

  static List<GlucoseEvent> _detectRises(
    List<GlucoseReading> readings, {
    required double riseDelta,
    required int riseWindowMinutes,
  }) {
    final events = <GlucoseEvent>[];
    DateTime? lastRiseAt;

    for (var i = 0; i < readings.length; i++) {
      final start = readings[i];
      for (var j = i + 1; j < readings.length; j++) {
        final end = readings[j];
        final minutes = end.timestamp.difference(start.timestamp).inMinutes;
        if (minutes <= 0) continue;
        if (minutes > riseWindowMinutes) break;

        final delta = end.value - start.value;
        if (delta >= riseDelta) {
          if (lastRiseAt == null ||
              start.timestamp.difference(lastRiseAt).inMinutes >= 60) {
            events.add(
              GlucoseEvent(
                type: GlucoseEventType.rise,
                time: start.timestamp,
                value: start.value,
                endTime: end.timestamp,
                peakOrNadir: end.value,
                ratePerMin: delta / minutes,
                isNocturnal: _isNocturnal(start.timestamp),
              ),
            );
            lastRiseAt = start.timestamp;
          }
          break;
        }
      }
    }
    return events;
  }

  static List<GlucoseEvent> _detectStableWindows(
    List<GlucoseReading> readings, {
    required double low,
    required double high,
    required int stableWindowReadings,
  }) {
    if (readings.length < stableWindowReadings) return const [];
    final events = <GlucoseEvent>[];
    DateTime? lastStableAt;

    for (var i = 0; i <= readings.length - stableWindowReadings; i++) {
      final segment = readings.sublist(i, i + stableWindowReadings);
      if (segment.any((r) => r.value < low || r.value > high)) continue;
      final cv = _cv(segment.map((r) => r.value).toList());
      if (cv > 12) continue;

      final first = segment.first;
      if (lastStableAt != null &&
          first.timestamp.difference(lastStableAt).inMinutes < 180) {
        continue;
      }
      final mean = _mean(segment.map((r) => r.value).toList());
      events.add(
        GlucoseEvent(
          type: GlucoseEventType.stableWindow,
          time: first.timestamp,
          value: mean,
          endTime: segment.last.timestamp,
          peakOrNadir: mean,
          ratePerMin: first.ratePerMin,
          isNocturnal: _isNocturnal(first.timestamp),
        ),
      );
      lastStableAt = first.timestamp;
    }
    return events;
  }

  static List<GlucoseEvent> _detectDawnWindows(List<GlucoseReading> readings) {
    final byDay = <DateTime, List<GlucoseReading>>{};
    for (final r in readings) {
      final day = DateTime(
        r.timestamp.year,
        r.timestamp.month,
        r.timestamp.day,
      );
      byDay.putIfAbsent(day, () => []).add(r);
    }

    final events = <GlucoseEvent>[];
    for (final rows in byDay.values) {
      final morning =
          rows
              .where((r) => r.timestamp.hour >= 4 && r.timestamp.hour < 8)
              .toList();
      if (morning.length < 4) continue;
      final lowPoint = morning.reduce((a, b) => a.value <= b.value ? a : b);
      final highPoint = morning.reduce((a, b) => a.value >= b.value ? a : b);
      final delta = highPoint.value - lowPoint.value;
      if (delta >= 1.0 && highPoint.timestamp.isAfter(lowPoint.timestamp)) {
        events.add(
          GlucoseEvent(
            type: GlucoseEventType.dawnPhenomenon,
            time: lowPoint.timestamp,
            value: lowPoint.value,
            endTime: highPoint.timestamp,
            peakOrNadir: highPoint.value,
            ratePerMin:
                delta /
                highPoint.timestamp.difference(lowPoint.timestamp).inMinutes,
            isNocturnal: true,
          ),
        );
      }
    }
    return events;
  }

  static List<GlucoseEvent> _deduplicate(List<GlucoseEvent> events) {
    final seen = <String>{};
    final result = <GlucoseEvent>[];
    for (final e in events) {
      final key = '${e.type.name}-${e.time.millisecondsSinceEpoch}';
      if (seen.add(key)) result.add(e);
    }
    return result;
  }

  static double _areaOutOfRange(
    List<GlucoseReading> segment,
    double threshold, {
    required bool above,
  }) {
    var area = 0.0;
    for (var i = 0; i < segment.length; i++) {
      final r = segment[i];
      final minutes =
          i == 0
              ? 5
              : r.timestamp.difference(segment[i - 1].timestamp).inMinutes;
      final delta = above ? r.value - threshold : threshold - r.value;
      area += delta.clamp(0, double.infinity) * minutes.clamp(1, 15);
    }
    return area;
  }

  static LowSeverity _severity(double nadir) {
    if (nadir < 2.8) return LowSeverity.severe;
    if (nadir < 3.0) return LowSeverity.significant;
    return LowSeverity.mild;
  }

  static bool _isNocturnal(DateTime time) => time.hour >= 0 && time.hour < 6;

  static double _mean(List<double> values) =>
      values.reduce((a, b) => a + b) / values.length;

  static double _cv(List<double> values) {
    final mean = _mean(values);
    if (mean <= 0) return 0;
    final variance =
        values.map((v) => (v - mean) * (v - mean)).reduce((a, b) => a + b) /
        values.length;
    return (_sqrt(variance) / mean) * 100;
  }

  static double _sqrt(double value) {
    if (value <= 0) return 0;
    var x = value;
    for (var i = 0; i < 20; i++) {
      x = (x + value / x) / 2;
    }
    return x;
  }
}
