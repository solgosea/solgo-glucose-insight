import '../analysis/status_rule_id.dart';
import '../status_component_kind.dart';
import 'status_rule_availability.dart';
import 'status_rule_input_requirement.dart';
import 'status_rule_threshold_band.dart';

class StatusRuleDefinition {
  final StatusRuleId ruleId;
  final StatusComponentKind componentKind;
  final String metricId;
  final List<StatusRuleInputRequirement> inputRequirements;
  final List<StatusRuleThresholdBand> thresholdBands;
  final double weight;
  final bool affectsComponentLevel;
  final StatusRuleAvailability unavailableBehavior;
  final String textTemplateKey;

  const StatusRuleDefinition({
    required this.ruleId,
    required this.componentKind,
    required this.metricId,
    required this.inputRequirements,
    required this.thresholdBands,
    required this.weight,
    required this.affectsComponentLevel,
    required this.unavailableBehavior,
    required this.textTemplateKey,
  });
}
