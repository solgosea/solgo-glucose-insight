import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/component_health.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_component_kind.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_level.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_metric.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_metric_source.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/presentation/xdrip/widgets/xdrip_signal_grid.dart';

void main() {
  testWidgets('xDrip detail renders four data link dashboards', (tester) async {
    const component = ComponentHealth(
      kind: StatusComponentKind.xdrip,
      level: StatusLevel.healthy,
      title: 'xDrip+',
      role: 'Collector',
      takeaway: 'Readings are arriving on time.',
      summary: 'fresh 2m - completeness 98%',
      metrics: [
        StatusMetric(
          id: 'freshness',
          label: 'Freshness',
          valueLabel: '2m',
          level: StatusLevel.healthy,
          source: StatusMetricSource.entries,
        ),
        StatusMetric(
          id: 'completeness_24h',
          label: '24h completeness',
          valueLabel: '98%',
          level: StatusLevel.healthy,
          source: StatusMetricSource.entries,
        ),
        StatusMetric(
          id: 'upload_latency_p95',
          label: 'Upload latency',
          valueLabel: '4s',
          level: StatusLevel.healthy,
          source: StatusMetricSource.deviceStatus,
        ),
        StatusMetric(
          id: 'uploader_battery',
          label: 'Uploader battery',
          valueLabel: '74%',
          level: StatusLevel.healthy,
          source: StatusMetricSource.deviceStatus,
        ),
      ],
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: XdripSignalGrid(component: component),
          ),
        ),
      ),
    );

    expect(find.text('Fresh'), findsOneWidget);
    expect(find.text('24h completeness'), findsOneWidget);
    expect(find.text('Upload latency'), findsOneWidget);
    expect(find.text('Uploader battery'), findsOneWidget);
  });
}
