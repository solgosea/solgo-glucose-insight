import 'strategies/sync_window_backfill_decision_strategy.dart';
import 'strategies/sync_window_coverage_gap_strategy.dart';
import 'strategies/sync_window_missing_coverage_strategy.dart';
import 'strategies/sync_window_target_eligibility_strategy.dart';
import 'sync_window_backfill_decision.dart';
import 'sync_window_backfill_decision_context.dart';

class SyncWindowBackfillDecisionEngine {
  final List<SyncWindowBackfillDecisionStrategy> strategies;

  const SyncWindowBackfillDecisionEngine({
    required this.strategies,
  });

  factory SyncWindowBackfillDecisionEngine.standard() {
    return const SyncWindowBackfillDecisionEngine(
      strategies: [
        SyncWindowTargetEligibilityStrategy(),
        SyncWindowMissingCoverageStrategy(),
        SyncWindowCoverageGapStrategy(),
      ],
    );
  }

  SyncWindowBackfillDecision evaluate(
    SyncWindowBackfillDecisionContext context,
  ) {
    for (final strategy in strategies) {
      final decision = strategy.evaluate(context);
      if (decision != null) return decision;
    }
    return const SyncWindowBackfillDecision.skip('coverage_current');
  }
}
