import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/engine/detection/glucose_gap_detector.dart';

void main() {
  test('detects gaps when CGM samples are missing for too long', () {
    final start = DateTime(2026, 6, 3, 8);
    final readings = [
      GlucoseReading(timestamp: start, value: 6.0),
      GlucoseReading(
        timestamp: start.add(const Duration(minutes: 5)),
        value: 6.1,
      ),
      GlucoseReading(
        timestamp: start.add(const Duration(minutes: 35)),
        value: 6.2,
      ),
    ];

    final gaps = GlucoseGapDetector.detect(readings, source: 'xdripHttp');

    expect(gaps, hasLength(1));
    expect(gaps.first.durationMinutes, 30);
    expect(gaps.first.source, 'xdripHttp');
  });
}
