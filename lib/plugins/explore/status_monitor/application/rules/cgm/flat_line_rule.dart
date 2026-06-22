import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/analysis/status_data_quality.dart';
import '../../../domain/analysis/status_rule_id.dart';
import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/status_metric.dart';
import '../../../domain/status_metric_source.dart';
import '../../../domain/status_level.dart';
import '../../evidence/cgm_history_evidence_selector.dart';
import '../../evaluators/status_math.dart';
import '../../status_threshold_provider.dart';
import '../../text/status_rule_explanation_text_builder.dart';
import '../status_metric_rule.dart';

class FlatLineRule implements StatusMetricRule {
  final StatusThresholdProvider thresholds;
  final StatusMath math;
  final CgmHistoryEvidenceSelector evidenceSelector;
  final StatusRuleExplanationTextBuilder textBuilder;

  const FlatLineRule({
    this.thresholds = const StatusThresholdProvider(),
    this.math = const StatusMath(),
    this.evidenceSelector = const CgmHistoryEvidenceSelector(),
    this.textBuilder = const StatusRuleExplanationTextBuilder(),
  });

  @override
  Future<StatusRuleResult> evaluate(StatusAnalysisContext context) async {
    const ruleId = StatusRuleId('cgm.flat_line_periods');
    final readings = evidenceSelector.readings(context).readings;
    if (readings.length < 2) {
      const metric = StatusMetric.unknown(
        id: 'flat_line_periods',
        label: 'Flat-line periods',
        source: StatusMetricSource.entries,
        reason: 'Not enough readings to evaluate flat periods',
      );
      return StatusRuleResult(
        ruleId: ruleId,
        metric: metric,
        level: StatusLevel.unknown,
        dataQuality: StatusDataQuality.insufficientData,
        explanation: textBuilder.build(
          'status.rule.cgm.flat_line.value.v1',
          const {'duration': 'Unknown'},
        ),
        affectsComponentLevel: false,
      );
    }
    final longest = math.longestFlatLine(readings);
    final result = thresholds.flatLine(longest);
    final metric = StatusMetric(
      id: 'flat_line_periods',
      label: 'Flat-line periods',
      valueLabel: longest.inMinutes == 0 ? 'None' : '${longest.inMinutes}m',
      level: result.level,
      source: StatusMetricSource.entries,
      observedAt: readings.isEmpty ? null : readings.last.timestamp,
      threshold: result.threshold,
    );
    return StatusRuleResult(
      ruleId: ruleId,
      metric: metric,
      level: result.level,
      dataQuality: StatusDataQuality.normal,
      explanation: textBuilder.build(
        'status.rule.cgm.flat_line.value.v1',
        {'duration': metric.valueLabel},
      ),
      affectsComponentLevel: false,
    );
  }
}
