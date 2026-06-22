import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/analysis/status_data_quality.dart';
import '../../../domain/analysis/status_rule_id.dart';
import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/status_metric.dart';
import '../../../domain/status_metric_source.dart';
import '../../../domain/status_threshold.dart';
import '../../engines/aaps/aaps_metric_ids.dart';
import '../../evidence/aaps_evidence_selector.dart';
import '../status_metric_rule.dart';
import 'aaps_rule_helpers.dart';

class AapsSyncFreshnessRule implements StatusMetricRule {
  final AapsEvidenceSelector evidenceSelector;
  final AapsRuleHelpers helpers;

  const AapsSyncFreshnessRule({
    this.evidenceSelector = const AapsEvidenceSelector(),
    this.helpers = const AapsRuleHelpers(),
  });

  @override
  Future<StatusRuleResult> evaluate(StatusAnalysisContext context) async {
    const ruleId = StatusRuleId('aaps.sync_freshness');
    final evidence = evidenceSelector.evidence(context);
    final observedAt = evidence.latestContextAt;
    if (!evidence.configured) {
      return helpers.unknown(
        ruleId: ruleId,
        metricId: AapsMetricIds.syncFreshness,
        label: 'Latest AAPS context',
        reason: 'No Nightscout target is configured.',
        templateKey: 'status.aaps.rule.sync_freshness.unavailable.v1',
      );
    }
    if (observedAt == null) {
      return helpers.unknown(
        ruleId: ruleId,
        metricId: AapsMetricIds.syncFreshness,
        label: 'Latest AAPS context',
        reason: 'No AAPS/OpenAPS context is visible in device status.',
        templateKey: 'status.aaps.rule.sync_freshness.unavailable.v1',
      );
    }
    final age = context.now.difference(observedAt);
    final level = helpers.freshnessLevel(age);
    final metric = StatusMetric(
      id: AapsMetricIds.syncFreshness,
      label: 'Latest AAPS context',
      valueLabel: helpers.ageLabel(age),
      level: level,
      source: StatusMetricSource.deviceStatus,
      observedAt: observedAt,
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
      explanation: helpers.textBuilder.ruleExplanation(
        'status.aaps.rule.sync_freshness.available.v1',
        {'ageLabel': metric.valueLabel},
        fallbackSummary: metric.valueLabel,
        fallbackDetail: metric.valueLabel,
      ),
    );
  }
}
