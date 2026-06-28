import '../sync_window_backfill_decision.dart';
import '../sync_window_backfill_decision_context.dart';

abstract class SyncWindowBackfillDecisionStrategy {
  const SyncWindowBackfillDecisionStrategy();

  SyncWindowBackfillDecision? evaluate(
    SyncWindowBackfillDecisionContext context,
  );
}
