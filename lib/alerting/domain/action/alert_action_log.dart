import 'alert_action.dart';

class AlertActionLog {
  final String id;
  final String alertEventId;
  final AlertAction action;
  final String actor;
  final String? note;
  final DateTime createdAt;

  const AlertActionLog({
    required this.id,
    required this.alertEventId,
    required this.action,
    required this.actor,
    required this.createdAt,
    this.note,
  });
}
