import 'alert_queue_message_state.dart';
import 'alert_queue_priority.dart';

class AlertQueueMessage {
  final String id;
  final String dedupeKey;
  final String messageType;
  final String source;
  final String? targetPluginId;
  final String? targetId;
  final String? subjectId;
  final String? alertEventId;
  final String? alertType;
  final String? canonicalSourceKey;
  final String? dedupeScope;
  final int sourcePriority;
  final AlertQueuePriority priority;
  final Map<String, Object?> payload;
  final AlertQueueMessageState state;
  final int attemptCount;
  final DateTime availableAt;
  final DateTime? lockedAt;
  final DateTime? processedAt;
  final String? failedReason;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AlertQueueMessage({
    required this.id,
    required this.dedupeKey,
    required this.messageType,
    required this.source,
    this.targetPluginId,
    this.targetId,
    this.subjectId,
    this.alertEventId,
    this.alertType,
    this.canonicalSourceKey,
    this.dedupeScope,
    this.sourcePriority = 0,
    this.priority = AlertQueuePriority.normal,
    this.payload = const {},
    this.state = AlertQueueMessageState.pending,
    this.attemptCount = 0,
    required this.availableAt,
    this.lockedAt,
    this.processedAt,
    this.failedReason,
    required this.createdAt,
    required this.updatedAt,
  });

  AlertQueueMessage copyWith({
    AlertQueueMessageState? state,
    int? attemptCount,
    DateTime? availableAt,
    DateTime? lockedAt,
    DateTime? processedAt,
    String? failedReason,
    DateTime? updatedAt,
  }) {
    return AlertQueueMessage(
      id: id,
      dedupeKey: dedupeKey,
      messageType: messageType,
      source: source,
      targetPluginId: targetPluginId,
      targetId: targetId,
      subjectId: subjectId,
      alertEventId: alertEventId,
      alertType: alertType,
      canonicalSourceKey: canonicalSourceKey,
      dedupeScope: dedupeScope,
      sourcePriority: sourcePriority,
      priority: priority,
      payload: payload,
      state: state ?? this.state,
      attemptCount: attemptCount ?? this.attemptCount,
      availableAt: availableAt ?? this.availableAt,
      lockedAt: lockedAt ?? this.lockedAt,
      processedAt: processedAt ?? this.processedAt,
      failedReason: failedReason ?? this.failedReason,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
