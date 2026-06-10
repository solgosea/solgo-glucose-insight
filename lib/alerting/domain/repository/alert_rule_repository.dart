import '../rule/alert_rule.dart';
import '../rule/alert_rule_set.dart';

abstract interface class AlertRuleRepository {
  Future<AlertRuleSet?> ruleSetByKey(String ruleSetKey, {String? subjectId});

  Future<List<AlertRule>> rulesForSet(String ruleSetId);

  Future<void> upsertRuleSet(AlertRuleSet ruleSet);

  Future<void> upsertRules(List<AlertRule> rules);
}
