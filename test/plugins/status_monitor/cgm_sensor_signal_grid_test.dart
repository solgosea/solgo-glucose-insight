import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/component_health.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_component_kind.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_level.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_metric.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_metric_source.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/presentation/cgm_sensor/widgets/cgm_sensor_signal_grid.dart';

void main() {
  testWidgets('CGM sensor detail renders four signal dashboards',
      (tester) async {
    const component = ComponentHealth(
      kind: StatusComponentKind.cgmSensor,
      level: StatusLevel.healthy,
      title: 'CGM Sensor',
      role: 'Sensor',
      takeaway: 'Readings are stable.',
      summary: 'CV 32% - flat-line None',
      metrics: [
        StatusMetric(
          id: 'sensor_lifetime',
          label: 'Sensor lifetime',
          valueLabel: '8d',
          level: StatusLevel.healthy,
          source: StatusMetricSource.deviceStatus,
        ),
        StatusMetric(
          id: 'cgm_cv_24h',
          label: 'CV (24h)',
          valueLabel: '32%',
          level: StatusLevel.healthy,
          source: StatusMetricSource.entries,
        ),
        StatusMetric(
          id: 'sudden_changes_24h',
          label: 'Sudden changes (24h)',
          valueLabel: '2',
          level: StatusLevel.watch,
          source: StatusMetricSource.entries,
        ),
        StatusMetric(
          id: 'flat_line_periods',
          label: 'Flat-line periods',
          valueLabel: '34m',
          level: StatusLevel.watch,
          source: StatusMetricSource.entries,
        ),
      ],
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: CgmSensorSignalGrid(component: component),
          ),
        ),
      ),
    );

    expect(find.text('Sensor Session'), findsOneWidget);
    expect(find.text('Variability'), findsOneWidget);
    expect(find.text('Sudden Jumps'), findsOneWidget);
    expect(find.text('Flat Periods'), findsOneWidget);
  });
}
