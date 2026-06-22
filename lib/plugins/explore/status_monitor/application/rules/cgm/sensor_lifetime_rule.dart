import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/analysis/status_data_quality.dart';
import '../../../domain/analysis/status_rule_id.dart';
import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/status_level.dart';
import '../../../domain/status_metric.dart';
import '../../../domain/status_metric_source.dart';
import '../../evidence/nightscout_evidence_selector.dart';
import '../../status_threshold_provider.dart';
import '../../text/status_rule_explanation_text_builder.dart';
import '../status_metric_rule.dart';

class SensorLifetimeRule implements StatusMetricRule {
  final StatusThresholdProvider thresholds;
  final NightscoutEvidenceSelector evidenceSelector;
  final StatusRuleExplanationTextBuilder textBuilder;

  const SensorLifetimeRule({
    this.thresholds = const StatusThresholdProvider(),
    this.evidenceSelector = const NightscoutEvidenceSelector(),
    this.textBuilder = const StatusRuleExplanationTextBuilder(),
  });

  @override
  Future<StatusRuleResult> evaluate(StatusAnalysisContext context) async {
    const ruleId = StatusRuleId('cgm.sensor_lifetime');
    const id = 'sensor_lifetime';
    final nightscout = evidenceSelector.nightscout(context);
    if (!nightscout.configured || !nightscout.enabled) {
      const metric = StatusMetric.unknown(
        id: id,
        label: 'Sensor lifetime',
        source: StatusMetricSource.deviceStatus,
        reason: 'Not available from this data source',
      );
      return StatusRuleResult(
        ruleId: ruleId,
        metric: metric,
        level: StatusLevel.unknown,
        dataQuality: StatusDataQuality.unavailable,
        explanation: textBuilder.build(
          'status.rule.cgm.sensor_lifetime.source_unavailable.v1',
          const {},
        ),
        affectsComponentLevel: false,
      );
    }

    final sessionStart = _latestSensorStart(nightscout.deviceStatus);
    if (sessionStart == null) {
      const metric = StatusMetric.unknown(
        id: id,
        label: 'Sensor lifetime',
        source: StatusMetricSource.deviceStatus,
        reason: 'No sensor session field in device status',
      );
      return StatusRuleResult(
        ruleId: ruleId,
        metric: metric,
        level: StatusLevel.unknown,
        dataQuality: StatusDataQuality.unavailable,
        explanation: textBuilder.build(
          'status.rule.cgm.sensor_lifetime.not_reported.v1',
          const {},
        ),
        affectsComponentLevel: false,
      );
    }

    const sessionLength = Duration(days: 14);
    final remaining = sessionStart.add(sessionLength).difference(context.now);
    final result = thresholds.sensorLifetime(remaining);
    final metric = StatusMetric(
      id: id,
      label: 'Sensor lifetime',
      valueLabel: remaining.isNegative
          ? 'Expired'
          : remaining.inDays >= 1
              ? '${remaining.inDays}d'
              : '${remaining.inHours}h',
      level: result.level,
      source: StatusMetricSource.deviceStatus,
      observedAt: context.now,
      threshold: result.threshold,
    );
    return StatusRuleResult(
      ruleId: ruleId,
      metric: metric,
      level: result.level,
      dataQuality: StatusDataQuality.normal,
      explanation: textBuilder.build(
        'status.rule.cgm.sensor_lifetime.value.v1',
        {'lifetime': metric.valueLabel},
      ),
    );
  }

  DateTime? _latestSensorStart(List<Map<String, dynamic>> rows) {
    for (final row in rows) {
      final sensor = row['sensor'];
      if (sensor is Map && sensor['sessionStart'] is num) {
        return DateTime.fromMillisecondsSinceEpoch(
          (sensor['sessionStart'] as num).toInt(),
        );
      }
    }
    return null;
  }
}
