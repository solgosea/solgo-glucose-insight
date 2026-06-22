import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/analysis/status_data_quality.dart';
import '../../../domain/analysis/status_rule_id.dart';
import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/status_level.dart';
import '../../../domain/status_metric.dart';
import '../../../domain/status_metric_source.dart';
import '../../evidence/nightscout_evidence_selector.dart';
import '../../status_threshold_provider.dart';
import '../../text/status_rule_explanation_text_builder.dart';
import '../status_metric_rule.dart';

class NightscoutReachableRule implements StatusMetricRule {
  final StatusThresholdProvider thresholds;
  final NightscoutEvidenceSelector evidenceSelector;
  final StatusRuleExplanationTextBuilder textBuilder;

  const NightscoutReachableRule({
    this.thresholds = const StatusThresholdProvider(),
    this.evidenceSelector = const NightscoutEvidenceSelector(),
    this.textBuilder = const StatusRuleExplanationTextBuilder(),
  });

  @override
  Future<StatusRuleResult> evaluate(StatusAnalysisContext context) async {
    const ruleId = StatusRuleId('nightscout.api_reachable');
    final nightscout = evidenceSelector.nightscout(context);
    if (!nightscout.configured || !nightscout.enabled) {
      const metric = StatusMetric.unknown(
        id: 'api_reachable',
        label: 'API reachable',
        source: StatusMetricSource.nightscoutStatus,
        reason: 'Nightscout is not configured for this source',
      );
      return StatusRuleResult(
        ruleId: ruleId,
        metric: metric,
        level: StatusLevel.unknown,
        dataQuality: StatusDataQuality.unavailable,
        explanation: textBuilder.build(
          'status.rule.nightscout.reachable.not_configured.v1',
          const {},
        ),
        affectsComponentLevel: false,
      );
    }

    final status = nightscout.status;
    if (status == null) {
      const metric = StatusMetric.unknown(
        id: 'api_reachable',
        label: 'API reachable',
        source: StatusMetricSource.nightscoutStatus,
        reason: 'Status request has not completed',
      );
      return StatusRuleResult(
        ruleId: ruleId,
        metric: metric,
        level: StatusLevel.unknown,
        dataQuality: StatusDataQuality.unavailable,
        explanation: textBuilder.build(
          'status.rule.nightscout.reachable.pending.v1',
          const {},
        ),
        affectsComponentLevel: false,
      );
    }

    final result = thresholds.apiReachable(
      status.reachable,
      slow: status.elapsed.inSeconds > 3,
    );
    final metric = StatusMetric(
      id: 'api_reachable',
      label: 'API reachable',
      valueLabel: status.statusCode == null
          ? 'No response'
          : '${status.statusCode} ${status.reachable ? 'OK' : 'Error'}',
      level: result.level,
      source: StatusMetricSource.nightscoutStatus,
      threshold: result.threshold,
      note: status.errorLabel,
    );
    return StatusRuleResult(
      ruleId: ruleId,
      metric: metric,
      level: result.level,
      dataQuality: StatusDataQuality.normal,
      explanation: textBuilder.build(
        'status.rule.nightscout.reachable.value.v1',
        {'status': metric.valueLabel},
      ),
    );
  }
}
