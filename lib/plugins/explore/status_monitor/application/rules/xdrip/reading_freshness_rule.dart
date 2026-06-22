import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/analysis/status_data_quality.dart';
import '../../../domain/analysis/status_rule_id.dart';
import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/status_level.dart';
import '../../../domain/status_metric.dart';
import '../../../domain/status_metric_source.dart';
import '../../evidence/xdrip_evidence_selector.dart';
import '../../policies/timestamp_sanity_policy.dart';
import '../../status_threshold_provider.dart';
import '../../text/status_rule_explanation_text_builder.dart';
import '../status_metric_rule.dart';

class ReadingFreshnessRule implements StatusMetricRule {
  final StatusThresholdProvider thresholds;
  final TimestampSanityPolicy timestampSanityPolicy;
  final XdripEvidenceSelector evidenceSelector;
  final StatusRuleExplanationTextBuilder textBuilder;

  const ReadingFreshnessRule({
    this.thresholds = const StatusThresholdProvider(),
    this.timestampSanityPolicy = const TimestampSanityPolicy(),
    this.evidenceSelector = const XdripEvidenceSelector(),
    this.textBuilder = const StatusRuleExplanationTextBuilder(),
  });

  @override
  Future<StatusRuleResult> evaluate(StatusAnalysisContext context) async {
    const ruleId = StatusRuleId('xdrip.reading_freshness');
    final evidence = evidenceSelector.readings(context);
    final readings = evidence.readings;
    if (readings.isEmpty) {
      final metric = StatusMetric.unknown(
        id: 'freshness',
        label: 'Last reading freshness',
        source: StatusMetricSource.entries,
        reason: evidence.failureLabel ?? 'No recent glucose entries',
      );
      return StatusRuleResult(
        ruleId: ruleId,
        metric: metric,
        level: StatusLevel.unknown,
        dataQuality: StatusDataQuality.insufficientData,
        explanation: textBuilder.build(
          'status.rule.xdrip.freshness.no_reading.v1',
          const {},
        ),
        affectsComponentLevel: false,
      );
    }

    final sanity = timestampSanityPolicy.inspectLatest(
      readings: readings,
      now: context.now,
    );
    final latest = readings.last.timestamp;
    if (sanity.hasFutureTimestamp) {
      final minutes = sanity.futureOffset!.inMinutes;
      final metric = StatusMetric(
        id: 'freshness',
        label: 'Last reading freshness',
        valueLabel: '$minutes min ahead',
        level: StatusLevel.watch,
        source: StatusMetricSource.entries,
        observedAt: latest,
        note: 'Latest reading timestamp is ahead of device time.',
      );
      return StatusRuleResult(
        ruleId: ruleId,
        metric: metric,
        level: StatusLevel.watch,
        dataQuality: StatusDataQuality.futureTimestamp,
        explanation: textBuilder.build(
          'status.rule.xdrip.freshness.future_timestamp.v1',
          {'minutes': minutes},
        ),
      );
    }

    final age = context.now.difference(latest).abs();
    final result = thresholds.freshness(age);
    final metric = StatusMetric(
      id: 'freshness',
      label: 'Last reading freshness',
      valueLabel: age.inMinutes < 1 ? '${age.inSeconds}s' : '${age.inMinutes}m',
      level: result.level,
      source: StatusMetricSource.entries,
      observedAt: latest,
      threshold: result.threshold,
      note: evidence.sourceLabel,
    );
    return StatusRuleResult(
      ruleId: ruleId,
      metric: metric,
      level: result.level,
      dataQuality: StatusDataQuality.normal,
      explanation: textBuilder.build(
        'status.rule.xdrip.freshness.value.v1',
        {'age': metric.valueLabel},
      ),
    );
  }
}
