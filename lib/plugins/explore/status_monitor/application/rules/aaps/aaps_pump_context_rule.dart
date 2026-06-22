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

class AapsPumpContextRule implements StatusMetricRule {
  final AapsEvidenceSelector evidenceSelector;
  final AapsRuleHelpers helpers;

  const AapsPumpContextRule({
    this.evidenceSelector = const AapsEvidenceSelector(),
    this.helpers = const AapsRuleHelpers(),
  });

  @override
  Future<StatusRuleResult> evaluate(StatusAnalysisContext context) async {
    const ruleId = StatusRuleId('aaps.pump_context');
    final pump = evidenceSelector.evidence(context).latestPump;
    if (pump == null || !pump.visible) {
      return helpers.unknown(
        ruleId: ruleId,
        metricId: AapsMetricIds.pumpContext,
        label: 'Pump context',
        reason: 'Pump context is not exposed by Nightscout device status.',
        templateKey: 'status.aaps.rule.pump_context.unavailable.v1',
      );
    }
    final level = pump.partial ? StatusLevel.watch : StatusLevel.healthy;
    final metric = StatusMetric(
      id: AapsMetricIds.pumpContext,
      label: 'Pump context',
      valueLabel: pump.partial ? 'Partial' : 'Visible',
      level: level,
      source: StatusMetricSource.deviceStatus,
      observedAt: pump.observedAt,
      note: pump.note,
    );
    return StatusRuleResult(
      ruleId: ruleId,
      metric: metric,
      level: level,
      dataQuality: StatusDataQuality.normal,
      explanation: helpers.textBuilder.ruleExplanation(
        'status.aaps.rule.pump_context.available.v1',
        {'note': pump.note},
        fallbackSummary: pump.note,
        fallbackDetail: 'This check reports visible pump context only.',
      ),
    );
  }
}
