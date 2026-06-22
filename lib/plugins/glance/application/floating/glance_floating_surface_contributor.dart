import 'package:smart_xdrip/application/floating_surface/floating_surface_segment.dart';
import 'package:smart_xdrip/application/floating_surface/floating_surface_segment_kind.dart';

import '../../domain/glance_range_state.dart';
import '../../domain/glance_snapshot.dart';
import '../../domain/floating/floating_glance_settings.dart';

class GlanceFloatingSurfaceContributor {
  static const segmentId = 'glance';

  const GlanceFloatingSurfaceContributor();

  FloatingSurfaceSegment build(
    GlanceSnapshot snapshot, {
    FloatingGlanceSettings settings = const FloatingGlanceSettings(),
  }) {
    final hasCurrentReading =
        snapshot.hasReading && !snapshot.freshness.isStale;
    final primaryText = hasCurrentReading
        ? '${snapshot.valueLabel} ${snapshot.unitLabel}'
        : snapshot.freshness.isStale
            ? 'Glucose stale'
            : 'Glucose offline';
    final secondaryParts = <String>[
      if (hasCurrentReading) snapshot.tir24h.compactLabel,
    ];
    return FloatingSurfaceSegment(
      id: segmentId,
      kind: FloatingSurfaceSegmentKind.glucose,
      order: 10,
      primaryText: primaryText,
      secondaryText: secondaryParts.isEmpty ? null : secondaryParts.join(' '),
      metaText: snapshot.freshness.label,
      level: _level(snapshot),
      data: {
        'valueLabel': snapshot.valueLabel,
        'unitLabel': snapshot.unitLabel,
        'trendArrow': snapshot.trendArrow,
        'deltaLabel': snapshot.deltaLabel,
        'freshnessLabel': snapshot.freshness.label,
        'tir24hLabel': snapshot.tir24h.fullLabel,
        'tir24hCompactLabel': snapshot.tir24h.compactLabel,
        'tir24hPercent': snapshot.tir24h.tirPercent,
        'tir24hReadingCount': snapshot.tir24h.readingCount,
        'rangeState': snapshot.rangeState.code,
        'hasReading': snapshot.hasReading,
        'isStale': snapshot.freshness.isStale,
        'sourceLabel': snapshot.sourceLabel,
        'sizePreset': settings.sizePreset.code,
        'formFactor': settings.formFactor.code,
        'presetSource': settings.presetSource.code,
        'targetLowMmol': snapshot.targetLowMmol,
        'targetHighMmol': snapshot.targetHighMmol,
        'sparklinePoints': [
          for (final point in snapshot.sparklinePoints) point.toMap(),
        ],
      },
    );
  }

  String _level(GlanceSnapshot snapshot) {
    if (!snapshot.hasReading || snapshot.freshness.isStale) return 'unknown';
    return switch (snapshot.rangeState) {
      GlanceRangeState.inRange => 'healthy',
      GlanceRangeState.high => 'watch',
      GlanceRangeState.low => 'issue',
      GlanceRangeState.stale => 'unknown',
      GlanceRangeState.unknown => 'unknown',
    };
  }
}
