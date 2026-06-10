import '../../domain/event/alert_event.dart';

class AlertSoundSessionKey {
  const AlertSoundSessionKey();

  String fromEvent(AlertEvent event) {
    final personId =
        event.payload['personId'] ??
        event.payload['subjectId'] ??
        event.payload['targetId'];
    final type = _normalizedType(
      event.payload['type'] ??
          event.payload['alertType'] ??
          event.payload['ruleType'] ??
          event.category.name,
    );
    if (personId != null) return '$personId:$type';
    return event.sourceEventId ?? event.id;
  }

  Set<String> targetTypeKeys({required String targetId, required String type}) {
    final normalized = _normalizedType(type);
    final aliases = <String>{normalized, type, _categoryAlias(normalized)}
      ..removeWhere((value) => value.trim().isEmpty);
    return {for (final alias in aliases) '$targetId:$alias'};
  }

  String _normalizedType(Object? raw) {
    final value = raw?.toString().trim();
    if (value == null || value.isEmpty) return 'alert';
    final compact =
        value
            .replaceAll('-', '_')
            .replaceAll(' ', '_')
            .replaceAll('.', '_')
            .toLowerCase();
    return switch (compact) {
      'urgent_low' || 'urgentlow' || 'glucoseurgentlow' => 'urgentLow',
      'low' || 'glucoselow' => 'low',
      'rapid_fall' || 'rapidfall' => 'rapidFall',
      'high' || 'glucosehigh' => 'high',
      'no_data' || 'nodata' => 'noData',
      _ => value,
    };
  }

  String _categoryAlias(String normalized) {
    return switch (normalized) {
      'urgentLow' => 'glucoseUrgentLow',
      'low' => 'glucoseLow',
      'rapidFall' => 'glucoseLow',
      'high' => 'glucoseHigh',
      'noData' => 'noData',
      _ => normalized,
    };
  }
}
