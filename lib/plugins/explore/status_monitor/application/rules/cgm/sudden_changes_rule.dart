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

class SuddenChangesRule implements StatusMetricRule {
  final StatusThresholdProvider thresholds;
  final StatusMath math;
  final CgmHistoryEvidenceSelector evidenceSelector;
  final StatusRuleExplanationTextBuilder textBuilder;

  const SuddenChangesRule({
    this.thresholds = const StatusThresholdProvider(),
    this.math = const StatusMath(),
    this.evidenceSelector = const CgmHistoryEvidenceSelector(),
    this.textBuilder = const StatusRuleExplanationTextBuilder(),
  });

  @override
  Future<StatusRuleResult> evaluate(StatusAnalysisContext context) async {
    const ruleId = StatusRuleId('cgm.sudden_changes_24h');
    final readings = evidenceSelector.readings(context).readings;
    if (readings.length < 2) {
      const metric = StatusMetric.unknown(
        id: 'sudden_changes_24h',
        label: 'Sudden changes (24h)',
        source: StatusMetricSource.entries,
        reason: 'Not enough readings to evaluate sudden changes',
      );
      return StatusRuleResult(
        ruleId: ruleId,
        metric: metric,
        level: StatusLevel.unknown,
        dataQuality: StatusDataQuality.insufficientData,
        explanation: textBuilder.build(
          'status.rule.cgm.sudden_changes.count.v1',
          const {'count': 0, 'windowWord': 'windows'},
        ),
        affectsComponentLevel: false,
      );
    }
    final timestamps = math.suddenChangeTimestamps(readings);
    final count = timestamps.length;
    final windowStart = context.now.subtract(const Duration(hours: 24));
    final positions = timestamps
        .map(
          (timestamp) =>
              timestamp.difference(windowStart).inMilliseconds /
              const Duration(hours: 24).inMilliseconds,
        )
        .map((value) => value.clamp(0, 1).toDouble())
        .toList(growable: false);
    final result = thresholds.suddenChanges(count);
    final metric = StatusMetric(
      id: 'sudden_changes_24h',
      label: 'Sudden changes (24h)',
      valueLabel: '$count',
      level: result.level,
      source: StatusMetricSource.entries,
      observedAt: readings.isEmpty ? null : readings.last.timestamp,
      threshold: result.threshold,
      metadata: {
        'eventPositions': positions,
      },
    );
    return StatusRuleResult(
      ruleId: ruleId,
      metric: metric,
      level: result.level,
      dataQuality: StatusDataQuality.normal,
      explanation: textBuilder.build(
        'status.rule.cgm.sudden_changes.count.v1',
        {
          'count': count,
          'windowWord': count == 1 ? 'window' : 'windows',
        },
      ),
      affectsComponentLevel: false,
    );
  }
}
