import '../../domain/rules/status_rule_definition.dart';
import '../rules/status_metric_rule.dart';

class StatusRuleEvaluator {
  final StatusRuleDefinition definition;
  final StatusMetricRule rule;

  const StatusRuleEvaluator({
    required this.definition,
    required this.rule,
  });
}
