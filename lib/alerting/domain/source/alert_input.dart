import '../queue/alert_queue_priority.dart';
import 'alert_input_origin.dart';
import 'alert_source_id.dart';

class AlertInput {
  final AlertSourceId sourceId;
  final AlertInputOrigin origin;
  final String messageType;
  final String? targetPluginId;
  final String? targetId;
  final String? subjectId;
  final String? alertEventId;
  final String? alertType;
  final AlertQueuePriority priority;
  final Map<String, Object?> payload;
  final String? dedupeKey;
  final String? canonicalSourceKey;
  final String? dedupeScope;
  final int sourcePriority;
  final DateTime? availableAt;

  const AlertInput({
    required this.sourceId,
    required this.origin,
    required this.messageType,
    this.targetPluginId,
    this.targetId,
    this.subjectId,
    this.alertEventId,
    this.alertType,
    this.priority = AlertQueuePriority.normal,
    this.payload = const {},
    this.dedupeKey,
    this.canonicalSourceKey,
    this.dedupeScope,
    this.sourcePriority = 0,
    this.availableAt,
  });
}
