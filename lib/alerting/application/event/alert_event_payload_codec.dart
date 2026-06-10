import '../../domain/event/alert_category.dart';
import '../../domain/event/alert_event.dart';
import '../../domain/event/alert_event_source.dart';
import '../../domain/event/alert_event_state.dart';
import '../../domain/event/alert_level.dart';

class AlertEventPayloadCodec {
  const AlertEventPayloadCodec();

  Map<String, Object?> encode(AlertEvent event) {
    return {
      'id': event.id,
      'source': event.source.code,
      'sourceEventId': event.sourceEventId,
      'category': event.category.code,
      'level': event.level.code,
      'state': event.state.code,
      'title': event.title,
      'body': event.body,
      'payload': event.payload,
      'occurredAtMs': event.occurredAt.millisecondsSinceEpoch,
      'receivedAtMs': event.receivedAt.millisecondsSinceEpoch,
      'updatedAtMs': event.updatedAt.millisecondsSinceEpoch,
    };
  }

  AlertEvent decode(Map<String, Object?> payload) {
    final raw = payload['event'];
    if (raw is! Map) {
      throw const FormatException('Alert event payload is missing.');
    }
    final json = raw.map((key, value) => MapEntry(key.toString(), value));
    final nestedPayload = json['payload'];
    return AlertEvent(
      id: _string(json['id']) ?? '',
      source: AlertEventSource.fromCode(_string(json['source']) ?? ''),
      sourceEventId: _string(json['sourceEventId']),
      category: AlertCategory.fromCode(_string(json['category']) ?? ''),
      level: AlertLevel.fromCode(_string(json['level']) ?? ''),
      state: AlertEventState.fromCode(_string(json['state']) ?? ''),
      title: _string(json['title']) ?? '',
      body: _string(json['body']) ?? '',
      payload:
          nestedPayload is Map
              ? nestedPayload.map(
                (key, value) => MapEntry(key.toString(), value),
              )
              : const {},
      occurredAt: _time(json['occurredAtMs']) ?? DateTime.now(),
      receivedAt: _time(json['receivedAtMs']) ?? DateTime.now(),
      updatedAt: _time(json['updatedAtMs']) ?? DateTime.now(),
    );
  }

  DateTime? _time(Object? value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is num) {
      return DateTime.fromMillisecondsSinceEpoch(value.round());
    }
    return DateTime.tryParse(value.toString());
  }

  String? _string(Object? value) {
    if (value == null) return null;
    final text = value.toString().trim();
    return text.isEmpty ? null : text;
  }
}
