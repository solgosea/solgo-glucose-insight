import 'dart:convert';

import '../../../domain/rule/alert_rule_scope.dart';
import '../../../domain/rule/alert_rule_set.dart';

class AlertRuleSetRowMapper {
  const AlertRuleSetRowMapper();

  Map<String, Object?> toRow(AlertRuleSet ruleSet) => {
    'id': ruleSet.id,
    'rule_set_key': ruleSet.ruleSetKey,
    'scope': ruleSet.scope.code,
    'subject_id': ruleSet.subjectId,
    'display_name': ruleSet.displayName,
    'enabled': ruleSet.enabled ? 1 : 0,
    'metadata_json': jsonEncode(ruleSet.metadata),
    'created_at': ruleSet.createdAt.toIso8601String(),
    'updated_at': ruleSet.updatedAt.toIso8601String(),
  };

  AlertRuleSet fromRow(Map<String, Object?> row) {
    return AlertRuleSet(
      id: row['id'] as String,
      ruleSetKey: row['rule_set_key'] as String,
      scope: AlertRuleScope.fromCode(row['scope'] as String? ?? ''),
      subjectId: row['subject_id'] as String?,
      displayName: row['display_name'] as String,
      enabled: (row['enabled'] as num?)?.round() == 1,
      metadata: _map(row['metadata_json']),
      createdAt: DateTime.parse(row['created_at'] as String),
      updatedAt: DateTime.parse(row['updated_at'] as String),
    );
  }

  Map<String, Object?> _map(Object? raw) {
    if (raw == null || raw.toString().trim().isEmpty) return const {};
    final decoded = jsonDecode(raw.toString());
    if (decoded is! Map) return const {};
    return decoded.map((key, value) => MapEntry(key.toString(), value));
  }
}
