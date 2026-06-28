import '../../domain/analysis/status_rule_id.dart';
import '../../domain/rules/status_rule_availability.dart';
import '../../domain/rules/status_rule_catalog.dart';
import '../../domain/rules/status_rule_definition.dart';
import '../../domain/rules/status_rule_group.dart';
import '../../domain/rules/status_rule_input_requirement.dart';
import '../../domain/rules/status_rule_threshold_band.dart';
import '../../domain/status_component_kind.dart';
import '../../domain/status_level.dart';
import '../engines/aaps/aaps_metric_ids.dart';
import '../rule_engine/status_rule_evaluator.dart';
import '../rule_engine/status_rule_registry.dart';
import '../rules/aaps/aaps_iob_cob_context_rule.dart';
import '../rules/aaps/aaps_loop_context_rule.dart';
import '../rules/aaps/aaps_nightscout_dependency_rule.dart';
import '../rules/aaps/aaps_profile_context_rule.dart';
import '../rules/aaps/aaps_pump_context_rule.dart';
import '../rules/aaps/aaps_sync_freshness_rule.dart';
import '../rules/aaps/aaps_xdrip_bg_source_rule.dart';

class AapsRuleCatalog {
  const AapsRuleCatalog();

  StatusRuleRegistry build() {
    final evaluators = [
      StatusRuleEvaluator(
        definition: _definition(
          ruleId: 'aaps.xdrip_bg_source',
          metricId: AapsMetricIds.xdripBgSource,
          weight: 45,
          textTemplateKey: 'status.aaps.rule.xdrip_bg_source.available.v1',
          inputRequirements: const [
            StatusRuleInputRequirement.localBroadcast,
          ],
        ),
        rule: const AapsXdripBgSourceRule(),
      ),
      StatusRuleEvaluator(
        definition: _definition(
          ruleId: 'aaps.sync_freshness',
          metricId: AapsMetricIds.syncFreshness,
          weight: 15,
          textTemplateKey: 'status.aaps.rule.sync_freshness.available.v1',
        ),
        rule: const AapsSyncFreshnessRule(),
      ),
      StatusRuleEvaluator(
        definition: _definition(
          ruleId: 'aaps.loop_context',
          metricId: AapsMetricIds.loopContext,
          weight: 20,
          textTemplateKey: 'status.aaps.rule.loop_context.available.v1',
        ),
        rule: const AapsLoopContextRule(),
      ),
      StatusRuleEvaluator(
        definition: _definition(
          ruleId: 'aaps.pump_context',
          metricId: AapsMetricIds.pumpContext,
          weight: 8,
          textTemplateKey: 'status.aaps.rule.pump_context.available.v1',
        ),
        rule: const AapsPumpContextRule(),
      ),
      StatusRuleEvaluator(
        definition: _definition(
          ruleId: 'aaps.iob_cob_context',
          metricId: AapsMetricIds.iobCobContext,
          weight: 4,
          textTemplateKey: 'status.aaps.rule.iob_cob_context.available.v1',
        ),
        rule: const AapsIobCobContextRule(),
      ),
      StatusRuleEvaluator(
        definition: _definition(
          ruleId: 'aaps.profile_context',
          metricId: AapsMetricIds.profileContext,
          weight: 3,
          textTemplateKey: 'status.aaps.rule.profile_context.available.v1',
        ),
        rule: const AapsProfileContextRule(),
      ),
      StatusRuleEvaluator(
        definition: _definition(
          ruleId: 'aaps.nightscout_dependency',
          metricId: AapsMetricIds.nightscoutDependency,
          weight: 5,
          textTemplateKey:
              'status.aaps.rule.nightscout_dependency.available.v1',
        ),
        rule: const AapsNightscoutDependencyRule(),
      ),
    ];
    return StatusRuleRegistry(
      catalog: StatusRuleCatalog(
        group: StatusRuleGroup.aaps,
        definitions: evaluators.map((entry) => entry.definition).toList(),
      ),
      evaluators: evaluators,
    );
  }

  StatusRuleDefinition _definition({
    required String ruleId,
    required String metricId,
    required double weight,
    required String textTemplateKey,
    List<StatusRuleInputRequirement> inputRequirements = const [
      StatusRuleInputRequirement.deviceStatus,
    ],
  }) {
    return StatusRuleDefinition(
      ruleId: StatusRuleId(ruleId),
      componentKind: StatusComponentKind.aapsLoop,
      metricId: metricId,
      inputRequirements: inputRequirements,
      thresholdBands: const [
        StatusRuleThresholdBand(level: StatusLevel.healthy, label: 'Healthy'),
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
