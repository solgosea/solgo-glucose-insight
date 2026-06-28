import '../../domain/sync_window/sync_window_backfill_plan.dart';

enum SyncWindowBackfillDecisionType {
  backfill,
  skip,
}

class SyncWindowBackfillDecision {
  final SyncWindowBackfillDecisionType type;
  final String reason;
  final SyncWindowBackfillPlan? plan;

  const SyncWindowBackfillDecision._({
    required this.type,
    required this.reason,
    this.plan,
  });

  const SyncWindowBackfillDecision.backfill({
    required String reason,
    required SyncWindowBackfillPlan plan,
  }) : this._(
          type: SyncWindowBackfillDecisionType.backfill,
          reason: reason,
          plan: plan,
        );

  const SyncWindowBackfillDecision.skip(String reason)
      : this._(
          type: SyncWindowBackfillDecisionType.skip,
          reason: reason,
        );

  bool get shouldBackfill =>
      type == SyncWindowBackfillDecisionType.backfill && plan != null;
}
