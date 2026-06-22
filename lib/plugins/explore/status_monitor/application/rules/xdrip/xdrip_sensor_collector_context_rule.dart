import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/analysis/status_data_quality.dart';
import '../../../domain/analysis/status_rule_id.dart';
import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/status_level.dart';
import '../../../domain/status_metric.dart';
import '../../../domain/status_metric_source.dart';
import '../../evidence/xdrip_evidence_selector.dart';
import '../../text/status_rule_explanation_text_builder.dart';
import '../status_metric_rule.dart';

class XdripSensorCollectorContextRule implements StatusMetricRule {
  final XdripEvidenceSelector evidenceSelector;
  final StatusRuleExplanationTextBuilder textBuilder;

  const XdripSensorCollectorContextRule({
    this.evidenceSelector = const XdripEvidenceSelector(),
    this.textBuilder = const StatusRuleExplanationTextBuilder(),
  });

  @override
  Future<StatusRuleResult> evaluate(StatusAnalysisContext context) async {
    const ruleId = StatusRuleId('xdrip.sensor_collector_context');
    final xdrip = evidenceSelector.local(context);
    final hasContext = (xdrip.sensorContext?.isNotEmpty ?? false) ||
        (xdrip.collectorContext?.isNotEmpty ?? false);
    if (!hasContext) {
      const metric = StatusMetric.unknown(
        id: 'sensor_collector_context',
        label: 'Sensor/collector context',
        source: StatusMetricSource.localProbe,
        reason: 'Not exposed by this source',
      );
      return StatusRuleResult(
        ruleId: ruleId,
        metric: metric,
        level: StatusLevel.unknown,
        dataQuality: StatusDataQuality.unavailable,
        explanation: textBuilder.build(
          'status.rule.xdrip.context.unavailable.v1',
          const {},
        ),
        affectsComponentLevel: false,
      );
    }
    final metric = StatusMetric(
      id: 'sensor_collector_context',
      label: 'Sensor/collector context',
      valueLabel: 'Available',
      level: StatusLevel.healthy,
      source: StatusMetricSource.localProbe,
      observedAt: context.now,
    );
    return StatusRuleResult(
      ruleId: ruleId,
      metric: metric,
      level: StatusLevel.healthy,
      dataQuality: StatusDataQuality.normal,
      explanation: textBuilder.build(
        'status.rule.xdrip.context.available.v1',
        const {},
      ),
    );
  }
}
