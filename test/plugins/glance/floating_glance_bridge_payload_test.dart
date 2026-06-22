import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/plugins/glance/application/floating/glance_floating_surface_contributor.dart';
import 'package:smart_xdrip/plugins/glance/domain/floating/floating_glance_sparkline_point.dart';
import 'package:smart_xdrip/plugins/glance/domain/glance_freshness.dart';
import 'package:smart_xdrip/plugins/glance/domain/glance_range_state.dart';
import 'package:smart_xdrip/plugins/glance/domain/glance_snapshot.dart';
import 'package:smart_xdrip/plugins/glance/domain/glance_tir_summary.dart';

void main() {
  test('floating glance segment includes expanded overlay payload', () {
    final now = DateTime(2026, 1, 1, 12);
    final segment = const GlanceFloatingSurfaceContributor().build(
      GlanceSnapshot(
        generatedAt: now,
        subjectId: 'self',
        latestReading: GlucoseReading(timestamp: now, value: 7.2),
        trendReadings: const [],
        unit: GlucoseUnit.mmolL,
        valueLabel: '7.2',
        alternateValueLabel: '130',
        unitLabel: 'mmol/L',
        deltaLabel: '+0.2',
        trendArrow: '\u2192',
        sourceLabel: 'Nightscout',
        freshness: GlanceFreshness.evaluate(updatedAt: now, now: now),
        rangeState: GlanceRangeState.inRange,
        targetLowMmol: 3.9,
        targetHighMmol: 10,
        tir24h: const GlanceTirSummary(tirPercent: 78, readingCount: 288),
        sparklinePoints: const [
          FloatingGlanceSparklinePoint(valueMmol: 7.0, minutesAgo: 10),
          FloatingGlanceSparklinePoint(valueMmol: 7.2, minutesAgo: 0),
        ],
      ),
    );

    expect(segment.id, 'glance');
    expect(segment.kind.code, 'glucose');
    expect(segment.primaryText, '7.2 mmol/L');
    expect(segment.secondaryText, 'TIR 78%');
    expect(segment.metaText, '0m');
    expect(segment.data['valueLabel'], '7.2');
    expect(segment.data['unitLabel'], 'mmol/L');
    expect(segment.data['deltaLabel'], '+0.2');
    expect(segment.data['sourceLabel'], 'Nightscout');
    expect(segment.data['tir24hPercent'], 78);
    expect(segment.data['tir24hReadingCount'], 288);
    expect(segment.data['targetLowMmol'], 3.9);
    expect(segment.data['targetHighMmol'], 10);
    expect(segment.data['sparklinePoints'], hasLength(2));
    expect(segment.data['sizePreset'], 'medium');
    expect(segment.data['formFactor'], 'pill');
    expect(segment.data['presetSource'], 'automatic');
  });
}
