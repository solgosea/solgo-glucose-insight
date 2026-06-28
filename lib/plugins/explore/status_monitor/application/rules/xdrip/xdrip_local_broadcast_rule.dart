import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/analysis/status_data_quality.dart';
import '../../../domain/analysis/status_rule_id.dart';
import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/status_level.dart';
import '../../../domain/status_metric.dart';
import '../../../domain/status_metric_source.dart';
import '../../../domain/status_threshold.dart';
import '../../../domain/xdrip/xdrip_broadcast_evidence.dart';
import '../../../domain/xdrip/xdrip_broadcast_state.dart';
import '../../engines/xdrip/xdrip_metric_ids.dart';
import '../../evidence/xdrip_evidence_selector.dart';
import '../../text/status_rule_explanation_text_builder.dart';
import '../status_metric_rule.dart';

class XdripLocalBroadcastRule implements StatusMetricRule {
  final XdripEvidenceSelector evidenceSelector;
  final StatusRuleExplanationTextBuilder textBuilder;

  const XdripLocalBroadcastRule({
    this.evidenceSelector = const XdripEvidenceSelector(),
    this.textBuilder = const StatusRuleExplanationTextBuilder(),
  });

  @override
  Future<StatusRuleResult> evaluate(StatusAnalysisContext context) async {
    const ruleId = StatusRuleId('xdrip.local_broadcast');
    final evidence = evidenceSelector.broadcast(context);
    final state = evidence.state(context.now);
    if (state == XdripBroadcastState.unknown) {
      final metric = StatusMetric.unknown(
        id: XdripMetricIds.localBroadcast,
        label: 'xDrip+ local broadcast',
        source: StatusMetricSource.broadcast,
        reason: 'xDrip+ broadcast observation is not available.',
        threshold: const StatusThreshold(
          healthyLabel: '<10m',
          watchLabel: '>10m',
          issueLabel: 'missing/invalid',
        ),
      );
      return StatusRuleResult(
        ruleId: ruleId,
        metric: metric,
        level: StatusLevel.unknown,
        dataQuality: StatusDataQuality.unavailable,
        explanation: textBuilder.build(
          'status.rule.xdrip.broadcast.missing.v1',
          const {},
        ),
      );
    }

    final level = switch (state) {
      XdripBroadcastState.fresh => StatusLevel.healthy,
      XdripBroadcastState.missing => StatusLevel.issue,
      XdripBroadcastState.stale => StatusLevel.issue,
      XdripBroadcastState.invalid => StatusLevel.issue,
      XdripBroadcastState.unknown => StatusLevel.unknown,
    };
    final metric = StatusMetric(
      id: XdripMetricIds.localBroadcast,
      label: 'xDrip+ local broadcast',
      valueLabel: state == XdripBroadcastState.missing
          ? 'Missing'
          : _valueLabel(evidence, context.now),
      level: level,
      source: StatusMetricSource.broadcast,
      observedAt: evidence.latestBroadcastAt,
      threshold: const StatusThreshold(
        healthyLabel: '<10m',
        watchLabel: '>10m',
        issueLabel: 'missing/invalid',
      ),
      note: state == XdripBroadcastState.fresh
          ? 'Compatible BgEstimate broadcast observed.'
          : state == XdripBroadcastState.missing
              ? 'No BgEstimate broadcast observed; check xDrip+ inter-app settings.'
              : state == XdripBroadcastState.stale
                  ? 'Broadcast is stale; check xDrip+ inter-app settings.'
                  : 'Broadcast payload was observed but glucose was missing.',
      metadata: {
        'state': state.name,
        'glucose': evidence.payload.glucose,
        'unit': evidence.payload.unit,
        'slopeName': evidence.payload.slopeName,
      },
    );
    return StatusRuleResult(
      ruleId: ruleId,
      metric: metric,
      level: level,
      dataQuality: state == XdripBroadcastState.fresh
          ? StatusDataQuality.normal
          : StatusDataQuality.unavailable,
      explanation: textBuilder.build(
        'status.rule.xdrip.broadcast.value.v1',
        {'age': metric.valueLabel, 'state': state.label},
      ),
    );
  }

  String _valueLabel(XdripBroadcastEvidence evidence, DateTime now) {
    final glucose = evidence.payload.glucose;
    final unit = evidence.payload.unit ?? 'mg/dL';
    final age = evidence.latestAgeLabel(now);
    if (glucose == null) return age;
    return '${_formatGlucose(glucose)} $unit - $age';
  }

  String _formatGlucose(double value) {
    if (value == value.roundToDouble()) return value.toStringAsFixed(0);
    return value.toStringAsFixed(1);
  }
}
