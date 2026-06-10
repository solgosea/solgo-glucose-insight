import 'alert_category.dart';
import 'alert_event_source.dart';
import 'alert_event_state.dart';
import 'alert_level.dart';

class AlertEvent {
  final String id;
  final AlertEventSource source;
  final String? sourceEventId;
  final AlertCategory category;
  final AlertLevel level;
  final AlertEventState state;
  final String title;
  final String body;
  final Map<String, Object?> payload;
  final DateTime occurredAt;
  final DateTime receivedAt;
  final DateTime updatedAt;

  const AlertEvent({
    required this.id,
    required this.source,
    required this.sourceEventId,
    required this.category,
    required this.level,
    required this.state,
    required this.title,
    required this.body,
    required this.payload,
    required this.occurredAt,
    required this.receivedAt,
    required this.updatedAt,
  });

  AlertEvent copyWith({AlertEventState? state, DateTime? updatedAt}) {
    return AlertEvent(
      id: id,
      source: source,
      sourceEventId: sourceEventId,
      category: category,
      level: level,
      state: state ?? this.state,
      title: title,
      body: body,
      payload: payload,
      occurredAt: occurredAt,
      receivedAt: receivedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
