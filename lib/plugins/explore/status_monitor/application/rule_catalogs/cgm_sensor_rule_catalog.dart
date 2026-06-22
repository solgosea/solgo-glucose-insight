import '../../domain/analysis/status_rule_id.dart';
import '../../domain/rules/status_rule_availability.dart';
import '../../domain/rules/status_rule_catalog.dart';
import '../../domain/rules/status_rule_definition.dart';
import '../../domain/rules/status_rule_group.dart';
import '../../domain/rules/status_rule_input_requirement.dart';
import '../../domain/rules/status_rule_threshold_band.dart';
import '../../domain/status_component_kind.dart';
import '../../domain/status_level.dart';
import '../engines/cgm_sensor/cgm_sensor_metric_ids.dart';
import '../rule_engine/status_rule_evaluator.dart';
import '../rule_engine/status_rule_registry.dart';
import '../rules/cgm/cgm_cv_rule.dart';
import '../rules/cgm/cgm_sensor_freshness_rule.dart';
import '../rules/cgm/cgm_signal_continuity_rule.dart';
import '../rules/cgm/flat_line_rule.dart';
import '../rules/cgm/sensor_lifetime_rule.dart';
import '../rules/cgm/sudden_changes_rule.dart';

class CgmSensorRuleCatalog {
  const CgmSensorRuleCatalog();

  StatusRuleRegistry build() {
    final evaluators = [
      StatusRuleEvaluator(
        definition: _definition(
          ruleId: 'cgm.sensor_freshness',
          metricId: CgmSensorMetricIds.sensorFreshness,
          weight: 20,
          inputs: const [
            StatusRuleInputRequirement.currentSource,
            StatusRuleInputRequirement.readings,
          ],
          textTemplateKey: 'status.cgm.rule.freshness.v1',
        ),
        rule: const CgmSensorFreshnessRule(),
      ),
      StatusRuleEvaluator(
        definition: _definition(
          ruleId: 'cgm.signal_continuity',
          metricId: CgmSensorMetricIds.signalContinuity,
          weight: 25,
          inputs: const [StatusRuleInputRequirement.readings],
          textTemplateKey: 'status.cgm.rule.continuity.v1',
        ),
        rule: const CgmSignalContinuityRule(),
      ),
      StatusRuleEvaluator(
        definition: _definition(
          ruleId: 'cgm.cv_24h',
          metricId: CgmSensorMetricIds.cv24h,
          weight: 20,
          inputs: const [StatusRuleInputRequirement.readings],
          textTemplateKey: 'status.cgm.rule.cv.v1',
          affectsComponentLevel: false,
        ),
        rule: const CgmCvRule(),
      ),
      StatusRuleEvaluator(
        definition: _definition(
          ruleId: 'cgm.sudden_changes_24h',
          metricId: CgmSensorMetricIds.suddenChanges24h,
          weight: 15,
          inputs: const [StatusRuleInputRequirement.readings],
          textTemplateKey: 'status.cgm.rule.sudden_jumps.v1',
          affectsComponentLevel: false,
        ),
        rule: const SuddenChangesRule(),
      ),
      StatusRuleEvaluator(
        definition: _definition(
          ruleId: 'cgm.flat_line_periods',
          metricId: CgmSensorMetricIds.flatLinePeriods,
          weight: 10,
          inputs: const [StatusRuleInputRequirement.readings],
          textTemplateKey: 'status.cgm.rule.flat_periods.v1',
          affectsComponentLevel: false,
        ),
        rule: const FlatLineRule(),
      ),
      StatusRuleEvaluator(
        definition: _definition(
          ruleId: 'cgm.sensor_lifetime',
          metricId: CgmSensorMetricIds.sensorLifetime,
          weight: 10,
          inputs: const [StatusRuleInputRequirement.sensorContext],
          textTemplateKey: 'status.cgm.rule.sensor_context.v1',
          affectsComponentLevel: false,
        ),
        rule: const SensorLifetimeRule(),
      ),
    ];
    return StatusRuleRegistry(
      catalog: StatusRuleCatalog(
        group: StatusRuleGroup.cgmSensor,
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
    bool affectsComponentLevel = true,
  }) {
    return StatusRuleDefinition(
      ruleId: StatusRuleId(ruleId),
      componentKind: StatusComponentKind.cgmSensor,
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
      affectsComponentLevel: affectsComponentLevel,
      unavailableBehavior: StatusRuleAvailability.unknownWhenMissing,
      textTemplateKey: textTemplateKey,
    );
  }
}
