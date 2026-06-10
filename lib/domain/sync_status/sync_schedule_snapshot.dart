import 'sync_schedule_mode.dart';

class SyncScheduleSnapshot {
  final DateTime? reportedAt;
  final DateTime? nextSyncAt;
  final Duration? nextInterval;
  final SyncScheduleMode mode;
  final String? reason;
  final bool estimated;

  const SyncScheduleSnapshot({
    required this.reportedAt,
    required this.mode,
    this.nextSyncAt,
    this.nextInterval,
    this.reason,
    this.estimated = false,
  });

  const SyncScheduleSnapshot.unknown()
    : reportedAt = null,
      nextSyncAt = null,
      nextInterval = null,
      mode = SyncScheduleMode.unknown,
      reason = null,
      estimated = false;

  bool get hasNextSync => nextSyncAt != null;

  bool get active =>
      mode == SyncScheduleMode.foreground ||
      mode == SyncScheduleMode.background ||
      mode == SyncScheduleMode.waiting;
}
