import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/analysis/status_data_quality.dart';
import '../../../domain/analysis/status_rule_id.dart';
import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/status_level.dart';
import '../../../domain/status_metric.dart';
import '../../../domain/status_metric_source.dart';
import '../../../domain/status_threshold.dart';
import '../../evidence/cgm_live_evidence_selector.dart';
import '../../text/status_rule_explanation_text_builder.dart';
import '../status_metric_rule.dart';

class CgmSensorFreshnessRule implements StatusMetricRule {
  final CgmLiveEvidenceSelector evidenceSelector;
  final StatusRuleExplanationTextBuilder textBuilder;

  const CgmSensorFreshnessRule({
    this.evidenceSelector = const CgmLiveEvidenceSelector(),
    this.textBuilder = const StatusRuleExplanationTextBuilder(),
  });

  @override
  Future<StatusRuleResult> evaluate(StatusAnalysisContext context) async {
    const ruleId = StatusRuleId('cgm.sensor_freshness');
    final evidence = evidenceSelector.readings(context);
    if (evidence.readings.isEmpty) {
      final metric = StatusMetric.unknown(
        id: 'sensor_freshness',
        label: 'Sensor data freshness',
        source: StatusMetricSource.entries,
        reason: evidence.failureLabel ?? 'No recent sensor readings',
      );
      return StatusRuleResult(
        ruleId: ruleId,
        metric: metric,
        level: StatusLevel.unknown,
        dataQuality: StatusDataQuality.insufficientData,
        explanation: textBuilder.build(
          'status.rule.cgm.freshness.unavailable.v1',
          const {},
        ),
        affectsComponentLevel: false,
      );
    }
    final latest = evidence.readings.last;
    final age = context.now.difference(latest.timestamp);
    final level = age < const Duration(minutes: 7)
        ? StatusLevel.healthy
        : age <= const Duration(minutes: 15)
            ? StatusLevel.watch
            : StatusLevel.issue;
    final metric = StatusMetric(
      id: 'sensor_freshness',
      label: 'Sensor data freshness',
      valueLabel: '${age.inMinutes}m',
      level: level,
      source: StatusMetricSource.entries,
      observedAt: latest.timestamp,
      note: evidence.sourceLabel,
      threshold: const StatusThreshold(
        healthyLabel: '<7m',
        watchLabel: '7-15m',
        issueLabel: '>15m',
      ),
    );
    return StatusRuleResult(
      ruleId: ruleId,
      metric: metric,
      level: level,
      dataQuality: StatusDataQuality.normal,
      explanation: textBuilder.build(
        'status.rule.cgm.freshness.value.v1',
        {'age': metric.valueLabel},
      ),
    );
  }
}
