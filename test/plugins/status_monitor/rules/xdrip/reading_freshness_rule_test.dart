import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/rules/xdrip/reading_freshness_rule.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/analysis/status_analysis_context.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/analysis/status_data_quality.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_level.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/test_support/fake_status_rule_context_factory.dart';

void main() {
  test('future timestamp becomes data-quality watch instead of stale issue',
      () async {
    final now = DateTime.utc(2026, 6, 12, 5, 30);
    final result = await const ReadingFreshnessRule().evaluate(
      StatusAnalysisContext(
        now: now,
        evidence: FakeStatusRuleContextFactory().build(
          now: now,
          xdripReadings: [
            GlucoseReading(
              value: 7.4,
              timestamp: now.add(const Duration(hours: 2)),
            ),
          ],
        ).evidence,
      ),
    );

    expect(result.level, StatusLevel.watch);
    expect(result.dataQuality, StatusDataQuality.futureTimestamp);
    expect(result.metric.valueLabel, '120 min ahead');
    expect(result.explanation.summary, contains('ahead'));
    expect(
      result.explanation.templateKey,
      'status.rule.xdrip.freshness.future_timestamp.v1',
    );
    expect(result.explanation.facts['minutes'], 120);
  });
}
