import 'package:pool/pool.dart';

import '../../../domain/entities/app_settings.dart';
import '../../sync_target/glucose_sync_target_runner.dart';
import '../limiters/glucose_sync_host_limiter.dart';
import '../limiters/glucose_sync_persistence_limiter.dart';
import '../limiters/glucose_sync_target_limiter.dart';
import '../telemetry/glucose_sync_scheduler_event.dart';
import '../telemetry/glucose_sync_scheduler_event_bus.dart';
import 'glucose_sync_worker_error.dart';
import 'glucose_sync_worker_pool_config.dart';
import 'glucose_sync_worker_result.dart';
import 'glucose_sync_worker_task.dart';

class GlucoseSyncWorkerPool {
  final GlucoseSyncTargetRunner runner;
  final GlucoseSyncTargetLimiter targetLimiter;
  final GlucoseSyncHostLimiter hostLimiter;
  final GlucoseSyncPersistenceLimiter persistenceLimiter;
  final GlucoseSyncWorkerPoolConfig config;
  final GlucoseSyncSchedulerEventBus? eventBus;
  late final Pool _globalPool;

  GlucoseSyncWorkerPool({
    required this.runner,
    required this.targetLimiter,
    required this.hostLimiter,
    required this.persistenceLimiter,
    this.config = const GlucoseSyncWorkerPoolConfig(),
    this.eventBus,
  }) {
    final normalized = config.normalized();
    _globalPool = Pool(normalized.globalConcurrency);
  }

  Future<List<GlucoseSyncWorkerResult>> runAll({
    required List<GlucoseSyncWorkerTask> tasks,
    required AppSettings settings,
    required DateTime Function() now,
  }) {
    return Future.wait(
      tasks.map((task) {
        return _globalPool.withResource(
          () => _runOne(task: task, settings: settings, now: now),
        );
      }),
    );
  }

  Future<GlucoseSyncWorkerResult> _runOne({
    required GlucoseSyncWorkerTask task,
    required AppSettings settings,
    required DateTime Function() now,
  }) async {
    final syncTask = task.task;
    final target = syncTask.target;
    final result = await targetLimiter.run(target.targetId, () async {
      eventBus?.publish(
        GlucoseSyncSchedulerEvent(
          type: GlucoseSyncSchedulerEventType.started,
          targetId: target.targetId,
          subjectId: target.subjectId,
          reason: syncTask.reason,
          at: now(),
        ),
      );
      try {
        final syncResult = await hostLimiter.run(
          target,
          () => runner.run(
            target: target,
            settings: settings,
            persistenceLimiter: persistenceLimiter,
            explicitPlan: syncTask.explicitPlan,
          ),
        );
        eventBus?.publish(
          GlucoseSyncSchedulerEvent(
            type: syncResult.success
                ? GlucoseSyncSchedulerEventType.completed
                : GlucoseSyncSchedulerEventType.failed,
            targetId: target.targetId,
            subjectId: target.subjectId,
            reason: syncTask.reason,
            at: now(),
            fetchedCount: syncResult.fetchedCount,
            storedCount: syncResult.storedCount,
            error: syncResult.error,
          ),
        );
        return GlucoseSyncWorkerResult.completed(
          targetId: target.targetId,
          result: syncResult,
        );
      } catch (error, stackTrace) {
        eventBus?.publish(
          GlucoseSyncSchedulerEvent(
            type: GlucoseSyncSchedulerEventType.failed,
            targetId: target.targetId,
            subjectId: target.subjectId,
            reason: syncTask.reason,
            at: now(),
            error: error,
          ),
        );
        return GlucoseSyncWorkerResult.failed(
          targetId: target.targetId,
          error: GlucoseSyncWorkerError(
            targetId: target.targetId,
            error: error,
            stackTrace: stackTrace,
          ),
        );
      }
    });

    if (result == null) {
      eventBus?.publish(
        GlucoseSyncSchedulerEvent(
          type: GlucoseSyncSchedulerEventType.skipped,
          targetId: target.targetId,
          subjectId: target.subjectId,
          reason: syncTask.reason,
          at: now(),
        ),
      );
      return GlucoseSyncWorkerResult.skipped(targetId: target.targetId);
    }
    return result;
  }

  Future<void> close() => _globalPool.close();
}
