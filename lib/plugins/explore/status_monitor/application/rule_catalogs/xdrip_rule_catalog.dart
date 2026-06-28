import '../../domain/analysis/status_rule_id.dart';
import '../../domain/rules/status_rule_availability.dart';
import '../../domain/rules/status_rule_catalog.dart';
import '../../domain/rules/status_rule_definition.dart';
import '../../domain/rules/status_rule_group.dart';
import '../../domain/rules/status_rule_input_requirement.dart';
import '../../domain/rules/status_rule_threshold_band.dart';
import '../../domain/status_component_kind.dart';
import '../../domain/status_level.dart';
import '../engines/xdrip/xdrip_metric_ids.dart';
import '../rule_engine/status_rule_evaluator.dart';
import '../rule_engine/status_rule_registry.dart';
import '../rules/xdrip/completeness_24h_rule.dart';
import '../rules/xdrip/reading_freshness_rule.dart';
import '../rules/xdrip/upload_latency_rule.dart';
import '../rules/xdrip/uploader_battery_rule.dart';
import '../rules/xdrip/xdrip_local_broadcast_rule.dart';
import '../rules/xdrip/xdrip_local_service_rule.dart';
import '../rules/xdrip/xdrip_sensor_collector_context_rule.dart';

class XdripRuleCatalog {
  const XdripRuleCatalog();

  StatusRuleRegistry build() {
    final evaluators = [
      StatusRuleEvaluator(
        definition: _definition(
          ruleId: 'xdrip.local_service',
          metricId: XdripMetricIds.localService,
          weight: 0,
          inputs: const [StatusRuleInputRequirement.endpointProbe],
          textTemplateKey: 'status.xdrip.rule.local_service.v1',
        ),
        rule: const XdripLocalServiceRule(),
      ),
      StatusRuleEvaluator(
        definition: _definition(
          ruleId: 'xdrip.local_broadcast',
          metricId: XdripMetricIds.localBroadcast,
          weight: 35,
          inputs: const [StatusRuleInputRequirement.localBroadcast],
          textTemplateKey: 'status.xdrip.rule.local_broadcast.v1',
        ),
        rule: const XdripLocalBroadcastRule(),
      ),
      StatusRuleEvaluator(
        definition: _definition(
          ruleId: 'xdrip.reading_freshness',
          metricId: XdripMetricIds.freshness,
          weight: 35,
          inputs: const [
            StatusRuleInputRequirement.currentSource,
            StatusRuleInputRequirement.readings,
          ],
          textTemplateKey: 'status.xdrip.rule.freshness.v1',
        ),
        rule: const ReadingFreshnessRule(),
      ),
      StatusRuleEvaluator(
        definition: _definition(
          ruleId: 'xdrip.completeness_24h',
          metricId: XdripMetricIds.completeness24h,
          weight: 10,
          inputs: const [StatusRuleInputRequirement.readings],
          textTemplateKey: 'status.xdrip.rule.completeness.v1',
        ),
        rule: const Completeness24hRule(),
      ),
      StatusRuleEvaluator(
        definition: _definition(
          ruleId: 'xdrip.upload_latency_p95',
          metricId: XdripMetricIds.uploadLatency,
          weight: 0,
          inputs: const [
            StatusRuleInputRequirement.readings,
            StatusRuleInputRequirement.endpointProbe,
          ],
          textTemplateKey: 'status.xdrip.rule.upload_latency.v1',
        ),
        rule: const UploadLatencyRule(),
      ),
      StatusRuleEvaluator(
        definition: _definition(
          ruleId: 'xdrip.uploader_battery',
          metricId: XdripMetricIds.uploaderBattery,
          weight: 10,
          inputs: const [
            StatusRuleInputRequirement.deviceStatus,
            StatusRuleInputRequirement.pebble,
          ],
          textTemplateKey: 'status.xdrip.rule.battery.v1',
        ),
        rule: const UploaderBatteryRule(),
      ),
      StatusRuleEvaluator(
        definition: _definition(
          ruleId: 'xdrip.sensor_collector_context',
          metricId: XdripMetricIds.sensorCollectorContext,
          weight: 10,
          inputs: const [
            StatusRuleInputRequirement.sensorContext,
            StatusRuleInputRequirement.collectorContext,
          ],
          textTemplateKey: 'status.xdrip.rule.context.v1',
        ),
        rule: const XdripSensorCollectorContextRule(),
      ),
    ];
    return StatusRuleRegistry(
      catalog: StatusRuleCatalog(
        group: StatusRuleGroup.xdrip,
        definitions: evaluators.map((entry) => entry.definition).toList(),
      ),
      evaluators: evaluators,
    );
  }

  StatusRuleDefinition _definition({
    required String ruleId,
    required String metricId,
    required double weight,
    required List<StatusRuleInputRequirement> inputs,
    required String textTemplateKey,
  }) {
    return StatusRuleDefinition(
      ruleId: StatusRuleId(ruleId),
      componentKind: StatusComponentKind.xdrip,
      metricId: metricId,
      inputRequirements: inputs,
      thresholdBands: const [
        StatusRuleThresholdBand(
          level: StatusLevel.healthy,
          label: 'Healthy',
        ),
        StatusRuleThresholdBand(level: StatusLevel.watch, label: 'Watch'),
        StatusRuleThresholdBand(level: StatusLevel.issue, label: 'Issue'),
      ],
      weight: weight,
      affectsComponentLevel: true,
      unavailableBehavior: StatusRuleAvailability.unknownWhenMissing,
      textTemplateKey: textTemplateKey,
    );
  }
}
