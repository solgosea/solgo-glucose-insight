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

class AapsLoopContextRule implements StatusMetricRule {
  final AapsEvidenceSelector evidenceSelector;
  final AapsRuleHelpers helpers;

  const AapsLoopContextRule({
    this.evidenceSelector = const AapsEvidenceSelector(),
    this.helpers = const AapsRuleHelpers(),
  });

  @override
  Future<StatusRuleResult> evaluate(StatusAnalysisContext context) async {
    const ruleId = StatusRuleId('aaps.loop_context');
    final loop = evidenceSelector.evidence(context).latestLoop;
    if (loop == null || !loop.visible) {
      return helpers.unknown(
        ruleId: ruleId,
        metricId: AapsMetricIds.loopContext,
        label: 'Loop context',
        reason: 'OpenAPS loop context is not exposed by Nightscout.',
        templateKey: 'status.aaps.rule.loop_context.unavailable.v1',
      );
    }
    final age = loop.observedAt == null
        ? null
        : context.now.difference(loop.observedAt!);
    final stale = age != null && age > const Duration(minutes: 30);
    final level = stale
        ? StatusLevel.issue
        : loop.partial
            ? StatusLevel.watch
            : StatusLevel.healthy;
    final value = stale
        ? 'Stale'
        : loop.partial
            ? 'Partial'
            : 'Visible';
    final metric = StatusMetric(
      id: AapsMetricIds.loopContext,
      label: 'Loop context',
      valueLabel: value,
      level: level,
      source: StatusMetricSource.deviceStatus,
      observedAt: loop.observedAt,
      note: loop.note,
    );
    return StatusRuleResult(
      ruleId: ruleId,
      metric: metric,
      level: level,
      dataQuality: StatusDataQuality.normal,
      explanation: helpers.textBuilder.ruleExplanation(
        'status.aaps.rule.loop_context.available.v1',
        {'note': loop.note},
        fallbackSummary: loop.note,
        fallbackDetail:
            'This check only confirms visible loop context. It does not evaluate loop decisions.',
      ),
    );
  }
}
