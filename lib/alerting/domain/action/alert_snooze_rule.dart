import '../event/alert_category.dart';
import '../event/alert_event_source.dart';
import '../event/alert_level.dart';

class AlertSnoozeRule {
  final String id;
  final String? alertEventId;
  final AlertEventSource? source;
  final AlertCategory? category;
  final AlertLevel? level;
  final DateTime snoozedUntil;
  final String? reason;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AlertSnoozeRule({
    required this.id,
    required this.snoozedUntil,
    required this.createdAt,
    required this.updatedAt,
    this.alertEventId,
    this.source,
    this.category,
    this.level,
    this.reason,
  });
}
