import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/engines/xdrip/xdrip_status_engine.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/analysis/status_analysis_context.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/evidence/nightscout_evidence.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_level.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/test_support/fake_status_rule_context_factory.dart';

void main() {
  test('explains xDrip status from rule results', () async {
    final now = DateTime.utc(2026, 6, 12, 5, 30);
    final readings = List.generate(
      288,
      (index) => GlucoseReading(
        value: 7.0,
        timestamp: now
            .subtract(const Duration(hours: 24))
            .add(Duration(minutes: index * 5)),
      ),
    );

    final component = await const XdripStatusEngine().evaluate(
      StatusAnalysisContext(
        now: now,
        evidence: const FakeStatusRuleContextFactory()
            .build(
              nightscoutReadings: readings,
              nightscout: NightscoutEvidence(
                configured: true,
                enabled: true,
                sourceLabel: 'Nightscout',
                deviceStatus: [
                  {
                    'uploader': {'battery': 82},
                  },
                ],
                readings: readings,
              ),
            )
            .evidence,
      ),
    );

    expect(component.level, StatusLevel.watch);
    expect(component.score?.value, 55);
    expect(component.score?.label, 'Nightscout reading fallback');
    expect(component.score?.availabilityLabel, '3 of 5 checks passed');
    expect(component.metrics.map((metric) => metric.id), contains('freshness'));
    expect(component.metrics.map((metric) => metric.id),
        contains('completeness_24h'));
    expect(component.metrics.map((metric) => metric.id),
        contains('uploader_battery'));
    expect(component.detailData, isNotNull);
  });
}
