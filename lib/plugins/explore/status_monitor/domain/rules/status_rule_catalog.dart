import 'status_rule_definition.dart';
import 'status_rule_group.dart';

class StatusRuleCatalog {
  final StatusRuleGroup group;
  final List<StatusRuleDefinition> definitions;

  const StatusRuleCatalog({
    required this.group,
    required this.definitions,
  });
}
