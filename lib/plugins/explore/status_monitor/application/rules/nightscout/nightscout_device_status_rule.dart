import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/analysis/status_data_quality.dart';
import '../../../domain/analysis/status_rule_id.dart';
import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/status_level.dart';
import '../../../domain/status_metric.dart';
import '../../../domain/status_metric_source.dart';
import '../../evidence/nightscout_evidence_selector.dart';
import '../../text/status_rule_explanation_text_builder.dart';
import '../status_metric_rule.dart';

class NightscoutDeviceStatusRule implements StatusMetricRule {
  final NightscoutEvidenceSelector evidenceSelector;
  final StatusRuleExplanationTextBuilder textBuilder;

  const NightscoutDeviceStatusRule({
    this.evidenceSelector = const NightscoutEvidenceSelector(),
    this.textBuilder = const StatusRuleExplanationTextBuilder(),
  });

  @override
  Future<StatusRuleResult> evaluate(StatusAnalysisContext context) async {
    const ruleId = StatusRuleId('nightscout.device_status');
    final nightscout = evidenceSelector.nightscout(context);
    if (!nightscout.configured || !nightscout.enabled) {
      const metric = StatusMetric.unknown(
        id: 'device_status',
        label: 'Device status',
        source: StatusMetricSource.deviceStatus,
        reason: 'Device status is not available from this source',
      );
      return StatusRuleResult(
        ruleId: ruleId,
        metric: metric,
        level: StatusLevel.unknown,
        dataQuality: StatusDataQuality.unavailable,
        explanation: textBuilder.build(
          'status.rule.nightscout.device_status.unavailable.v1',
          const {},
        ),
        affectsComponentLevel: false,
      );
    }

    final rows = nightscout.deviceStatus;
    if (rows.isEmpty) {
      const metric = StatusMetric.unknown(
        id: 'device_status',
        label: 'Device status',
        source: StatusMetricSource.deviceStatus,
        reason: 'No devicestatus rows returned',
        note: 'Some Nightscout deployments do not publish devicestatus.',
      );
      return StatusRuleResult(
        ruleId: ruleId,
        metric: metric,
        level: StatusLevel.unknown,
        dataQuality: StatusDataQuality.unavailable,
        explanation: textBuilder.build(
          'status.rule.nightscout.device_status.no_rows.v1',
          const {},
        ),
        affectsComponentLevel: false,
      );
    }

    final latest = rows.first;
    final label = _labelFor(latest);
    final metric = StatusMetric(
      id: 'device_status',
      label: 'Device status',
      valueLabel: '${rows.length} rows',
      level: StatusLevel.healthy,
      source: StatusMetricSource.deviceStatus,
      note: label,
      metadata: {'latestLabel': label},
    );
    return StatusRuleResult(
      ruleId: ruleId,
      metric: metric,
      level: StatusLevel.healthy,
      dataQuality: StatusDataQuality.normal,
      explanation: textBuilder.build(
        'status.rule.nightscout.device_status.value.v1',
        {'contextLabel': label.isEmpty ? 'uploader context' : label},
      ),
    );
  }

  String _labelFor(Map<String, dynamic> row) {
    final uploader = row['uploader']?.toString();
    final device = row['device']?.toString();
    final pump =
        row['pump'] is Map ? (row['pump'] as Map)['status']?.toString() : null;
    return [uploader, device, pump]
        .where((value) => value != null && value.trim().isNotEmpty)
        .join(' / ');
  }
}
