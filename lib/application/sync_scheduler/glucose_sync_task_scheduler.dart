import '../../domain/entities/app_settings.dart';
import '../../domain/sync_target/glucose_sync_target.dart';
import '../sync/glucose_sync_plan.dart';
import '../sync/glucose_sync_result.dart';
import '../sync_target/glucose_sync_target_runner.dart';
import 'glucose_sync_backoff_policy.dart';
import 'glucose_sync_scheduler_result.dart';
import 'glucose_sync_target_lease_registry.dart';
import 'glucose_sync_task.dart';
import 'glucose_sync_task_priority.dart';
import 'glucose_sync_task_queue.dart';
import 'glucose_sync_task_reason.dart';
import 'limiters/glucose_sync_host_limiter.dart';
import 'limiters/glucose_sync_persistence_limiter.dart';
import 'limiters/glucose_sync_target_limiter.dart';
import 'selection/glucose_sync_due_batch_selector.dart';
import 'selection/glucose_sync_fair_target_selector.dart';
import 'selection/glucose_sync_parallelism_policy.dart';
import 'telemetry/glucose_sync_scheduler_event.dart';
import 'telemetry/glucose_sync_scheduler_event_bus.dart';
import 'worker_pool/glucose_sync_worker_pool.dart';
import 'worker_pool/glucose_sync_worker_pool_config.dart';
import 'worker_pool/glucose_sync_worker_task.dart';

class GlucoseSyncTaskScheduler {
  final GlucoseSyncTargetRunner runner;
  final GlucoseSyncTargetLeaseRegistry leases;
  final GlucoseSyncBackoffPolicy backoffPolicy;
  final GlucoseSyncWorkerPoolConfig workerPoolConfig;
  final GlucoseSyncHostLimiter hostLimiter;
  final GlucoseSyncPersistenceLimiter persistenceLimiter;
  final GlucoseSyncDueBatchSelector dueBatchSelector;
  final GlucoseSyncFairTargetSelector fairTargetSelector;
  final GlucoseSyncParallelismPolicy parallelismPolicy;
  final GlucoseSyncSchedulerEventBus? eventBus;
  final DateTime Function() now;
  final GlucoseSyncTaskQueue _queue = GlucoseSyncTaskQueue();
  final Map<String, DateTime> _nextDueByTarget = <String, DateTime>{};
  Future<GlucoseSyncSchedulerResult>? _draining;
  int _sequence = 0;

  GlucoseSyncTaskScheduler({
    required this.runner,
    GlucoseSyncTargetLeaseRegistry? leases,
    this.backoffPolicy = const GlucoseSyncBackoffPolicy(),
    GlucoseSyncWorkerPoolConfig workerPoolConfig =
        const GlucoseSyncWorkerPoolConfig(),
    GlucoseSyncHostLimiter? hostLimiter,
    GlucoseSyncPersistenceLimiter? persistenceLimiter,
    this.dueBatchSelector = const GlucoseSyncDueBatchSelector(),
    this.fairTargetSelector = const GlucoseSyncFairTargetSelector(),
    GlucoseSyncParallelismPolicy? parallelismPolicy,
    this.eventBus,
    DateTime Function()? now,
  })  : leases = leases ?? GlucoseSyncTargetLeaseRegistry(),
        workerPoolConfig = workerPoolConfig.normalized(),
        hostLimiter = hostLimiter ??
            GlucoseSyncHostLimiter(
              perHostConcurrency:
                  workerPoolConfig.normalized().perHostConcurrency,
            ),
        persistenceLimiter = persistenceLimiter ??
            GlucoseSyncPersistenceLimiter(
              concurrency: workerPoolConfig.normalized().persistenceConcurrency,
            ),
        parallelismPolicy = parallelismPolicy ??
            GlucoseSyncParallelismPolicy(
              config: workerPoolConfig.normalized(),
            ),
        now = now ?? DateTime.now;

