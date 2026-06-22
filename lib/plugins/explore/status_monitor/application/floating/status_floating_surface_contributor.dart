import 'package:smart_xdrip/application/floating_surface/floating_surface_segment.dart';
import 'package:smart_xdrip/application/floating_surface/floating_surface_segment_kind.dart';

import '../../domain/status_level.dart';
import '../../domain/status_report.dart';
import 'status_floating_payload_builder.dart';

class StatusFloatingSurfaceContributor {
  static const segmentId = 'status_monitor';

  final StatusFloatingPayloadBuilder payloadBuilder;

  const StatusFloatingSurfaceContributor({
    this.payloadBuilder = const StatusFloatingPayloadBuilder(),
  });

  FloatingSurfaceSegment build(StatusReport report) {
    final payload = payloadBuilder.build(report: report);
    final componentText = payload.components
        .map(
          (component) =>
              '${component.glyph} ${component.label} ${component.scoreLabel}',
        )
        .join('   ');
    return FloatingSurfaceSegment(
      id: segmentId,
      kind: FloatingSurfaceSegmentKind.status,
      order: 20,
      primaryText: componentText,
      metaText: payload.isStale
          ? 'stale'
          : payload.hasConfiguredSource
              ? payload.freshnessLabel
              : 'offline',
      level: _aggregateLevel(
          payload.components.map((component) => component.level)),
      data: {
        'headline': payload.headline,
        'freshnessLabel': payload.freshnessLabel,
        'hasConfiguredSource': payload.hasConfiguredSource,
        'isStale': payload.isStale,
        'components': payload.components
            .map(
              (component) => {
                'label': component.label,
                'level': component.level.name,
                'glyph': component.glyph,
                'score': component.score,
                'scoreLabel': component.scoreLabel,
              },
            )
            .toList(),
      },
    );
  }

  String _aggregateLevel(Iterable<StatusLevel> levels) {
    final names = levels.map((level) => level.name).toList();
    if (names.contains('issue')) return 'issue';
    if (names.contains('watch')) return 'watch';
    if (names.contains('healthy')) return 'healthy';
    return 'unknown';
  }
}
