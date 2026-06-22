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

class NightscoutResponseTimeRule implements StatusMetricRule {
  final StatusThresholdProvider thresholds;
  final NightscoutEvidenceSelector evidenceSelector;
  final StatusRuleExplanationTextBuilder textBuilder;

  const NightscoutResponseTimeRule({
    this.thresholds = const StatusThresholdProvider(),
    this.evidenceSelector = const NightscoutEvidenceSelector(),
    this.textBuilder = const StatusRuleExplanationTextBuilder(),
  });

  @override
  Future<StatusRuleResult> evaluate(StatusAnalysisContext context) async {
    const ruleId = StatusRuleId('nightscout.response_time');
    final status = evidenceSelector.nightscout(context).status;
    if (status == null) {
      const metric = StatusMetric.unknown(
        id: 'response_time',
        label: 'Response time',
        source: StatusMetricSource.localProbe,
        reason: 'Nightscout status is not available',
      );
      return StatusRuleResult(
        ruleId: ruleId,
        metric: metric,
        level: StatusLevel.unknown,
        dataQuality: StatusDataQuality.unavailable,
        explanation: textBuilder.build(
          'status.rule.nightscout.response.unavailable.v1',
          const {},
        ),
        affectsComponentLevel: false,
      );
    }

    final result = thresholds.responseTime(status.elapsed);
    final metric = StatusMetric(
      id: 'response_time',
      label: 'Response time',
      valueLabel: status.elapsed.inSeconds >= 1
          ? '${status.elapsed.inSeconds}s'
          : '${status.elapsed.inMilliseconds}ms',
      level: result.level,
      source: StatusMetricSource.localProbe,
      threshold: result.threshold,
    );
    return StatusRuleResult(
      ruleId: ruleId,
      metric: metric,
      level: result.level,
      dataQuality: StatusDataQuality.normal,
      explanation: textBuilder.build(
        'status.rule.nightscout.response.value.v1',
        {'responseTime': metric.valueLabel},
      ),
    );
  }
}
