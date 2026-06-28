import '../glucose_sync_task_reason.dart';

enum GlucoseSyncSchedulerEventType {
  enqueued,
  started,
  skipped,
  completed,
  failed,
}

class GlucoseSyncSchedulerEvent {
  final GlucoseSyncSchedulerEventType type;
  final String targetId;
  final String subjectId;
  final GlucoseSyncTaskReason? reason;
  final DateTime at;
  final int? fetchedCount;
  final int? storedCount;
  final Object? error;

  const GlucoseSyncSchedulerEvent({
    required this.type,
    required this.targetId,
    required this.subjectId,
    required this.at,
    this.reason,
    this.fetchedCount,
    this.storedCount,
    this.error,
  });
}
