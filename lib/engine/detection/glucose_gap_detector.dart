import '../../domain/entities/glucose_gap.dart';
import '../../domain/entities/glucose_reading.dart';

class GlucoseGapDetector {
  static List<GlucoseGap> detect(
    List<GlucoseReading> readings, {
    String source = 'unknown',
    int expectedIntervalMinutes = 5,
    int toleratedMissedReadings = 3,
  }) {
    if (readings.length < 2) return const [];
    final ordered = [...readings]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    final threshold = expectedIntervalMinutes * toleratedMissedReadings;
    final gaps = <GlucoseGap>[];

    for (var i = 1; i < ordered.length; i++) {
      final previous = ordered[i - 1];
      final current = ordered[i];
      final minutes =
          current.timestamp.difference(previous.timestamp).inMinutes;
      if (minutes <= threshold) continue;
      gaps.add(
        GlucoseGap(
          id:
              '${previous.timestamp.millisecondsSinceEpoch}_${current.timestamp.millisecondsSinceEpoch}',
          start: previous.timestamp,
          end: current.timestamp,
          durationMinutes: minutes,
          source: source,
        ),
      );
    }

    return gaps;
  }
}
