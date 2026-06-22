import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/analysis/status_data_quality.dart';
import '../../../domain/analysis/status_rule_id.dart';
import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/status_level.dart';
import '../../../domain/status_metric.dart';
import '../../../domain/status_metric_source.dart';
import '../../engines/aaps/aaps_metric_ids.dart';
import '../../evidence/aaps_evidence_selector.dart';
import '../status_metric_rule.dart';
import 'aaps_rule_helpers.dart';

class AapsNightscoutDependencyRule implements StatusMetricRule {
  final AapsEvidenceSelector evidenceSelector;
  final AapsRuleHelpers helpers;

  const AapsNightscoutDependencyRule({
    this.evidenceSelector = const AapsEvidenceSelector(),
    this.helpers = const AapsRuleHelpers(),
  });

  @override
  Future<StatusRuleResult> evaluate(StatusAnalysisContext context) async {
    const ruleId = StatusRuleId('aaps.nightscout_dependency');
    final evidence = evidenceSelector.evidence(context);
    if (!evidence.configured) {
      return helpers.unknown(
        ruleId: ruleId,
        metricId: AapsMetricIds.nightscoutDependency,
        label: 'Nightscout evidence',
        reason: 'No Nightscout target is configured.',
        templateKey: 'status.aaps.rule.nightscout_dependency.unavailable.v1',
      );
    }
    if (!evidence.hasAapsContext) {
      return helpers.unknown(
        ruleId: ruleId,
        metricId: AapsMetricIds.nightscoutDependency,
        label: 'Nightscout evidence',
        reason: 'Nightscout did not expose AAPS context in device status.',
        templateKey: 'status.aaps.rule.nightscout_dependency.unavailable.v1',
      );
    }
    final level =
        evidence.nightscoutReachable ? StatusLevel.healthy : StatusLevel.issue;
    final metric = StatusMetric(
      id: AapsMetricIds.nightscoutDependency,
      label: 'Nightscout evidence',
      valueLabel: evidence.nightscoutReachable ? 'Reachable' : 'Unavailable',
      level: level,
      source: StatusMetricSource.nightscoutStatus,
      observedAt: evidence.generatedAt,
      note: evidence.sourceLabel,
    );
    return StatusRuleResult(
      ruleId: ruleId,
      metric: metric,
      level: level,
      dataQuality: StatusDataQuality.normal,
      explanation: helpers.textBuilder.ruleExplanation(
        'status.aaps.rule.nightscout_dependency.available.v1',
        {
          'statusLabel':
              evidence.nightscoutReachable ? 'available' : 'unavailable',
        },
        fallbackSummary: evidence.nightscoutReachable
            ? 'Nightscout device status is available.'
            : 'Nightscout device status is not currently available.',
        fallbackDetail:
            'AAPS monitoring depends on observable Nightscout evidence.',
      ),
    );
  }
}
