import 'dart:convert';

import '../../../domain/queue/alert_queue_message.dart';
import '../../../domain/queue/alert_queue_message_state.dart';
import '../../../domain/queue/alert_queue_priority.dart';

class AlertQueueRowMapper {
  const AlertQueueRowMapper();

  Map<String, Object?> toRow(AlertQueueMessage message) => {
    'id': message.id,
    'dedupe_key': message.dedupeKey,
    'message_type': message.messageType,
    'source': message.source,
    'target_plugin_id': message.targetPluginId,
    'target_id': message.targetId,
    'subject_id': message.subjectId,
    'alert_event_id': message.alertEventId,
    'alert_type': message.alertType,
    'canonical_source_key': message.canonicalSourceKey,
    'dedupe_scope': message.dedupeScope,
    'source_priority': message.sourcePriority,
    'priority': message.priority.code,
    'payload_json': jsonEncode(message.payload),
    'state': message.state.code,
    'attempt_count': message.attemptCount,
    'available_at_ms': message.availableAt.millisecondsSinceEpoch,
    'locked_at_ms': message.lockedAt?.millisecondsSinceEpoch,
    'processed_at_ms': message.processedAt?.millisecondsSinceEpoch,
    'failed_reason': message.failedReason,
    'created_at_ms': message.createdAt.millisecondsSinceEpoch,
    'updated_at_ms': message.updatedAt.millisecondsSinceEpoch,
  };

  AlertQueueMessage fromRow(Map<String, Object?> row) {
    return AlertQueueMessage(
      id: row['id'] as String,
      dedupeKey: row['dedupe_key'] as String,
      messageType: row['message_type'] as String,
      source: row['source'] as String,
      targetPluginId: row['target_plugin_id'] as String?,
      targetId: row['target_id'] as String?,
      subjectId: row['subject_id'] as String?,
      alertEventId: row['alert_event_id'] as String?,
      alertType: row['alert_type'] as String?,
      canonicalSourceKey: row['canonical_source_key'] as String?,
      dedupeScope: row['dedupe_scope'] as String?,
      sourcePriority: (row['source_priority'] as num?)?.round() ?? 0,
      priority: AlertQueuePriority.fromCode(row['priority'] as String? ?? ''),
      payload: _payload(row['payload_json']),
      state: AlertQueueMessageState.fromCode(row['state'] as String? ?? ''),
      attemptCount: (row['attempt_count'] as num?)?.round() ?? 0,
      availableAt: _time(row['available_at_ms']) ?? DateTime.now(),
      lockedAt: _time(row['locked_at_ms']),
      processedAt: _time(row['processed_at_ms']),
      failedReason: row['failed_reason'] as String?,
      createdAt: _time(row['created_at_ms']) ?? DateTime.now(),
      updatedAt: _time(row['updated_at_ms']) ?? DateTime.now(),
    );
  }

  Map<String, Object?> _payload(Object? raw) {
    if (raw == null) return const {};
    final decoded = jsonDecode(raw.toString());
    if (decoded is! Map) return const {};
    return decoded.map((key, value) => MapEntry(key.toString(), value));
  }

  DateTime? _time(Object? raw) {
    if (raw == null) return null;
    if (raw is int) return DateTime.fromMillisecondsSinceEpoch(raw);
    if (raw is num) return DateTime.fromMillisecondsSinceEpoch(raw.round());
    return int.tryParse(raw.toString()) == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(int.parse(raw.toString()));
  }
}
