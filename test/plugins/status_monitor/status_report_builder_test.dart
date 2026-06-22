import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/status_report_builder.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_level.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/test_support/fake_status_rule_context_factory.dart';

void main() {
  test('no data source creates an unknown report with empty reason', () async {
    final report = await const StatusReportBuilder().build(
      now: DateTime(2026, 1, 1, 12),
      evidence: const FakeStatusRuleContextFactory().build().evidence,
      history: const [],
    );

    expect(report.hasConfiguredSource, isFalse);
    expect(report.summary.level, StatusLevel.unknown);
    expect(report.emptyReason, isNotNull);
  });
}
