import '../../../domain/sync_window/sync_window_backfill_plan.dart';
import '../sync_window_backfill_decision.dart';
import '../sync_window_backfill_decision_context.dart';
import 'sync_window_backfill_decision_strategy.dart';

class SyncWindowCoverageGapStrategy extends SyncWindowBackfillDecisionStrategy {
  const SyncWindowCoverageGapStrategy();

  @override
  SyncWindowBackfillDecision? evaluate(
    SyncWindowBackfillDecisionContext context,
  ) {
    final coveredFrom = context.coverage.coveredFrom;
    if (coveredFrom == null || !coveredFrom.isAfter(context.desiredFrom)) {
      return null;
    }
    final plan = SyncWindowBackfillPlan(
      from: context.desiredFrom,
      to: coveredFrom,
      windowDays: context.nextSettings.initialSyncDays,
    );
    if (plan.isEmpty) return null;
    return SyncWindowBackfillDecision.backfill(
      reason: 'coverage_gap',
      plan: plan,
    );
  }
}
