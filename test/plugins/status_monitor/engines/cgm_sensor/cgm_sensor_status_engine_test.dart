import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/engines/cgm_sensor/cgm_sensor_status_engine.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/analysis/status_analysis_context.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/evidence/nightscout_evidence.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_level.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/test_support/fake_status_rule_context_factory.dart';

void main() {
  test('explains CGM status from rule results', () async {
    final now = DateTime.utc(2026, 6, 12, 5, 30);
    final readings = List.generate(
      288,
      (index) => GlucoseReading(
        value: 7.0 + (index.isEven ? .1 : -.1),
        timestamp: now
            .subtract(const Duration(hours: 24))
            .add(Duration(minutes: index * 5)),
      ),
    );

    final component = await const CgmSensorStatusEngine().evaluate(
      StatusAnalysisContext(
        now: now,
        evidence: FakeStatusRuleContextFactory()
            .build(
              now: now,
              cgmHistoryReadings: readings,
              nightscout: NightscoutEvidence(
                configured: true,
                enabled: true,
                sourceLabel: 'Nightscout',
                readings: readings,
                deviceStatus: [
                  {
                    'sensor': {
                      'sessionStart': now
                          .subtract(const Duration(days: 2))
                          .millisecondsSinceEpoch,
                    },
                  },
                ],
              ),
            )
            .evidence,
      ),
    );

    expect(component.level, StatusLevel.healthy);
    expect(component.score?.value, 100);
    expect(component.score?.label, 'Stable checks');
    expect(component.score?.availabilityLabel, '2 of 2 checks passed');
    expect(component.metrics.map((metric) => metric.id),
        contains('sensor_lifetime'));
    expect(
        component.metrics.map((metric) => metric.id), contains('cgm_cv_24h'));
    expect(component.metrics.map((metric) => metric.id),
        contains('flat_line_periods'));
    expect(component.detailData, isNotNull);
  });

  test('marks CGM sensor unknown when the selected source has no readings',
      () async {
    final now = DateTime.utc(2026, 6, 12, 5, 30);

    final component = await const CgmSensorStatusEngine().evaluate(
      StatusAnalysisContext(
        now: now,
        evidence: const FakeStatusRuleContextFactory().build().evidence,
      ),
    );

    expect(component.level, StatusLevel.unknown);
    expect(component.score?.availabilityLabel, '0 of 2 checks passed');
    expect(
      component.metrics
          .firstWhere((metric) => metric.id == 'sudden_changes_24h')
          .available,
      isFalse,
    );
    expect(
      component.metrics
          .firstWhere((metric) => metric.id == 'flat_line_periods')
          .available,
      isFalse,
    );
  });
}
