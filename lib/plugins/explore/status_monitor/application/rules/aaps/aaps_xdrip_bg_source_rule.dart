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
import '../../engines/aaps/aaps_metric_ids.dart';
import '../../evidence/aaps_evidence_selector.dart';
import '../status_metric_rule.dart';
import 'aaps_rule_helpers.dart';

class AapsXdripBgSourceRule implements StatusMetricRule {
  final AapsEvidenceSelector evidenceSelector;
  final AapsRuleHelpers helpers;

  const AapsXdripBgSourceRule({
    this.evidenceSelector = const AapsEvidenceSelector(),
    this.helpers = const AapsRuleHelpers(),
  });

  @override
  Future<StatusRuleResult> evaluate(StatusAnalysisContext context) async {
    const ruleId = StatusRuleId('aaps.xdrip_bg_source');
    final evidence = evidenceSelector.xdripBroadcast(context);
    final state = evidence.state(context.now);
    if (state == XdripBroadcastState.unknown) {
      return helpers.unknown(
        ruleId: ruleId,
        metricId: AapsMetricIds.xdripBgSource,
        label: 'xDrip+ BG source',
        reason:
            'No xDrip+ local broadcast has been observed for AAPS BG source checks.',
        templateKey: 'status.aaps.rule.xdrip_bg_source.missing.v1',
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
      id: AapsMetricIds.xdripBgSource,
      label: 'xDrip+ BG source',
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
          ? 'xDrip+ local broadcast is available for AAPS-style BG source flow.'
          : state == XdripBroadcastState.missing
              ? 'AAPS with xDrip+ needs the local broadcast path; no broadcast was observed.'
              : 'AAPS/xDrip+ path needs local broadcast attention.',
      metadata: {
        'state': state.name,
        'receiverPackage': 'info.nightscout.androidaps',
      },
    );
    return StatusRuleResult(
      ruleId: ruleId,
      metric: metric,
      level: level,
      dataQuality: state == XdripBroadcastState.fresh
          ? StatusDataQuality.normal
          : StatusDataQuality.unavailable,
      explanation: helpers.textBuilder.ruleExplanation(
        'status.aaps.rule.xdrip_bg_source.available.v1',
        {'ageLabel': metric.valueLabel, 'state': state.label},
        fallbackSummary: metric.valueLabel,
        fallbackDetail:
            'AAPS with xDrip+ depends on the local broadcast path, not the xDrip+ Web Server.',
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
