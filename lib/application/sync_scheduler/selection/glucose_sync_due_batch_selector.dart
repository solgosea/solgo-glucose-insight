import '../glucose_sync_task.dart';
import '../glucose_sync_task_queue.dart';

class GlucoseSyncDueBatchSelector {
  const GlucoseSyncDueBatchSelector();

  List<GlucoseSyncTask> select({
    required GlucoseSyncTaskQueue queue,
    required DateTime now,
    required int limit,
  }) {
    return queue.dueBatch(now, limit: limit);
  }
}
