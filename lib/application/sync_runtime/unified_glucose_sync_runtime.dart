import '../sync_orchestration/glucose_source_sync_result.dart';
import '../sync/glucose_sync_result.dart';
import '../sync/glucose_sync_plan.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/sync_target/glucose_sync_target.dart';
import 'unified_sync_run_result.dart';

typedef UnifiedSyncExecutor = Future<GlucoseSourceSyncResult> Function();
typedef UnifiedTargetSyncExecutor = Future<GlucoseSyncResult> Function({
  required GlucoseSyncTarget target,
  required AppSettings settings,
  GlucoseSyncPlan? explicitPlan,
});
typedef UnifiedSyncCompletionHandler = Future<void> Function(
  UnifiedSyncRunResult result,
);

class UnifiedGlucoseSyncRuntime {
  final UnifiedSyncExecutor executor;
  final UnifiedTargetSyncExecutor? targetExecutor;
  final UnifiedSyncCompletionHandler onCompleted;
  final DateTime Function() now;

  bool _running = false;
  final Set<String> _runningTargetIds = <String>{};

  UnifiedGlucoseSyncRuntime({
    required this.executor,
    this.targetExecutor,
    required this.onCompleted,
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;

  bool get running => _running;

  Future<UnifiedSyncRunResult?> run({
    required String trigger,
    Map<String, Object?> payload = const {},
  }) async {
    if (_running) return null;
    _running = true;
    final startedAt = now();
    try {
      final sourceResult = await executor();
      final result = UnifiedSyncRunResult(
        trigger: trigger,
        payload: payload,
        sourceResult: sourceResult,
        startedAt: startedAt,
        completedAt: now(),
      );
      await onCompleted(result);
      return result;
    } finally {
      _running = false;
    }
  }

  Future<UnifiedSyncRunResult?> runTarget({
    required GlucoseSyncTarget target,
    required AppSettings settings,
    required String trigger,
    Map<String, Object?> payload = const {},
    GlucoseSyncPlan? explicitPlan,
  }) async {
    final executor = targetExecutor;
    if (executor == null) {
      throw StateError('unified_target_sync_executor_not_registered');
    }
    if (_runningTargetIds.contains(target.targetId)) return null;
    _runningTargetIds.add(target.targetId);
    final startedAt = now();
    try {
      final targetResult = await executor(
        target: target,
        settings: settings,
        explicitPlan: explicitPlan,
      );
      final sourceResult = GlucoseSourceSyncResult(
        sourceResults: [targetResult],
      );
      final result = UnifiedSyncRunResult(
        trigger: trigger,
        payload: payload,
        sourceResult: sourceResult,
        startedAt: startedAt,
        completedAt: now(),
      );
      await onCompleted(result);
      return result;
    } finally {
      _runningTargetIds.remove(target.targetId);
    }
  }

  Future<UnifiedSyncRunResult?> submitBackfill({
    required GlucoseSyncTarget target,
    required AppSettings settings,
    required GlucoseSyncPlan plan,
    Map<String, Object?> payload = const {},
  }) {
    return runTarget(
      target: target,
      settings: settings,
      trigger: 'syncWindowBackfill',
      payload: {
        ...payload,
        'targetId': target.targetId,
        'subjectId': target.subjectId,
        'from': plan.from.toIso8601String(),
        'to': plan.to.toIso8601String(),
        'reason': plan.reason.name,
      },
      explicitPlan: plan,
    );
  }
}
