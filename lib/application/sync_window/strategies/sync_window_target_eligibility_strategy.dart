import '../sync_window_backfill_decision.dart';
import '../sync_window_backfill_decision_context.dart';
import 'sync_window_backfill_decision_strategy.dart';

class SyncWindowTargetEligibilityStrategy
    extends SyncWindowBackfillDecisionStrategy {
  const SyncWindowTargetEligibilityStrategy();

  @override
  SyncWindowBackfillDecision? evaluate(
    SyncWindowBackfillDecisionContext context,
  ) {
    if (!context.target.enabled) {
      return const SyncWindowBackfillDecision.skip('target_disabled');
    }
    return null;
  }
}
