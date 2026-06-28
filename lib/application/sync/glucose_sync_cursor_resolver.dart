import 'package:smart_xdrip/domain/entities/source_sync_state.dart';

import 'glucose_sync_plan.dart';
import 'glucose_sync_policy.dart';

class GlucoseSyncCursorResolver {
  final Duration futureCursorTolerance;

  const GlucoseSyncCursorResolver({
    this.futureCursorTolerance = const Duration(minutes: 10),
  });

  GlucoseSyncPlan resolve({
    required SourceSyncState? state,
    required GlucoseSyncPolicy policy,
    DateTime? now,
  }) {
    final current = now ?? DateTime.now();
    final cursor = _cursorFrom(state?.lastCursor);
    if (cursor == null || cursor.isAfter(current.add(futureCursorTolerance))) {
      return GlucoseSyncPlan(
        from: current.subtract(Duration(days: policy.initialSyncDays)),
        to: current,
        initial: true,
        previousCursor: null,
      );
    }

    final catchUpFloor = current.subtract(policy.maxCatchUpWindow);
    final overlapped = cursor.subtract(policy.overlapWindow);
    final from = overlapped.isBefore(catchUpFloor) ? catchUpFloor : overlapped;
    return GlucoseSyncPlan(
      from: from,
      to: current,
      initial: false,
      previousCursor: cursor,
    );
  }

  DateTime? _cursorFrom(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    final millis = int.tryParse(raw);
    if (millis == null || millis <= 0) return null;
    return DateTime.fromMillisecondsSinceEpoch(millis);
  }
}
