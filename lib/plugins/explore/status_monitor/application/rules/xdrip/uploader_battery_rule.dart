import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/analysis/status_data_quality.dart';
import '../../../domain/analysis/status_rule_id.dart';
import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/status_level.dart';
import '../../../domain/status_metric.dart';
import '../../../domain/status_metric_source.dart';
import '../../evidence/nightscout_evidence_selector.dart';
import '../../evidence/xdrip_evidence_selector.dart';
import '../../status_threshold_provider.dart';
import '../../text/status_rule_explanation_text_builder.dart';
import '../status_metric_rule.dart';

class UploaderBatteryRule implements StatusMetricRule {
  final StatusThresholdProvider thresholds;
  final XdripEvidenceSelector xdripEvidenceSelector;
  final NightscoutEvidenceSelector nightscoutEvidenceSelector;
  final StatusRuleExplanationTextBuilder textBuilder;

  const UploaderBatteryRule({
    this.thresholds = const StatusThresholdProvider(),
    this.xdripEvidenceSelector = const XdripEvidenceSelector(),
    this.nightscoutEvidenceSelector = const NightscoutEvidenceSelector(),
    this.textBuilder = const StatusRuleExplanationTextBuilder(),
  });

  @override
  Future<StatusRuleResult> evaluate(StatusAnalysisContext context) async {
    const ruleId = StatusRuleId('xdrip.uploader_battery');
    final xdrip = xdripEvidenceSelector.local(context);
    final nightscout = nightscoutEvidenceSelector.nightscout(context);
    final pebbleBattery = _batteryFromPebble(xdrip.pebble);
    final value =
        pebbleBattery ?? _batteryFromDeviceStatus(nightscout.deviceStatus);
    if (value == null) {
      const metric = StatusMetric.unknown(
        id: 'uploader_battery',
        label: 'Uploader battery',
        source: StatusMetricSource.deviceStatus,
        reason: 'Battery field not available from current source',
      );
      return StatusRuleResult(
        ruleId: ruleId,
        metric: metric,
        level: StatusLevel.unknown,
        dataQuality: StatusDataQuality.unavailable,
        explanation: textBuilder.build(
          'status.rule.xdrip.battery.unavailable.v1',
          const {},
        ),
        affectsComponentLevel: false,
      );
    }
    final result = thresholds.battery(value);
    final metric = StatusMetric(
      id: 'uploader_battery',
      label: 'Uploader battery',
      valueLabel: '$value%',
      level: result.level,
      source: pebbleBattery == null
          ? StatusMetricSource.deviceStatus
          : StatusMetricSource.pebble,
      threshold: result.threshold,
      note: pebbleBattery == null ? nightscout.sourceLabel : xdrip.sourceLabel,
    );
    return StatusRuleResult(
      ruleId: ruleId,
      metric: metric,
      level: result.level,
      dataQuality: StatusDataQuality.normal,
      explanation: textBuilder.build(
        'status.rule.xdrip.battery.value.v1',
        {'battery': value},
      ),
    );
  }

  int? _batteryFromDeviceStatus(List<Map<String, dynamic>> rows) {
    for (final row in rows) {
      final uploader = row['uploader'];
      if (uploader is Map && uploader['battery'] is num) {
        return (uploader['battery'] as num).round();
      }
    }
    return null;
  }

  int? _batteryFromPebble(Map<String, dynamic>? pebble) {
    final bgs = pebble?['bgs'];
    if (bgs is List && bgs.isNotEmpty && bgs.first is Map) {
      final battery = (bgs.first as Map)['battery'];
      if (battery is num) return battery.round();
    }
    return null;
  }
}
