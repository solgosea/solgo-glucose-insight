import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/component_health.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_component_kind.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_level.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_metric.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_metric_source.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/presentation/nightscout/widgets/nightscout_signal_grid.dart';

void main() {
  testWidgets('Nightscout detail renders three cloud service dashboards',
      (tester) async {
    const component = ComponentHealth(
      kind: StatusComponentKind.nightscout,
      level: StatusLevel.healthy,
      title: 'Nightscout',
      role: 'Cloud server',
      takeaway: 'Cloud link healthy',
      summary: 'status 200 OK',
      metrics: [
        StatusMetric(
          id: 'api_reachable',
          label: 'API reachable',
          valueLabel: '200 OK',
          level: StatusLevel.healthy,
          source: StatusMetricSource.nightscoutStatus,
        ),
        StatusMetric(
          id: 'response_time',
          label: 'Response time',
          valueLabel: '240ms',
          level: StatusLevel.healthy,
          source: StatusMetricSource.localProbe,
        ),
        StatusMetric(
          id: 'device_status',
          label: 'Device status',
          valueLabel: '3 rows',
          level: StatusLevel.healthy,
          source: StatusMetricSource.deviceStatus,
        ),
      ],
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: NightscoutSignalGrid(component: component),
          ),
        ),
      ),
    );

    expect(find.text('Reachability'), findsOneWidget);
    expect(find.text('Response Time'), findsOneWidget);
    expect(find.text('Device Status'), findsOneWidget);
  });
}
