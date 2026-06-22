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

class AapsProfileContextRule implements StatusMetricRule {
  final AapsEvidenceSelector evidenceSelector;
  final AapsRuleHelpers helpers;

  const AapsProfileContextRule({
    this.evidenceSelector = const AapsEvidenceSelector(),
    this.helpers = const AapsRuleHelpers(),
  });

  @override
  Future<StatusRuleResult> evaluate(StatusAnalysisContext context) async {
    const ruleId = StatusRuleId('aaps.profile_context');
    final profile = evidenceSelector.evidence(context).latestProfile;
    if (profile == null || !profile.visible) {
      return helpers.unknown(
        ruleId: ruleId,
        metricId: AapsMetricIds.profileContext,
        label: 'Profile context',
        reason: 'Profile or temp target context is not visible.',
        templateKey: 'status.aaps.rule.profile_context.unavailable.v1',
      );
    }
    final metric = StatusMetric(
      id: AapsMetricIds.profileContext,
      label: 'Profile context',
      valueLabel: 'Visible',
      level: StatusLevel.healthy,
      source: StatusMetricSource.deviceStatus,
      observedAt: profile.observedAt,
      note: profile.note,
    );
    return StatusRuleResult(
      ruleId: ruleId,
      metric: metric,
      level: StatusLevel.healthy,
      dataQuality: StatusDataQuality.normal,
      explanation: helpers.textBuilder.ruleExplanation(
        'status.aaps.rule.profile_context.available.v1',
        {'note': profile.note},
        fallbackSummary: profile.note,
        fallbackDetail:
            'This check reports visible profile or temp target context only.',
      ),
    );
  }
}
