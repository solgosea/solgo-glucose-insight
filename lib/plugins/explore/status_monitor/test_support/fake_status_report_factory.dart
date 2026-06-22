import 'package:smart_xdrip/plugins/explore/status_monitor/domain/component_health.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_component_kind.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_level.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_metric.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_metric_source.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_report.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_source_capabilities.dart';

class FakeStatusReportFactory {
  const FakeStatusReportFactory();

  StatusReport healthy({DateTime? now}) {
    final at = now ?? DateTime(2026, 1, 1, 12);
    final components = StatusComponentKind.values
        .map(
          (kind) => ComponentHealth(
            kind: kind,
            level: StatusLevel.healthy,
            title: kind.title,
            role: kind.role,
            takeaway: 'Available metrics are healthy.',
            summary: 'All visible metrics are inside range',
            metrics: [
              StatusMetric(
                id: 'metric',
                label: 'Metric',
                valueLabel: 'OK',
                level: StatusLevel.healthy,
                source: StatusMetricSource.entries,
                observedAt: at,
              ),
            ],
          ),
        )
        .toList(growable: false);
    final componentCount = components.length;
    return StatusReport(
      subjectId: 'self',
      sourceTargetId: 'self:nightscout',
      sourceKind: 'nightscout',
      sourceLabel: 'Self Nightscout',
      generatedAt: at,
      summary: StatusSummary(
        level: StatusLevel.healthy,
        headline: 'Your glucose link is healthy.',
        body: 'All visible components are inside their healthy ranges.',
        meta: 'Nightscout full mode',
        healthyCount: componentCount,
        totalCount: componentCount,
      ),
      components: components,
      recentEvents: const [],
      capabilities: const StatusSourceCapabilities.nightscout(),
      hasConfiguredSource: true,
    );
  }
}
