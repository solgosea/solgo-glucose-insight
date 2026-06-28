import '../../../domain/sync_window/sync_window_backfill_plan.dart';
import '../sync_window_backfill_decision.dart';
import '../sync_window_backfill_decision_context.dart';
import 'sync_window_backfill_decision_strategy.dart';

class SyncWindowMissingCoverageStrategy
    extends SyncWindowBackfillDecisionStrategy {
  const SyncWindowMissingCoverageStrategy();

  @override
  SyncWindowBackfillDecision? evaluate(
    SyncWindowBackfillDecisionContext context,
  ) {
    if (context.coverage.coveredFrom != null) return null;
    final plan = SyncWindowBackfillPlan(
      from: context.desiredFrom,
      to: context.now,
      windowDays: context.nextSettings.initialSyncDays,
    );
    if (plan.isEmpty) return null;
    return SyncWindowBackfillDecision.backfill(
      reason: 'missing_coverage',
      plan: plan,
    );
  }
}
