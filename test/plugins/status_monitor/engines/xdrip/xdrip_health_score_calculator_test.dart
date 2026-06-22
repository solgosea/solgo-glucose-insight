import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/engines/xdrip/xdrip_health_score_calculator.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/analysis/status_data_quality.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/analysis/status_rule_explanation.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/analysis/status_rule_id.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/analysis/status_rule_result.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_level.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_metric.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_metric_source.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/xdrip/xdrip_pipeline_gate_result.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/xdrip/xdrip_reading_source_state.dart';

void main() {
  test('uses a fixed xDrip pipeline denominator instead of available-only', () {
    const calculator = XdripHealthScoreCalculator();

    final score = calculator.calculate([
      _result('xdrip.reading_freshness', StatusLevel.healthy),
      _result('xdrip.completeness_24h', StatusLevel.watch),
      _result(
        'xdrip.upload_latency_p95',
        StatusLevel.unknown,
        available: false,
      ),
      _result('xdrip.uploader_battery', StatusLevel.unknown, available: false),
    ]);

    expect(score.value, 46);
    expect(score.label, 'Weak data link');
    expect(score.availableSignals, 2);
    expect(score.totalSignals, 3);
    expect(score.confidence, closeTo(.55, .001));
  });

  test('caps score when local service is reachable but readings are missing',
      () {
    const calculator = XdripHealthScoreCalculator();

    final result = calculator.calculateWithBreakdown(
      [
        _result('xdrip.local_service', StatusLevel.healthy),
        _result(
          'xdrip.reading_freshness',
          StatusLevel.unknown,
          available: false,
        ),
        _result(
          'xdrip.completeness_24h',
          StatusLevel.unknown,
          available: false,
        ),
      ],
      gate: const XdripPipelineGateResult(
        hasLocalService: true,
        hasLiveReadings: false,
        readingSourceState: XdripReadingSourceState.none,
        maxScore: 45,
        message:
            'xDrip+ Local is reachable, but no live glucose readings are visible.',
      ),
      readingSourceLabel: 'No live readings',
    );

    expect(result.score.value, 25);
    expect(result.score.label, 'Service reachable, no readings');
    expect(result.breakdown.rawScore, 25);
    expect(result.breakdown.finalScore, 25);
    expect(result.score.confidence, closeTo(.25, .001));
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
