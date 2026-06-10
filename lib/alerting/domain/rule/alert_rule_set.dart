import 'alert_rule_scope.dart';

class AlertRuleSet {
  final String id;
  final String ruleSetKey;
  final AlertRuleScope scope;
  final String? subjectId;
  final String displayName;
  final bool enabled;
  final Map<String, Object?> metadata;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AlertRuleSet({
    required this.id,
    required this.ruleSetKey,
    required this.scope,
    this.subjectId,
    required this.displayName,
    required this.enabled,
    this.metadata = const {},
    required this.createdAt,
    required this.updatedAt,
  });
}
