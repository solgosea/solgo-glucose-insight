import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/i18n/status_monitor_l10n_resolver.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/freshness/status_component_freshness_resolver.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/component_health.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_component_kind.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_level.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_metric.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_metric_source.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_report.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_source_capabilities.dart';

void main() {
  test('uses latest metric observation for component freshness', () {
    final now = DateTime(2026, 6, 12, 12);
    final component = _component([
      _metric(observedAt: now.subtract(const Duration(minutes: 5))),
      _metric(observedAt: now.subtract(const Duration(minutes: 2))),
    ]);
    final report = _report(now: now, component: component);

    final freshness = const StatusComponentFreshnessResolver().resolve(
      report: report,
      component: component,
    );

    expect(freshness.observedAt, now.subtract(const Duration(minutes: 2)));
    expect(freshness.label, '2m');
  });

  test('falls back to report generation time when metrics have no timestamp',
      () {
    final now = DateTime(2026, 6, 12, 12);
    final component = _component([_metric()]);
    final report = _report(now: now, component: component);

    final freshness = const StatusComponentFreshnessResolver().resolve(
      report: report,
      component: component,
    );

    expect(freshness.observedAt, now);
    expect(freshness.label, '0s');
  });

  test('uses localized freshness label when l10n is provided', () {
    final now = DateTime(2026, 6, 12, 12);
    final component = _component([
      _metric(observedAt: now.subtract(const Duration(minutes: 2))),
    ]);
    final report = _report(now: now, component: component);

    final freshness = const StatusComponentFreshnessResolver().resolve(
      report: report,
      component: component,
      l10n: StatusMonitorL10nResolver.resolve(const Locale('zh')),
    );

    expect(freshness.label, contains('2'));
    expect(freshness.label, contains('更新'));
  });
}

ComponentHealth _component(List<StatusMetric> metrics) {
  return ComponentHealth(
    kind: StatusComponentKind.nightscout,
    level: StatusLevel.healthy,
    title: 'Nightscout',
    role: 'SERVER',
    takeaway: 'Reachable',
    summary: 'API is responding.',
    metrics: metrics,
  );
}

StatusMetric _metric({DateTime? observedAt}) {
  return StatusMetric(
    id: 'api',
    label: 'API',
    valueLabel: 'OK',
    level: StatusLevel.healthy,
    source: StatusMetricSource.nightscoutStatus,
    observedAt: observedAt,
  );
}

StatusReport _report({
  required DateTime now,
  required ComponentHealth component,
}) {
  return StatusReport(
    subjectId: 'self',
    sourceKind: 'nightscout',
    sourceLabel: 'Nightscout',
    generatedAt: now,
    summary: const StatusSummary(
      level: StatusLevel.healthy,
      headline: 'Status looks healthy.',
      body: 'All available checks are healthy.',
      meta: '3 checks',
      healthyCount: 1,
      totalCount: 1,
    ),
    components: [component],
    recentEvents: const [],
    capabilities: const StatusSourceCapabilities.nightscout(),
    hasConfiguredSource: true,
  );
}
