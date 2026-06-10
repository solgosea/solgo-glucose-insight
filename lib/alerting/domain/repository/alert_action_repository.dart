import '../action/alert_action.dart';

abstract class AlertActionRepository {
  Future<void> insertAction({
    required String alertEventId,
    required AlertAction action,
    required String actor,
    String? note,
  });

  Future<void> insertSnooze({
    required String alertEventId,
    required DateTime snoozedUntil,
    String? targetId,
    String? alertType,
    String? source,
    String? category,
    String? level,
    String? reason,
  });

  Future<DateTime?> activeSnoozeUntil({
    required String targetId,
    required String alertType,
    required DateTime now,
  });
}
