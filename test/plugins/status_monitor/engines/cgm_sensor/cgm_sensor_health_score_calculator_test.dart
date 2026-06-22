import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/engines/cgm_sensor/cgm_sensor_health_score_calculator.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/analysis/status_data_quality.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/analysis/status_rule_explanation.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/analysis/status_rule_id.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/analysis/status_rule_result.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_level.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_metric.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_metric_source.dart';

void main() {
  test('scores CGM current state from live freshness and continuity', () {
    const calculator = CgmSensorHealthScoreCalculator();

    final score = calculator.calculate([
      _result('cgm.sensor_freshness', StatusLevel.healthy),
      _result('cgm.signal_continuity', StatusLevel.watch),
      _result('cgm.cv_24h', StatusLevel.healthy),
    ]);

    expect(score.value, 81);
    expect(score.label, 'Worth watching');
    expect(score.availableSignals, 2);
    expect(score.totalSignals, 2);
    expect(score.confidence, 1);
  });
}

StatusRuleResult _result(
  String ruleId,
  StatusLevel level, {
  bool available = true,
}) {
  return StatusRuleResult(
    ruleId: StatusRuleId(ruleId),
    metric: available
        ? StatusMetric(
            id: ruleId,
            label: ruleId,
            valueLabel: level.label,
            level: level,
            source: StatusMetricSource.entries,
          )
        : StatusMetric.unknown(
            id: ruleId,
            label: ruleId,
            source: StatusMetricSource.entries,
            reason: 'Unavailable',
          ),
    level: level,
    dataQuality:
        available ? StatusDataQuality.normal : StatusDataQuality.unavailable,
    explanation: const StatusRuleExplanation(
      summary: 'summary',
      detail: 'detail',
    ),
    affectsComponentLevel: available,
  );
}
