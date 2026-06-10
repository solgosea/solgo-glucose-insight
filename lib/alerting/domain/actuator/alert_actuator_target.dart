import '../event/alert_event.dart';

class AlertActuatorTarget {
  final String? eventId;
  final String? targetId;
  final String? type;

  const AlertActuatorTarget({this.eventId, this.targetId, this.type});

  factory AlertActuatorTarget.fromEvent(AlertEvent event) {
    return AlertActuatorTarget(
      eventId: event.id,
      targetId: _stringValue(
        event.payload['personId'] ??
            event.payload['subjectId'] ??
            event.payload['targetId'],
      ),
      type: _normalizeType(
        event.payload['type'] ??
            event.payload['alertType'] ??
            event.payload['ruleType'] ??
            event.category.name,
      ),
    );
  }

  AlertActuatorTarget copyWith({
    String? eventId,
    String? targetId,
    String? type,
  }) {
    return AlertActuatorTarget(
      eventId: eventId ?? this.eventId,
      targetId: targetId ?? this.targetId,
      type: type ?? this.type,
    );
  }

  Map<String, Object?> toJson() => {
    'eventId': eventId,
    'targetId': targetId,
    'type': type,
  };

  static String? _stringValue(Object? raw) {
    final value = raw?.toString().trim();
    if (value == null || value.isEmpty) return null;
    return value;
  }

  static String? _normalizeType(Object? raw) {
    final value = raw?.toString().trim();
    if (value == null || value.isEmpty) return null;
    final compact =
        value
            .replaceAll('-', '_')
            .replaceAll(' ', '_')
            .replaceAll('.', '_')
            .toLowerCase();
    return switch (compact) {
      'urgent_low' || 'urgentlow' || 'glucoseurgentlow' => 'urgentLow',
      'low' || 'glucoselow' => 'low',
      'rapid_fall' || 'rapidfall' || 'glucoserapidfall' => 'rapidFall',
      'high' || 'glucosehigh' => 'high',
      'no_data' || 'nodata' => 'noData',
      _ => value,
    };
  }
}
