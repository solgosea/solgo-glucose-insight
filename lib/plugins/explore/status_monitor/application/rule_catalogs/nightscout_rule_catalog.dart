import '../../domain/analysis/status_rule_id.dart';
import '../../domain/rules/status_rule_availability.dart';
import '../../domain/rules/status_rule_catalog.dart';
import '../../domain/rules/status_rule_definition.dart';
import '../../domain/rules/status_rule_group.dart';
import '../../domain/rules/status_rule_input_requirement.dart';
import '../../domain/rules/status_rule_threshold_band.dart';
import '../../domain/status_component_kind.dart';
import '../../domain/status_level.dart';
import '../engines/nightscout/nightscout_metric_ids.dart';
import '../rule_engine/status_rule_evaluator.dart';
import '../rule_engine/status_rule_registry.dart';
import '../rules/nightscout/nightscout_device_status_rule.dart';
import '../rules/nightscout/nightscout_entries_endpoint_rule.dart';
import '../rules/nightscout/nightscout_reachable_rule.dart';
import '../rules/nightscout/nightscout_response_time_rule.dart';
import '../rules/nightscout/nightscout_server_data_freshness_rule.dart';

class NightscoutRuleCatalog {
  const NightscoutRuleCatalog();

  StatusRuleRegistry build() {
    final evaluators = [
      StatusRuleEvaluator(
        definition: _definition(
          ruleId: 'nightscout.api_reachable',
          metricId: NightscoutMetricIds.apiReachable,
          weight: 35,
          inputs: const [StatusRuleInputRequirement.endpointProbe],
          textTemplateKey: 'status.nightscout.rule.reachable.v1',
        ),
        rule: const NightscoutReachableRule(),
      ),
      StatusRuleEvaluator(
        definition: _definition(
          ruleId: 'nightscout.entries_endpoint',
          metricId: NightscoutMetricIds.entriesEndpoint,
          weight: 25,
          inputs: const [
            StatusRuleInputRequirement.endpointProbe,
            StatusRuleInputRequirement.readings,
          ],
          textTemplateKey: 'status.nightscout.rule.entries.v1',
        ),
        rule: const NightscoutEntriesEndpointRule(),
      ),
      StatusRuleEvaluator(
        definition: _definition(
          ruleId: 'nightscout.server_data_freshness',
          metricId: NightscoutMetricIds.serverDataFreshness,
          weight: 20,
          inputs: const [StatusRuleInputRequirement.readings],
          textTemplateKey: 'status.nightscout.rule.server_freshness.v1',
        ),
        rule: const NightscoutServerDataFreshnessRule(),
      ),
      StatusRuleEvaluator(
        definition: _definition(
          ruleId: 'nightscout.response_time',
          metricId: NightscoutMetricIds.responseTime,
          weight: 15,
          inputs: const [StatusRuleInputRequirement.endpointProbe],
          textTemplateKey: 'status.nightscout.rule.response_time.v1',
        ),
        rule: const NightscoutResponseTimeRule(),
      ),
      StatusRuleEvaluator(
        definition: _definition(
          ruleId: 'nightscout.device_status',
          metricId: NightscoutMetricIds.deviceStatus,
          weight: 5,
          inputs: const [StatusRuleInputRequirement.deviceStatus],
          textTemplateKey: 'status.nightscout.rule.device_status.v1',
        ),
        rule: const NightscoutDeviceStatusRule(),
      ),
    ];
    return StatusRuleRegistry(
      catalog: StatusRuleCatalog(
        group: StatusRuleGroup.nightscout,
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
      componentKind: StatusComponentKind.nightscout,
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
