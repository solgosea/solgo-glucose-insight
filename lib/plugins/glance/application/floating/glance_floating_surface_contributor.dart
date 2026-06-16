import 'package:smart_xdrip/application/floating_surface/floating_surface_segment.dart';
import 'package:smart_xdrip/application/floating_surface/floating_surface_segment_kind.dart';

import '../../domain/glance_range_state.dart';
import '../../domain/glance_snapshot.dart';

class GlanceFloatingSurfaceContributor {
  static const segmentId = 'glance';

  const GlanceFloatingSurfaceContributor();

  FloatingSurfaceSegment build(GlanceSnapshot snapshot) {
    final hasCurrentReading =
        snapshot.hasReading && !snapshot.freshness.isStale;
    final primaryText = hasCurrentReading
        ? '${snapshot.valueLabel} ${snapshot.unitLabel}'
        : snapshot.freshness.isStale
            ? 'Glucose stale'
            : 'Glucose offline';
    final secondaryParts = <String>[
      if (hasCurrentReading) snapshot.trendArrow,
      if (hasCurrentReading && snapshot.deltaLabel.isNotEmpty)
        snapshot.deltaLabel,
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
        'rangeState': snapshot.rangeState.code,
        'hasReading': snapshot.hasReading,
        'isStale': snapshot.freshness.isStale,
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
