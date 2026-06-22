import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/analysis/status_data_quality.dart';
import '../../../domain/analysis/status_rule_id.dart';
import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/status_level.dart';
import '../../../domain/status_metric.dart';
import '../../../domain/status_metric_source.dart';
import '../../../domain/status_threshold.dart';
import '../../evidence/nightscout_evidence_selector.dart';
import '../../text/status_rule_explanation_text_builder.dart';
import '../status_metric_rule.dart';

class NightscoutEntriesEndpointRule implements StatusMetricRule {
  final NightscoutEvidenceSelector evidenceSelector;
  final StatusRuleExplanationTextBuilder textBuilder;

  const NightscoutEntriesEndpointRule({
    this.evidenceSelector = const NightscoutEvidenceSelector(),
    this.textBuilder = const StatusRuleExplanationTextBuilder(),
  });

  @override
  Future<StatusRuleResult> evaluate(StatusAnalysisContext context) async {
    const ruleId = StatusRuleId('nightscout.entries_endpoint');
    final probe = _probe(context);
    if (probe == null) {
      const metric = StatusMetric.unknown(
        id: 'entries_endpoint',
        label: 'Entries endpoint',
        source: StatusMetricSource.nightscoutStatus,
        reason: 'Entries endpoint was not probed',
      );
      return StatusRuleResult(
        ruleId: ruleId,
        metric: metric,
        level: StatusLevel.unknown,
        dataQuality: StatusDataQuality.unavailable,
        explanation: textBuilder.build(
          'status.rule.nightscout.entries.unavailable.v1',
          const {},
        ),
        affectsComponentLevel: false,
      );
    }
    final metric = StatusMetric(
      id: 'entries_endpoint',
      label: 'Entries endpoint',
      valueLabel: probe.reachable ? '${probe.statusCode ?? 200} OK' : 'Failed',
      level: probe.level,
      source: StatusMetricSource.nightscoutStatus,
      observedAt: probe.checkedAt,
      threshold: const StatusThreshold(
        healthyLabel: '200 + recent',
        watchLabel: 'empty/stale',
        issueLabel: 'fail/rejected',
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
        'status.rule.nightscout.entries.value.v1',
        {'value': metric.valueLabel},
      ),
    );
  }

  dynamic _probe(StatusAnalysisContext context) {
    for (final probe in evidenceSelector.nightscout(context).endpointProbes) {
      if (probe.endpoint.contains('/entries/')) return probe;
    }
    return null;
  }
}
