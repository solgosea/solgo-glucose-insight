import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/plugins/glance/application/glance_snapshot_builder.dart';
import 'package:smart_xdrip/plugins/glance/domain/glance_range_state.dart';

void main() {
  test('builds in-range snapshot with freshness and delta', () {
    final now = DateTime(2026, 6, 11, 12);
    final readings = [
      GlucoseReading(
        timestamp: now.subtract(const Duration(minutes: 6)),
        value: 7.1,
      ),
      GlucoseReading(
        timestamp: now.subtract(const Duration(minutes: 2)),
        value: 7.4,
      ),
    ];

    final snapshot = const GlanceSnapshotBuilder().build(
      subjectId: 'self',
      settings: const AppSettings(),
      latest: readings.last,
      trendReadings: readings,
      tirReadings24h: [
        ...readings,
        GlucoseReading(
          timestamp: now.subtract(const Duration(hours: 2)),
          value: 11,
        ),
      ],
      now: now,
    );

    expect(snapshot.valueLabel, '7.4');
    expect(snapshot.unitLabel, 'mmol/L');
    expect(snapshot.deltaLabel, '+0.3');
    expect(snapshot.freshness.label, '2m');
    expect(snapshot.rangeState, GlanceRangeState.inRange);
    expect(snapshot.tir24h.percentLabel, '67%');
    expect(snapshot.tir24h.compactLabel, 'TIR 67%');
    expect(snapshot.tir24h.fullLabel, 'TIR 24H 67%');
  });

  test('marks stale values as stale instead of current status', () {
    final now = DateTime(2026, 6, 11, 12);
    final latest = GlucoseReading(
      timestamp: now.subtract(const Duration(minutes: 30)),
      value: 13,
    );

    final snapshot = const GlanceSnapshotBuilder().build(
      subjectId: 'self',
      settings: const AppSettings(),
      latest: latest,
      trendReadings: [latest],
      now: now,
    );

    expect(snapshot.freshness.isStale, isTrue);
    expect(snapshot.rangeState, GlanceRangeState.stale);
  });
}
