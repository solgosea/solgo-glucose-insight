import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/engines/cgm_sensor/cgm_sensor_status_engine.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/engines/xdrip/xdrip_status_engine.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/analysis/status_analysis_context.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_level.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/test_support/fake_status_rule_context_factory.dart';

void main() {
  test('xDrip freshness marks stale readings as issue', () async {
    final now = DateTime(2026, 1, 1, 12);
    final component = await const XdripStatusEngine().evaluate(
      StatusAnalysisContext(
        now: now,
        evidence: const FakeStatusRuleContextFactory().build(
          now: now,
          xdripReadings: [
            GlucoseReading(
              timestamp: now.subtract(const Duration(minutes: 18)),
              value: 7.0,
            ),
          ],
        ).evidence,
      ),
    );

    final freshness = component.metrics.firstWhere(
      (metric) => metric.id == 'freshness',
    );
    expect(component.level, StatusLevel.issue);
    expect(freshness.valueLabel, '18m');
  });

  test('CGM unavailable sensor lifetime remains unknown, not issue', () async {
    final now = DateTime(2026, 1, 1, 12);
    final readings = List.generate(
      24,
      (index) => GlucoseReading(
        timestamp: now.subtract(Duration(minutes: (24 - index) * 5)),
        value: 7.0 + index * .01,
      ),
    );

    final component = await const CgmSensorStatusEngine().evaluate(
      StatusAnalysisContext(
        now: now,
        evidence: const FakeStatusRuleContextFactory()
            .build(now: now, cgmHistoryReadings: readings)
            .evidence,
      ),
    );

    final lifetime = component.metrics.firstWhere(
      (metric) => metric.id == 'sensor_lifetime',
    );
    expect(lifetime.level, StatusLevel.unknown);
    expect(lifetime.available, isFalse);
  });
}
