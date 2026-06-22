import '../../domain/analysis/status_rule_result.dart';
import '../../domain/rules/status_rule_definition.dart';

class StatusRuleResultNormalizer {
  const StatusRuleResultNormalizer();

  StatusRuleResult normalize({
    required StatusRuleDefinition definition,
    required StatusRuleResult result,
  }) {
    assert(
      result.ruleId.value == definition.ruleId.value,
      'Rule ${definition.ruleId.value} returned ${result.ruleId.value}.',
    );
    assert(
      result.metric.id == definition.metricId,
      'Rule ${definition.ruleId.value} returned metric ${result.metric.id}.',
    );
    return result.copyWith(
      affectsComponentLevel: definition.affectsComponentLevel,
    );
  }
}
