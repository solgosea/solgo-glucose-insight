import '../analysis/status_rule_result.dart';
import 'status_rule_definition.dart';

class StatusRuleOutput {
  final StatusRuleDefinition definition;
  final StatusRuleResult result;

  const StatusRuleOutput({
    required this.definition,
    required this.result,
  });
}
