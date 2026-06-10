import 'dart:convert';

import '../../../domain/channel/alert_channel.dart';
import '../../../domain/event/alert_category.dart';
import '../../../domain/event/alert_level.dart';
import '../../../domain/rule/alert_rule.dart';
import '../../../domain/rule/alert_rule_comparator.dart';
import '../../../domain/sound/alert_sound_playback_policy.dart';

class AlertRuleRowMapper {
  const AlertRuleRowMapper();

  Map<String, Object?> toRow(AlertRule rule) => {
    'id': rule.id,
    'rule_set_id': rule.ruleSetId,
    'category': rule.category.code,
    'enabled': rule.enabled ? 1 : 0,
    'comparator': rule.comparator.code,
    'threshold_value': rule.thresholdValue,
    'threshold_unit': rule.thresholdUnit,
    'level': rule.level.code,
    'channels_json': jsonEncode(
      rule.channels.map((channel) => channel.code).toList(),
    ),
    'sound_policy_json':
        rule.soundPolicy == null
            ? null
            : jsonEncode(rule.soundPolicy!.toJson()),
    'repeat_minutes': rule.repeatMinutes,
    'priority': rule.priority,
    'metadata_json': jsonEncode(rule.metadata),
    'created_at': rule.createdAt.toIso8601String(),
    'updated_at': rule.updatedAt.toIso8601String(),
  };

  AlertRule fromRow(Map<String, Object?> row) {
    return AlertRule(
      id: row['id'] as String,
      ruleSetId: row['rule_set_id'] as String,
      category: AlertCategory.fromCode(row['category'] as String? ?? ''),
      enabled: (row['enabled'] as num?)?.round() == 1,
      comparator: AlertRuleComparator.fromCode(
        row['comparator'] as String? ?? '',
      ),
      thresholdValue: (row['threshold_value'] as num?)?.toDouble(),
      thresholdUnit: row['threshold_unit'] as String?,
      level: AlertLevel.fromCode(row['level'] as String? ?? ''),
      channels: _channels(row['channels_json']),
      soundPolicy: _soundPolicy(row['sound_policy_json']),
      repeatMinutes: (row['repeat_minutes'] as num?)?.round() ?? 0,
      priority: (row['priority'] as num?)?.round() ?? 0,
      metadata: _map(row['metadata_json']),
      createdAt: DateTime.parse(row['created_at'] as String),
      updatedAt: DateTime.parse(row['updated_at'] as String),
    );
  }

  Set<AlertChannel> _channels(Object? raw) {
    if (raw == null) return const {};
    final decoded = jsonDecode(raw.toString());
    if (decoded is! Iterable) return const {};
    return decoded
        .map((value) => AlertChannel.fromCode(value.toString()))
        .toSet();
  }

  AlertSoundPlaybackPolicy? _soundPolicy(Object? raw) {
    if (raw == null || raw.toString().trim().isEmpty) return null;
    final decoded = jsonDecode(raw.toString());
    if (decoded is! Map) return null;
    return AlertSoundPlaybackPolicy.fromJson(
      decoded.map((key, value) => MapEntry(key.toString(), value)),
    );
  }

  Map<String, Object?> _map(Object? raw) {
    if (raw == null || raw.toString().trim().isEmpty) return const {};
    final decoded = jsonDecode(raw.toString());
    if (decoded is! Map) return const {};
    return decoded.map((key, value) => MapEntry(key.toString(), value));
  }
}
