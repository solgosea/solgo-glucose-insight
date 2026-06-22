import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/analysis/status_data_quality.dart';
import '../../../domain/analysis/status_rule_id.dart';
import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/status_level.dart';
import '../../../domain/status_metric.dart';
import '../../../domain/status_metric_source.dart';
import '../../../domain/status_threshold.dart';
import '../../evidence/xdrip_evidence_selector.dart';
import '../../text/status_rule_explanation_text_builder.dart';
import '../status_metric_rule.dart';

class XdripLocalServiceRule implements StatusMetricRule {
  final XdripEvidenceSelector evidenceSelector;
  final StatusRuleExplanationTextBuilder textBuilder;

  const XdripLocalServiceRule({
    this.evidenceSelector = const XdripEvidenceSelector(),
    this.textBuilder = const StatusRuleExplanationTextBuilder(),
  });

  @override
  Future<StatusRuleResult> evaluate(StatusAnalysisContext context) async {
    const ruleId = StatusRuleId('xdrip.local_service');
    final xdrip = evidenceSelector.local(context);
    final probe = xdrip.serviceProbe;
    if (!xdrip.configured && probe == null) {
      const metric = StatusMetric.unknown(
        id: 'local_service',
        label: 'Local service',
        source: StatusMetricSource.localProbe,
        reason: 'xDrip+ Local is not configured',
      );
      return StatusRuleResult(
        ruleId: ruleId,
        metric: metric,
        level: StatusLevel.unknown,
        dataQuality: StatusDataQuality.unavailable,
        explanation: textBuilder.build(
          'status.rule.xdrip.local_service.not_local.v1',
          const {},
        ),
        affectsComponentLevel: false,
      );
    }
    if (probe == null) {
      final metric = StatusMetric.unknown(
        id: 'local_service',
        label: 'Local service',
        source: StatusMetricSource.localProbe,
        reason: xdrip.failureLabel ?? 'Local service probe was not available',
      );
      return StatusRuleResult(
        ruleId: ruleId,
        metric: metric,
        level: StatusLevel.unknown,
        dataQuality: StatusDataQuality.unavailable,
        explanation: textBuilder.build(
          'status.rule.xdrip.local_service.unavailable.v1',
          const {},
        ),
        affectsComponentLevel: false,
      );
    }
    final metric = StatusMetric(
      id: 'local_service',
      label: 'Local service',
      valueLabel:
          probe.reachable ? '${probe.elapsed.inMilliseconds}ms' : 'Unreachable',
      level: probe.level,
      source: StatusMetricSource.localProbe,
      observedAt: probe.checkedAt,
      threshold: const StatusThreshold(
        healthyLabel: '<500ms',
        watchLabel: '500ms-3s',
        issueLabel: '>3s/fail',
      ),
      note: probe.message,
    );
    return StatusRuleResult(
      ruleId: ruleId,
      metric: metric,
      level: probe.level,
      dataQuality: probe.reachable
          ? StatusDataQuality.normal
          : StatusDataQuality.unavailable,
      explanation: textBuilder.build(
        'status.rule.xdrip.local_service.value.v1',
        {'value': metric.valueLabel},
      ),
    );
  }
}
