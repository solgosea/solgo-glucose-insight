import '../../domain/sync_target/glucose_sync_target.dart';
import '../sync/glucose_sync_plan.dart';
import 'glucose_sync_task_priority.dart';
import 'glucose_sync_task_reason.dart';

class GlucoseSyncTask {
  final GlucoseSyncTarget target;
  final GlucoseSyncTaskPriority priority;
  final GlucoseSyncTaskReason reason;
  final DateTime dueAt;
  final int sequence;
  final GlucoseSyncPlan? explicitPlan;

  const GlucoseSyncTask({
    required this.target,
    required this.priority,
    required this.reason,
    required this.dueAt,
    required this.sequence,
    this.explicitPlan,
  });
}
