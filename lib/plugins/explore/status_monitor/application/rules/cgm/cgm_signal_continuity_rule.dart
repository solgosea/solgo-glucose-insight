import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/analysis/status_data_quality.dart';
import '../../../domain/analysis/status_rule_id.dart';
import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/status_level.dart';
import '../../../domain/status_metric.dart';
import '../../../domain/status_metric_source.dart';
import '../../../domain/status_threshold.dart';
import '../../evidence/cgm_live_evidence_selector.dart';
import '../../text/status_rule_explanation_text_builder.dart';
import '../status_metric_rule.dart';

class CgmSignalContinuityRule implements StatusMetricRule {
  final CgmLiveEvidenceSelector evidenceSelector;
  final StatusRuleExplanationTextBuilder textBuilder;

  const CgmSignalContinuityRule({
    this.evidenceSelector = const CgmLiveEvidenceSelector(),
    this.textBuilder = const StatusRuleExplanationTextBuilder(),
  });

  @override
  Future<StatusRuleResult> evaluate(StatusAnalysisContext context) async {
    const ruleId = StatusRuleId('cgm.signal_continuity');
    final readings = [...evidenceSelector.readings(context).readings]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    if (readings.length < 2) {
      const metric = StatusMetric.unknown(
        id: 'signal_continuity',
        label: 'Signal continuity',
        source: StatusMetricSource.entries,
        reason: 'Not enough readings to evaluate continuity',
      );
      return StatusRuleResult(
        ruleId: ruleId,
        metric: metric,
        level: StatusLevel.unknown,
        dataQuality: StatusDataQuality.insufficientData,
        explanation: textBuilder.build(
          'status.rule.cgm.continuity.insufficient.v1',
          const {},
        ),
        affectsComponentLevel: false,
      );
    }
    var gapsOver15 = 0;
    var longest = Duration.zero;
    for (var i = 1; i < readings.length; i++) {
      final gap = readings[i].timestamp.difference(readings[i - 1].timestamp);
      if (gap > longest) longest = gap;
      if (gap > const Duration(minutes: 15)) gapsOver15++;
    }
    final level = longest > const Duration(minutes: 30) || gapsOver15 >= 3
        ? StatusLevel.issue
        : gapsOver15 > 0
            ? StatusLevel.watch
            : StatusLevel.healthy;
    final metric = StatusMetric(
      id: 'signal_continuity',
      label: 'Signal continuity',
      valueLabel:
          longest.inMinutes <= 5 ? 'Continuous' : '${longest.inMinutes}m gap',
      level: level,
      source: StatusMetricSource.entries,
      observedAt: readings.last.timestamp,
      threshold: const StatusThreshold(
        healthyLabel: 'no gap >15m',
        watchLabel: '1-2 gaps',
        issueLabel: '>30m or 3+ gaps',
      ),
      metadata: {
        'longestGapMinutes': longest.inMinutes,
        'gapsOver15m': gapsOver15,
      },
    );
    return StatusRuleResult(
      ruleId: ruleId,
      metric: metric,
      level: level,
      dataQuality: StatusDataQuality.normal,
      explanation: textBuilder.build(
        'status.rule.cgm.continuity.value.v1',
        {'longestGap': metric.valueLabel},
      ),
    );
  }
}
