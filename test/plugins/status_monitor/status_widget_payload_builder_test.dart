import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/widget/status_widget_snapshot_builder.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/component_health.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_component_kind.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_level.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_report.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_source_capabilities.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/widget/status_widget_settings.dart';

void main() {
  const builder = StatusWidgetSnapshotBuilder();

  test('maps healthy report to external status text', () {
    final now = DateTime(2026, 1, 1, 12);
    final snapshot = builder.build(
      report: _report(
        generatedAt: now.subtract(const Duration(minutes: 2)),
        level: StatusLevel.healthy,
      ),
      settings: StatusWidgetSettings.defaults('self'),
      now: now,
    );

    expect(snapshot.notificationText, 'All systems healthy - 2m');
    expect(snapshot.lockScreenText, 'All systems healthy - 2m');
    expect(snapshot.isStale, isFalse);
  });

  test('stale report never looks current', () {
    final now = DateTime(2026, 1, 1, 12);
    final snapshot = builder.build(
      report: _report(
        generatedAt: now.subtract(const Duration(minutes: 20)),
        level: StatusLevel.healthy,
      ),
      settings: StatusWidgetSettings.defaults('self'),
      now: now,
    );

    expect(snapshot.headline, 'No recent status');
    expect(snapshot.notificationText, 'No recent status');
    expect(snapshot.isStale, isTrue);
  });

  test('missing data source is explicit', () {
    final now = DateTime(2026, 1, 1, 12);
    final snapshot = builder.build(
      report: _report(
        generatedAt: now,
        level: StatusLevel.unknown,
        hasConfiguredSource: false,
      ),
      settings: StatusWidgetSettings.defaults('self'),
      now: now,
    );

    expect(snapshot.headline, 'Status unavailable');
    expect(snapshot.notificationText, 'Status unavailable');
    expect(snapshot.hasConfiguredSource, isFalse);
  });
}

StatusReport _report({
  required DateTime generatedAt,
  required StatusLevel level,
  bool hasConfiguredSource = true,
}) {
  return StatusReport(
    subjectId: 'self',
    sourceKind: 'nightscout',
    sourceLabel: 'Nightscout',
    generatedAt: generatedAt,
    hasConfiguredSource: hasConfiguredSource,
    summary: StatusSummary(
      level: level,
      headline: level == StatusLevel.healthy
          ? 'All links are healthy'
          : '${level.label} status',
      body: 'CGM, uploader, and Nightscout status summary.',
      meta: '3 components',
      healthyCount: level == StatusLevel.healthy ? 3 : 0,
      totalCount: 3,
    ),
    components: [
      _component(StatusComponentKind.cgmSensor, level),
      _component(StatusComponentKind.xdrip, StatusLevel.healthy),
      _component(StatusComponentKind.nightscout, StatusLevel.healthy),
    ],
    recentEvents: const [],
    capabilities: hasConfiguredSource
        ? const StatusSourceCapabilities.nightscout()
        : const StatusSourceCapabilities.none(),
  );
}

ComponentHealth _component(StatusComponentKind kind, StatusLevel level) {
  return ComponentHealth(
    kind: kind,
    level: level,
    title: kind.title,
    role: kind.role,
    takeaway: '${kind.title} ${level.label}',
    summary: '${kind.title} status',
    metrics: const [],
  );
}
