import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/analysis/status_data_quality.dart';
import '../../../domain/analysis/status_rule_id.dart';
import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/status_level.dart';
import '../../../domain/status_metric.dart';
import '../../../domain/status_metric_source.dart';
import '../../evidence/xdrip_evidence_selector.dart';
import '../../policies/sampling_cadence_policy.dart';
import '../../status_threshold_provider.dart';
import '../../text/status_rule_explanation_text_builder.dart';
import '../status_metric_rule.dart';

class Completeness24hRule implements StatusMetricRule {
  final StatusThresholdProvider thresholds;
  final SamplingCadencePolicy cadencePolicy;
  final XdripEvidenceSelector evidenceSelector;
  final StatusRuleExplanationTextBuilder textBuilder;

  const Completeness24hRule({
    this.thresholds = const StatusThresholdProvider(),
    this.cadencePolicy = const SamplingCadencePolicy(),
    this.evidenceSelector = const XdripEvidenceSelector(),
    this.textBuilder = const StatusRuleExplanationTextBuilder(),
  });

  @override
  Future<StatusRuleResult> evaluate(StatusAnalysisContext context) async {
    const ruleId = StatusRuleId('xdrip.completeness_24h');
    final evidence = evidenceSelector.readings(context);
    if (evidence.readings.isEmpty) {
      final metric = StatusMetric.unknown(
        id: 'completeness_24h',
        label: '24h completeness',
        source: StatusMetricSource.entries,
        reason: evidence.failureLabel ?? 'No readings available',
      );
      return StatusRuleResult(
        ruleId: ruleId,
        metric: metric,
        level: StatusLevel.unknown,
        dataQuality: StatusDataQuality.insufficientData,
        explanation: textBuilder.build(
          'status.rule.xdrip.completeness.value.v1',
          {
            'count': 0,
            'expectedReadings': cadencePolicy.expectedReadings,
            'cadenceMinutes': cadencePolicy.expectedCadence.inMinutes,
          },
        ),
        affectsComponentLevel: false,
      );
    }
    final count = evidence.readings.length;
    final ratio = cadencePolicy.completenessRatio(count);
    final result = thresholds.completeness(ratio);
    final metric = StatusMetric(
      id: 'completeness_24h',
      label: '24h completeness',
      valueLabel: '${(ratio * 100).toStringAsFixed(0)}%',
      level: result.level,
      source: StatusMetricSource.entries,
      observedAt:
          evidence.readings.isEmpty ? null : evidence.readings.last.timestamp,
      threshold: result.threshold,
      note:
          '$count/${cadencePolicy.expectedReadings} expected readings · ${evidence.sourceLabel}',
    );
    return StatusRuleResult(
      ruleId: ruleId,
      metric: metric,
      level: result.level,
      dataQuality: count == 0
          ? StatusDataQuality.insufficientData
          : StatusDataQuality.normal,
      explanation: textBuilder.build(
        'status.rule.xdrip.completeness.value.v1',
        {
          'count': count,
          'expectedReadings': cadencePolicy.expectedReadings,
          'cadenceMinutes': cadencePolicy.expectedCadence.inMinutes,
        },
      ),
    );
  }
}
