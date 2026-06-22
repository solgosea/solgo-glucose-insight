import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/plugins/glance/application/floating/glance_floating_surface_contributor.dart';
import 'package:smart_xdrip/plugins/glance/domain/floating/floating_glance_form_factor.dart';
import 'package:smart_xdrip/plugins/glance/domain/floating/floating_glance_preset_source.dart';
import 'package:smart_xdrip/plugins/glance/domain/floating/floating_glance_settings.dart';
import 'package:smart_xdrip/plugins/glance/domain/floating/floating_glance_size_preset.dart';
import 'package:smart_xdrip/plugins/glance/domain/glance_freshness.dart';
import 'package:smart_xdrip/plugins/glance/domain/glance_range_state.dart';
import 'package:smart_xdrip/plugins/glance/domain/glance_snapshot.dart';
import 'package:smart_xdrip/plugins/glance/domain/glance_tir_summary.dart';

void main() {
  test('maps a fresh glucose snapshot to the shared floating segment', () {
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
        trendArrow: 'up',
        sourceLabel: 'Nightscout',
        freshness: GlanceFreshness.evaluate(updatedAt: now, now: now),
        rangeState: GlanceRangeState.inRange,
        targetLowMmol: 3.9,
        targetHighMmol: 10,
        tir24h: const GlanceTirSummary(tirPercent: 78, readingCount: 12),
      ),
      settings: const FloatingGlanceSettings(
        sizePreset: FloatingGlanceSizePreset.large,
        formFactor: FloatingGlanceFormFactor.card,
        presetSource: FloatingGlancePresetSource.user,
      ),
    );

    expect(segment.id, 'glance');
    expect(segment.order, 10);
    expect(segment.primaryText, '7.2 mmol/L');
    expect(segment.secondaryText, 'TIR 78%');
    expect(segment.level, 'healthy');
    expect(segment.data['sizePreset'], 'large');
    expect(segment.data['formFactor'], 'card');
    expect(segment.data['presetSource'], 'user');
  });
}
