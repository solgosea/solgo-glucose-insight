import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/floating/status_floating_surface_contributor.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/component_health.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/scoring/status_component_score.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_component_kind.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_level.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_report.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_source_capabilities.dart';

void main() {
  test('maps component health into a shared floating status segment', () {
    final segment = const StatusFloatingSurfaceContributor().build(_report());

    expect(segment.id, 'status_monitor');
    expect(segment.order, 20);
    expect(segment.primaryText, contains('Sensor'));
    expect(segment.primaryText, contains('92'));
    expect(segment.primaryText, contains('xDrip+'));
    expect(segment.primaryText, contains('91'));
    expect(segment.primaryText, contains('Nightscout'));
    expect(segment.primaryText, contains('100'));
    expect(segment.primaryText, contains('AAPS'));
    expect(segment.primaryText, contains('88'));
    expect(segment.level, 'healthy');
  });
}

StatusReport _report() {
  final now = DateTime(2026, 1, 1, 12);
  return StatusReport(
    subjectId: 'self',
    sourceKind: 'nightscout',
    sourceLabel: 'Nightscout',
    generatedAt: now,
    hasConfiguredSource: true,
    summary: const StatusSummary(
      level: StatusLevel.healthy,
      headline: 'All links are healthy',
      body: 'Status summary',
      meta: '4 components',
      healthyCount: 4,
      totalCount: 4,
    ),
    components: [
      _component(StatusComponentKind.cgmSensor),
      _component(StatusComponentKind.xdrip),
      _component(StatusComponentKind.nightscout),
      _component(StatusComponentKind.aapsLoop),
    ],
    recentEvents: const [],
    capabilities: const StatusSourceCapabilities.nightscout(),
  );
}

ComponentHealth _component(StatusComponentKind kind) {
  return ComponentHealth(
    kind: kind,
    level: StatusLevel.healthy,
    title: kind.title,
    role: kind.role,
    takeaway: '${kind.title} Healthy',
    summary: '${kind.title} status',
    metrics: const [],
    score: StatusComponentScore(
      value: switch (kind) {
        StatusComponentKind.cgmSensor => 92,
        StatusComponentKind.xdrip => 91,
        StatusComponentKind.nightscout => 100,
        StatusComponentKind.aapsLoop => 88,
      },
      label: 'Healthy',
      confidence: 1,
      availableSignals: 3,
      totalSignals: 3,
    ),
  );
}
