import '../../domain/analysis/status_rule_id.dart';
import '../../domain/rules/status_rule_availability.dart';
import '../../domain/rules/status_rule_catalog.dart';
import '../../domain/rules/status_rule_definition.dart';
import '../../domain/rules/status_rule_group.dart';
import '../../domain/rules/status_rule_input_requirement.dart';
import '../../domain/rules/status_rule_threshold_band.dart';
import '../../domain/status_component_kind.dart';
import '../../domain/status_level.dart';
import '../engines/juggluco/juggluco_metric_ids.dart';
import '../rule_engine/status_rule_evaluator.dart';
import '../rule_engine/status_rule_registry.dart';
import '../rules/juggluco/juggluco_broadcast_freshness_rule.dart';
import '../rules/juggluco/juggluco_handoff_rule.dart';
import '../rules/juggluco/juggluco_nightscout_delay_rule.dart';
import '../rules/juggluco/juggluco_optional_inspection_rule.dart';
import '../rules/juggluco/juggluco_receiver_rule.dart';

class JugglucoRuleCatalog {
  const JugglucoRuleCatalog();

  StatusRuleRegistry build() {
    final evaluators = [
      StatusRuleEvaluator(
        definition: _definition(
          ruleId: 'juggluco.receiver',
          metricId: JugglucoMetricIds.receiver,
          weight: 20,
        ),
        rule: const JugglucoReceiverRule(),
      ),
      StatusRuleEvaluator(
        definition: _definition(
          ruleId: 'juggluco.broadcast_freshness',
          metricId: JugglucoMetricIds.freshness,
          weight: 45,
        ),
        rule: const JugglucoBroadcastFreshnessRule(),
      ),
      StatusRuleEvaluator(
        definition: _definition(
          ruleId: 'juggluco.handoff',
          metricId: JugglucoMetricIds.handoff,
          weight: 20,
        ),
        rule: const JugglucoHandoffRule(),
      ),
      StatusRuleEvaluator(
        definition: _definition(
          ruleId: 'juggluco.nightscout_delay',
          metricId: JugglucoMetricIds.nightscoutDelay,
          weight: 15,
        ),
        rule: const JugglucoNightscoutDelayRule(),
      ),
      StatusRuleEvaluator(
        definition: _definition(
          ruleId: 'juggluco.optional_inspection',
          metricId: JugglucoMetricIds.optionalInspection,
          weight: 0,
        ),
        rule: const JugglucoOptionalInspectionRule(),
      ),
    ];
    return StatusRuleRegistry(
      catalog: StatusRuleCatalog(
        group: StatusRuleGroup.juggluco,
        definitions: evaluators.map((entry) => entry.definition).toList(),
      ),
      evaluators: evaluators,
    );
  }

  StatusRuleDefinition _definition({
    required String ruleId,
    required String metricId,
    required double weight,
  }) {
    return StatusRuleDefinition(
      ruleId: StatusRuleId(ruleId),
      componentKind: StatusComponentKind.juggluco,
      metricId: metricId,
      inputRequirements: const [StatusRuleInputRequirement.localCache],
      thresholdBands: const [
        StatusRuleThresholdBand(level: StatusLevel.healthy, label: 'Healthy'),
        StatusRuleThresholdBand(level: StatusLevel.watch, label: 'Watch'),
        StatusRuleThresholdBand(level: StatusLevel.issue, label: 'Issue'),
      ],
      weight: weight,
      affectsComponentLevel: true,
      unavailableBehavior: StatusRuleAvailability.unknownWhenMissing,
      textTemplateKey: 'status.juggluco.rule.v1',
    );
  }
}
