import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/glucose_event.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/engine/detection/episode_detector.dart';

void main() {
  test('detects CGM-derived event types from readings only', () {
    final start = DateTime(2026, 6, 3);
    final values = <double>[
      5.8,
      5.9,
      6.0,
      6.1,
      7.0,
      8.5,
      10.4,
      10.8,
      11.2,
      11.0,
      10.7,
      10.5,
      8.8,
      7.1,
      5.8,
      5.9,
      5.9,
      6.0,
      6.0,
      5.9,
      5.9,
      6.0,
      6.0,
      5.9,
      3.6,
      3.5,
      4.2,
    ];
    final readings = List.generate(
      values.length,
      (i) => GlucoseReading(
        timestamp: start.add(Duration(minutes: i * 5)),
        value: values[i],
      ),
    );

    final events = EpisodeDetector.detect(
      readings,
      minHighReadings: 3,
      stableWindowReadings: 6,
      riseDelta: 1.5,
    );

    expect(
      events.map((e) => e.type),
      containsAll(<GlucoseEventType>[
        GlucoseEventType.firstReading,
        GlucoseEventType.rise,
        GlucoseEventType.highEpisode,
        GlucoseEventType.recovery,
        GlucoseEventType.stableWindow,
        GlucoseEventType.lowEpisode,
      ]),
    );
  });
}
