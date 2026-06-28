import 'package:smart_xdrip/data/local/glucose_database.dart';
import 'package:smart_xdrip/domain/entities/source_sync_state.dart';

import 'glucose_sync_plan.dart';
import 'glucose_sync_policy.dart';

class GlucoseSyncWindowPlanResolver {
  const GlucoseSyncWindowPlanResolver();

  Future<GlucoseSyncPlan?> resolve({
    required GlucoseDatabase database,
    required String subjectId,
    required SourceSyncState? state,
    required GlucoseSyncPolicy policy,
    required DateTime now,
  }) async {
    final desiredFrom = now.subtract(Duration(days: policy.initialSyncDays));
    final actualEarliest =
        (await database.earliest(subjectId: subjectId))?.timestamp;
    if (actualEarliest == null || !actualEarliest.isAfter(desiredFrom)) {
      return null;
    }

    final recordedFrom = state?.coveredFrom;
    if (recordedFrom != null && !recordedFrom.isBefore(actualEarliest)) {
      return null;
    }

    return GlucoseSyncPlan(
      from: desiredFrom,
      to: actualEarliest,
      initial: false,
      previousCursor: null,
      reason: GlucoseSyncPlanReason.windowBackfill,
    );
  }
}
