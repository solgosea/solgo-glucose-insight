import '../../domain/queue/alert_queue_message.dart';

class AlertIngressDedupeKeyBuilder {
  const AlertIngressDedupeKeyBuilder();

  String build(AlertQueueMessage message) {
    final eventId = message.alertEventId?.trim();
    if (eventId != null && eventId.isNotEmpty) {
      return '${message.messageType}:$eventId';
    }
    return [
      message.messageType,
      message.source,
      message.targetPluginId,
      message.targetId,
      message.alertType,
      message.createdAt.millisecondsSinceEpoch,
    ].whereType<String>().join(':');
  }
}
