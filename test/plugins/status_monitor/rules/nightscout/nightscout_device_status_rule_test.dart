import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/rules/nightscout/nightscout_device_status_rule.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/analysis/status_analysis_context.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/evidence/nightscout_evidence.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_level.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/test_support/fake_status_rule_context_factory.dart';

void main() {
  test('device status is healthy when Nightscout returns rows', () async {
    final result = await const NightscoutDeviceStatusRule().evaluate(
      StatusAnalysisContext(
        now: DateTime.utc(2026, 6, 12),
        evidence: const FakeStatusRuleContextFactory()
            .build(
              nightscout: const NightscoutEvidence(
                configured: true,
                enabled: true,
                sourceLabel: 'Nightscout',
                deviceStatus: [
                  {'uploader': 'mock-uploader'},
                ],
              ),
            )
            .evidence,
      ),
    );

    expect(result.metric.id, 'device_status');
    expect(result.level, StatusLevel.healthy);
    expect(result.metric.valueLabel, '1 rows');
    expect(
      result.explanation.templateKey,
      'status.rule.nightscout.device_status.value.v1',
    );
    expect(result.explanation.facts['contextLabel'], 'mock-uploader');
  });

  test(
      'missing device status stays unknown and does not affect component level',
      () async {
    final result = await const NightscoutDeviceStatusRule().evaluate(
      StatusAnalysisContext(
        now: DateTime.utc(2026, 6, 12),
        evidence: const FakeStatusRuleContextFactory()
            .build(
              nightscout: const NightscoutEvidence(
                configured: true,
                enabled: true,
                sourceLabel: 'Nightscout',
              ),
            )
            .evidence,
      ),
    );

    expect(result.level, StatusLevel.unknown);
    expect(result.affectsComponentLevel, isFalse);
  });
}
