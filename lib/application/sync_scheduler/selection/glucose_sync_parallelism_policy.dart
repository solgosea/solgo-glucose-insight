import '../glucose_sync_task_priority.dart';
import '../worker_pool/glucose_sync_worker_pool_config.dart';

class GlucoseSyncParallelismPolicy {
  final GlucoseSyncWorkerPoolConfig config;

  const GlucoseSyncParallelismPolicy({
    this.config = const GlucoseSyncWorkerPoolConfig(),
  });

  int batchLimitFor(GlucoseSyncTaskPriority priority) {
    final normalized = config.normalized();
    return switch (priority) {
      GlucoseSyncTaskPriority.manual => normalized.globalConcurrency,
      GlucoseSyncTaskPriority.setup => normalized.globalConcurrency,
      GlucoseSyncTaskPriority.foreground => normalized.globalConcurrency,
      GlucoseSyncTaskPriority.background =>
        normalized.globalConcurrency > 1 ? normalized.globalConcurrency - 1 : 1,
    };
  }
}
