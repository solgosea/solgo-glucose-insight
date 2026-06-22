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

class AapsIobCobContextRule implements StatusMetricRule {
  final AapsEvidenceSelector evidenceSelector;
  final AapsRuleHelpers helpers;

  const AapsIobCobContextRule({
    this.evidenceSelector = const AapsEvidenceSelector(),
    this.helpers = const AapsRuleHelpers(),
  });

  @override
  Future<StatusRuleResult> evaluate(StatusAnalysisContext context) async {
    const ruleId = StatusRuleId('aaps.iob_cob_context');
    final iobCob = evidenceSelector.evidence(context).latestIobCob;
    if (iobCob == null || (!iobCob.hasIob && !iobCob.hasCob)) {
      return helpers.unknown(
        ruleId: ruleId,
        metricId: AapsMetricIds.iobCobContext,
        label: 'IOB / COB context',
        reason: 'IOB and COB context are not exposed by Nightscout.',
        templateKey: 'status.aaps.rule.iob_cob_context.unavailable.v1',
      );
    }
    final level = iobCob.hasIob && iobCob.hasCob
        ? StatusLevel.healthy
        : StatusLevel.watch;
    final metric = StatusMetric(
      id: AapsMetricIds.iobCobContext,
      label: 'IOB / COB context',
      valueLabel: level == StatusLevel.healthy ? 'Visible' : 'Partial',
      level: level,
      source: StatusMetricSource.deviceStatus,
      observedAt: iobCob.observedAt,
      note: iobCob.note,
    );
    return StatusRuleResult(
      ruleId: ruleId,
      metric: metric,
      level: level,
      dataQuality: StatusDataQuality.normal,
      explanation: helpers.textBuilder.ruleExplanation(
        'status.aaps.rule.iob_cob_context.available.v1',
        {'note': iobCob.note},
        fallbackSummary: iobCob.note,
        fallbackDetail: 'This check reports context visibility only.',
      ),
    );
  }
}