  void enqueueTarget(
    GlucoseSyncTarget target, {
    GlucoseSyncTaskPriority priority = GlucoseSyncTaskPriority.foreground,
    GlucoseSyncTaskReason reason = GlucoseSyncTaskReason.foreground,
    GlucoseSyncPlan? explicitPlan,
  }) {
    final current = now();
    final backoffDue = _nextDueByTarget[target.targetId];
    final dueAt = priority == GlucoseSyncTaskPriority.manual ||
            priority == GlucoseSyncTaskPriority.setup
        ? current
        : backoffDue != null && backoffDue.isAfter(current)
            ? backoffDue
            : current;
    final task = GlucoseSyncTask(
      target: target,
      priority: priority,
      reason: reason,
      dueAt: dueAt,
      sequence: _sequence++,
      explicitPlan: explicitPlan,
    );
    _queue.add(task);
    eventBus?.publish(
      GlucoseSyncSchedulerEvent(
        type: GlucoseSyncSchedulerEventType.enqueued,
        targetId: target.targetId,
        subjectId: target.subjectId,
        reason: reason,
        at: current,
      ),
    );
  }

  void enqueueAll(
    Iterable<GlucoseSyncTarget> targets, {
    GlucoseSyncTaskPriority priority = GlucoseSyncTaskPriority.foreground,
    GlucoseSyncTaskReason reason = GlucoseSyncTaskReason.foreground,
    GlucoseSyncPlan? explicitPlan,
  }) {
    for (final target in targets) {
      enqueueTarget(
        target,
        priority: priority,
        reason: reason,
        explicitPlan: explicitPlan,
      );
    }
  }

  Future<GlucoseSyncSchedulerResult> drain({
    required AppSettings settings,
  }) {
    final activeDrain = _draining;
    if (activeDrain != null) return activeDrain;
    final nextDrain = _drainInternal(settings: settings);
    _draining = nextDrain;
    return nextDrain.whenComplete(() {
      if (identical(_draining, nextDrain)) {
        _draining = null;
      }
    });
  }

  Future<GlucoseSyncSchedulerResult> _drainInternal({
    required AppSettings settings,
  }) async {
    final results = <GlucoseSyncResult>[];
    var skippedCount = 0;
    var failedCount = 0;
    final pool = GlucoseSyncWorkerPool(
      runner: runner,
      targetLimiter: GlucoseSyncTargetLimiter(leases: leases),
      hostLimiter: hostLimiter,
      persistenceLimiter: persistenceLimiter,
      config: workerPoolConfig,
      eventBus: eventBus,
    );
    try {
      while (!_queue.isEmpty) {
        final current = now();
        final first = _queue.nextDue(current);
        if (first == null) break;
        final limit = parallelismPolicy.batchLimitFor(first.priority);
        final additionalLimit =
            (limit - 1).clamp(0, workerPoolConfig.maxBatchSize).toInt();
        final additional = dueBatchSelector.select(
          queue: _queue,
          now: current,
          limit: additionalLimit,
        );
        final batch = fairTargetSelector.order([first, ...additional]);
        final workerResults = await pool.runAll(
          tasks: [
            for (final task in batch) GlucoseSyncWorkerTask(task: task),
          ],
          settings: settings,
          now: now,
        );
        for (final workerResult in workerResults) {
          if (workerResult.skipped) {
            skippedCount++;
            continue;
          }
          if (workerResult.error != null) {
            failedCount++;
            continue;
          }
          final result = workerResult.result;
          if (result == null) continue;
          results.add(result);
          if (!result.success) {
            failedCount++;
          }
          final delay = backoffPolicy.delayFor(result);
          if (delay == Duration.zero) {
            _nextDueByTarget.remove(workerResult.targetId);
          } else {
            _nextDueByTarget[workerResult.targetId] = now().add(delay);
          }
        }
      }
    } finally {
      await pool.close();
    }
    return GlucoseSyncSchedulerResult(
      results: results,
      skippedCount: skippedCount,
      runningCount: leases.activeTargetIds().length,
      failedCount: failedCount,
    );
  }
}
