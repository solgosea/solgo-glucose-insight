import '../../domain/repository/alert_rule_repository.dart';
import '../../domain/rule/alert_rule.dart';
import '../../domain/rule/alert_rule_set.dart';
import 'alert_rule_defaults.dart';

class AlertRuleProvider {
  final AlertRuleRepository repository;
  final AlertRuleDefaults defaults;
  final DateTime Function() clock;

  const AlertRuleProvider({
    required this.repository,
    this.defaults = const AlertRuleDefaults(),
    DateTime Function()? clock,
  }) : clock = clock ?? DateTime.now;

  Future<List<AlertRule>> selfDefaultRules(String subjectId) async {
    final ruleSet = await _ensureSelfDefaultRuleSet(subjectId);
    if (!ruleSet.enabled) return const [];
    return repository.rulesForSet(ruleSet.id);
  }

  Future<AlertRuleSet> _ensureSelfDefaultRuleSet(String subjectId) async {
    final existing = await repository.ruleSetByKey(
      AlertRuleDefaults.selfDefaultRuleSetKey,
      subjectId: subjectId,
    );
    if (existing != null) {
      final existingRules = await repository.rulesForSet(existing.id);
      if (existingRules.isEmpty) {
        await repository.upsertRules(
          defaults.selfDefaultRules(ruleSetId: existing.id, now: clock()),
        );
      }
      return existing;
    }
    final now = clock();
    final ruleSet = defaults.selfDefaultRuleSet(subjectId: subjectId, now: now);
    await repository.upsertRuleSet(ruleSet);
    await repository.upsertRules(
      defaults.selfDefaultRules(ruleSetId: ruleSet.id, now: now),
    );
    return ruleSet;
  }
}
