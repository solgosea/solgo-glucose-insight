import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/data/mock/mock_glucose_generator.dart';
import 'package:smart_xdrip/domain/entities/glucose_event.dart';
import 'package:smart_xdrip/engine/detection/episode_detector.dart';
import 'package:smart_xdrip/engine/detection/glucose_gap_detector.dart';

void main() {
  test('mock dataset covers analysis and debugging scenarios', () {
    final anchor = DateTime(2026, 6, 4, 12);
    final readings = MockGlucoseGenerator.generate90Days(anchor: anchor);

    expect(readings.length, greaterThan(24000));
    expect(readings.first.timestamp.isBefore(anchor), isTrue);
    expect(
      readings.last.timestamp.isAfter(
        anchor.subtract(const Duration(hours: 1)),
      ),
      isTrue,
    );

    final last14 =
        readings
            .where(
              (r) => r.timestamp.isAfter(
                anchor.subtract(const Duration(days: 14)),
              ),
            )
            .toList();
    final events = EpisodeDetector.detect(last14);
    final gaps = GlucoseGapDetector.detect(last14, source: 'mock');

    expect(
      events.where((e) => e.type == GlucoseEventType.highEpisode),
      isNotEmpty,
    );
    expect(
      events.where((e) => e.type == GlucoseEventType.lowEpisode),
      isNotEmpty,
    );
    expect(events.where((e) => e.type == GlucoseEventType.rise), isNotEmpty);
    expect(
      events.where((e) => e.type == GlucoseEventType.stableWindow),
      isNotEmpty,
    );
    expect(gaps, isNotEmpty);
  });

  test('mock current day includes history callout episodes', () {
    final anchor = DateTime(2026, 6, 4, 12);
    final readings = MockGlucoseGenerator.generate90Days(anchor: anchor);
    final today = MockGlucoseGenerator.forDay(readings, anchor);
    final events = EpisodeDetector.detect(today);

    expect(
      events.where((e) => e.type == GlucoseEventType.lowEpisode),
      isNotEmpty,
    );
    expect(
      events.where((e) => e.type == GlucoseEventType.highEpisode),
      isNotEmpty,
    );
  });
}
