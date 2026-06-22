import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/engines/nightscout/nightscout_status_engine.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/detail/status_endpoint_probe.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/detail/status_response_snapshot.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/analysis/status_analysis_context.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/evidence/nightscout_evidence.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_level.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/test_support/fake_status_rule_context_factory.dart';

void main() {
  test('explains Nightscout status from cloud service signals', () async {
    final now = DateTime.utc(2026, 6, 12, 5, 30);
    final readings = List.generate(
      12,
      (index) => GlucoseReading(
        value: 7,
        timestamp: now.subtract(Duration(minutes: (11 - index) * 5)),
      ),
    );

    final component = await const NightscoutStatusEngine().evaluate(
      StatusAnalysisContext(
        now: now,
        evidence: FakeStatusRuleContextFactory()
            .build(
              now: now,
              nightscout: NightscoutEvidence(
                configured: true,
                enabled: true,
                sourceLabel: 'Nightscout',
                status: StatusResponseSnapshot(
                  reachable: true,
                  statusCode: 200,
                  elapsed: Duration(milliseconds: 240),
                ),
                deviceStatus: [
                  {'uploader': 'mock-uploader'},
                ],
                readings: readings,
                endpointProbes: [
                  StatusEndpointProbe(
                    endpoint: '/api/v1/entries/sgv.json',
                    label: 'entries',
                    level: StatusLevel.healthy,
                    reachable: true,
                    elapsed: const Duration(milliseconds: 120),
                    checkedAt: now,
                    statusCode: 200,
                  ),
                ],
              ),
            )
            .evidence,
      ),
    );

    expect(component.level, StatusLevel.healthy);
    expect(component.score?.label, 'Cloud link healthy');
    expect(component.metrics.map((metric) => metric.id),
        contains('api_reachable'));
    expect(component.metrics.map((metric) => metric.id),
        contains('response_time'));
    expect(component.metrics.map((metric) => metric.id),
        contains('device_status'));
    expect(component.metrics.map((metric) => metric.id),
        contains('entries_endpoint'));
    expect(component.metrics.map((metric) => metric.id),
        contains('server_data_freshness'));
    expect(component.metrics.length, 5);
    expect(component.detailData, isNotNull);
  });
}
