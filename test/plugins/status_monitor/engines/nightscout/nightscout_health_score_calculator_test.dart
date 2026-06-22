import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/engines/nightscout/nightscout_health_score_calculator.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/analysis/status_data_quality.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/analysis/status_rule_explanation.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/analysis/status_rule_id.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/analysis/status_rule_result.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_level.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_metric.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_metric_source.dart';

void main() {
  test('weights reachability and response time as the main cloud signals', () {
    final score = const NightscoutHealthScoreCalculator().calculate([
      _result(
        'nightscout.api_reachable',
        'api_reachable',
        StatusLevel.healthy,
      ),
      _result(
        'nightscout.entries_endpoint',
        'entries_endpoint',
        StatusLevel.healthy,
      ),
      _result(
        'nightscout.server_data_freshness',
        'server_data_freshness',
        StatusLevel.healthy,
      ),
      _result(
        'nightscout.response_time',
        'response_time',
        StatusLevel.watch,
      ),
      _result(
        'nightscout.device_status',
        'device_status',
        StatusLevel.unknown,
        available: false,
        affects: false,
      ),
    ]);

    expect(score.availableSignals, 4);
    expect(score.totalSignals, 4);
    expect(score.confidence, closeTo(.95, .001));
    expect(score.value, 94);
    expect(score.label, 'Cloud link healthy');
  });
}

StatusRuleResult _result(
  String ruleId,
  String metricId,
  StatusLevel level, {
  bool available = true,
  bool affects = true,
}) {
  return StatusRuleResult(
    ruleId: StatusRuleId(ruleId),
    metric: available
        ? StatusMetric(
            id: metricId,
            label: metricId,
            valueLabel: 'ok',
            level: level,
            source: StatusMetricSource.nightscoutStatus,
          )
        : StatusMetric.unknown(
            id: metricId,
            label: metricId,
            source: StatusMetricSource.nightscoutStatus,
            reason: 'missing',
          ),
    level: level,
    dataQuality: StatusDataQuality.normal,
    explanation: const StatusRuleExplanation(summary: 'ok', detail: 'ok'),
    affectsComponentLevel: affects,
  );
}
