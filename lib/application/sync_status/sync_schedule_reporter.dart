import '../../domain/polling/polling_decision.dart';
import '../../domain/sync_status/sync_schedule_mode.dart';
import '../../domain/sync_status/sync_schedule_snapshot.dart';
import 'sync_schedule_store.dart';

class SyncScheduleReporter {
  final SyncScheduleStore store;
  final DateTime Function() now;

  const SyncScheduleReporter({required this.store, DateTime Function()? now})
    : now = now ?? DateTime.now;

  void reportDecision({
    required PollingDecision decision,
    required SyncScheduleMode mode,
    Duration? overrideInterval,
    bool estimated = false,
  }) {
    if (!decision.shouldSyncNow) {
      reportPaused(reason: decision.reason);
      return;
    }
    reportInterval(
      interval: overrideInterval ?? decision.nextInterval,
      mode: mode,
      reason: decision.reason,
      estimated: estimated,
    );
  }

  void reportInterval({
    required Duration interval,
    required SyncScheduleMode mode,
    String? reason,
    bool estimated = false,
  }) {
    final reportedAt = now();
    store.update(
      SyncScheduleSnapshot(
        reportedAt: reportedAt,
        mode: mode,
        nextInterval: interval,
        nextSyncAt: reportedAt.add(interval),
        reason: reason,
        estimated: estimated,
      ),
    );
  }

  void reportWaiting({String? reason}) {
    store.update(
      SyncScheduleSnapshot(
        reportedAt: now(),
        mode: SyncScheduleMode.waiting,
        reason: reason,
        estimated: true,
      ),
    );
  }

  void reportPaused({String? reason}) {
    store.update(
      SyncScheduleSnapshot(
        reportedAt: now(),
        mode: SyncScheduleMode.paused,
        reason: reason,
      ),
    );
  }

  void clear() {
    store.clear();
  }
}
