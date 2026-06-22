import '../../domain/rules/status_rule_catalog.dart';
import '../../domain/rules/status_rule_definition.dart';
import 'status_rule_evaluator.dart';

class StatusRuleRegistry {
  final StatusRuleCatalog catalog;
  final List<StatusRuleEvaluator> evaluators;

  const StatusRuleRegistry({
    required this.catalog,
    required this.evaluators,
  });

  List<StatusRuleDefinition> get definitions =>
      evaluators.map((evaluator) => evaluator.definition).toList();
}
