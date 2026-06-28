import '../../domain/entities/app_settings.dart';
import '../sync/glucose_sync_plan.dart';
import '../sync_runtime/unified_glucose_sync_runtime.dart';
import '../sync_runtime/unified_sync_run_result.dart';
import 'active_subject_sync_target_resolver.dart';
import 'sync_window_backfill_decision_context.dart';
import 'sync_window_backfill_decision_engine.dart';
import 'sync_window_coverage_resolver.dart';

class SyncWindowBackfillCoordinator {
  final ActiveSubjectSyncTargetResolver targetResolver;
  final SyncWindowCoverageResolver coverageResolver;
  final SyncWindowBackfillDecisionEngine decisionEngine;
  final UnifiedGlucoseSyncRuntime syncRuntime;
  final DateTime Function() now;

  SyncWindowBackfillCoordinator({
    required this.targetResolver,
    required this.coverageResolver,
    SyncWindowBackfillDecisionEngine? decisionEngine,
    required this.syncRuntime,
    DateTime Function()? now,
  })  : decisionEngine =
            decisionEngine ?? SyncWindowBackfillDecisionEngine.standard(),
        now = now ?? DateTime.now;

  Future<UnifiedSyncRunResult?> handleSettingsChange({
    required AppSettings previous,
    required AppSettings next,
  }) async {
    final target = await targetResolver.resolve(next);
    if (target == null) return null;
    final coverage = await coverageResolver.resolve(target);
    final context = SyncWindowBackfillDecisionContext(
      previousSettings: previous,
      nextSettings: next,
      target: target,
      coverage: coverage,
      now: now(),
    );
    final decision = decisionEngine.evaluate(context);
    if (!decision.shouldBackfill) return null;
    final backfill = decision.plan!;
    final plan = GlucoseSyncPlan(
      from: backfill.from,
      to: backfill.to,
      initial: false,
      previousCursor: null,
      reason: GlucoseSyncPlanReason.windowBackfill,
    );
    return syncRuntime.submitBackfill(
      target: target,
      settings: next,
      plan: plan,
      payload: {
        'previousDays': context.change.previousDays,
        'nextDays': context.change.nextDays,
        'sourceKey': coverage.sourceKey,
        'decisionReason': decision.reason,
      },
    );
  }
}
