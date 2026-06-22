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

class NightscoutServerDataFreshnessRule implements StatusMetricRule {
  final NightscoutEvidenceSelector evidenceSelector;
  final StatusRuleExplanationTextBuilder textBuilder;

  const NightscoutServerDataFreshnessRule({
    this.evidenceSelector = const NightscoutEvidenceSelector(),
    this.textBuilder = const StatusRuleExplanationTextBuilder(),
  });

  @override
  Future<StatusRuleResult> evaluate(StatusAnalysisContext context) async {
    const ruleId = StatusRuleId('nightscout.server_data_freshness');
    final evidence = evidenceSelector.readings(context);
    if (evidence.sourceLabel == 'No readings' &&
        !evidenceSelector.nightscout(context).configured) {
      const metric = StatusMetric.unknown(
        id: 'server_data_freshness',
        label: 'Latest server reading',
        source: StatusMetricSource.nightscoutStatus,
        reason: 'No Nightscout server target',
      );
      return StatusRuleResult(
        ruleId: ruleId,
        metric: metric,
        level: StatusLevel.unknown,
        dataQuality: StatusDataQuality.unavailable,
        explanation: textBuilder.build(
          'status.rule.nightscout.server_freshness.not_configured.v1',
          const {},
        ),
        affectsComponentLevel: false,
      );
    }
    if (evidence.readings.isEmpty) {
      final metric = StatusMetric.unknown(
        id: 'server_data_freshness',
        label: 'Latest server reading',
        source: StatusMetricSource.entries,
        reason: evidence.failureLabel ?? 'No server readings available',
      );
      return StatusRuleResult(
        ruleId: ruleId,
        metric: metric,
        level: StatusLevel.unknown,
        dataQuality: StatusDataQuality.insufficientData,
        explanation: textBuilder.build(
          'status.rule.nightscout.server_freshness.unavailable.v1',
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
      id: 'server_data_freshness',
      label: 'Latest server reading',
      valueLabel: '${age.inMinutes}m',
      level: level,
      source: StatusMetricSource.entries,
      observedAt: latest.timestamp,
      threshold: const StatusThreshold(
        healthyLabel: '<7m',
        watchLabel: '7-15m',
        issueLabel: '>15m',
      ),
      note: evidence.sourceLabel,
    );
    return StatusRuleResult(
      ruleId: ruleId,
      metric: metric,
      level: level,
      dataQuality: StatusDataQuality.normal,
      explanation: textBuilder.build(
        'status.rule.nightscout.server_freshness.value.v1',
        {'age': metric.valueLabel},
      ),
    );
  }
}
