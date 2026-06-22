import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/analysis/status_data_quality.dart';
import '../../../domain/analysis/status_rule_id.dart';
import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/status_level.dart';
import '../../../domain/status_metric.dart';
import '../../../domain/status_metric_source.dart';
import '../../evidence/cgm_history_evidence_selector.dart';
import '../../evaluators/status_math.dart';
import '../../status_threshold_provider.dart';
import '../../text/status_rule_explanation_text_builder.dart';
import '../status_metric_rule.dart';

class CgmCvRule implements StatusMetricRule {
  final StatusThresholdProvider thresholds;
  final StatusMath math;
  final CgmHistoryEvidenceSelector evidenceSelector;
  final StatusRuleExplanationTextBuilder textBuilder;

  const CgmCvRule({
    this.thresholds = const StatusThresholdProvider(),
    this.math = const StatusMath(),
    this.evidenceSelector = const CgmHistoryEvidenceSelector(),
    this.textBuilder = const StatusRuleExplanationTextBuilder(),
  });

  @override
  Future<StatusRuleResult> evaluate(StatusAnalysisContext context) async {
    const ruleId = StatusRuleId('cgm.cv_24h');
    final readings = evidenceSelector.readings(context).readings;
    if (readings.length < 72) {
      const metric = StatusMetric.unknown(
        id: 'cgm_cv_24h',
        label: 'CV (24h)',
        source: StatusMetricSource.entries,
        reason: 'Not enough 24h readings',
      );
      return StatusRuleResult(
        ruleId: ruleId,
        metric: metric,
        level: StatusLevel.unknown,
        dataQuality: StatusDataQuality.insufficientData,
        explanation: textBuilder.build(
          'status.rule.cgm.cv.insufficient.v1',
          const {'minimumReadings': 72},
        ),
        affectsComponentLevel: false,
      );
    }

    final cv = math.cv(readings);
    final result = thresholds.cgmCv(cv);
    final metric = StatusMetric(
      id: 'cgm_cv_24h',
      label: 'CV (24h)',
      valueLabel: '${cv.toStringAsFixed(0)}%',
      level: result.level,
      source: StatusMetricSource.entries,
      observedAt: readings.last.timestamp,
      threshold: result.threshold,
    );
    return StatusRuleResult(
      ruleId: ruleId,
      metric: metric,
      level: result.level,
      dataQuality: StatusDataQuality.normal,
      explanation: textBuilder.build(
        'status.rule.cgm.cv.value.v1',
        {'cv': metric.valueLabel},
      ),
      affectsComponentLevel: false,
    );
  }
}
