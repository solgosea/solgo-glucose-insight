import '../../domain/sync_status/sync_countdown_state.dart';
import '../../domain/sync_status/sync_schedule_mode.dart';
import '../../domain/sync_status/sync_schedule_snapshot.dart';

class SyncCountdownResult {
  final SyncCountdownState state;
  final Duration? remaining;
  final String label;

  const SyncCountdownResult({
    required this.state,
    required this.label,
    this.remaining,
  });
}

class SyncCountdownService {
  final DateTime Function() now;

  const SyncCountdownService({DateTime Function()? now})
    : now = now ?? DateTime.now;

  SyncCountdownResult evaluate(SyncScheduleSnapshot? schedule) {
    if (schedule == null || schedule.mode == SyncScheduleMode.unknown) {
      return const SyncCountdownResult(
        state: SyncCountdownState.unavailable,
        label: 'Schedule pending',
      );
    }
    if (schedule.mode == SyncScheduleMode.paused) {
      return const SyncCountdownResult(
        state: SyncCountdownState.unavailable,
        label: 'Sync paused',
      );
    }
    final nextSyncAt = schedule.nextSyncAt;
    if (nextSyncAt == null) {
      return const SyncCountdownResult(
        state: SyncCountdownState.unavailable,
        label: 'Waiting for schedule',
      );
    }
    final remaining = nextSyncAt.difference(now());
    if (remaining <= Duration.zero) {
      return const SyncCountdownResult(
        state: SyncCountdownState.due,
        label: 'Sync due',
      );
    }
    return SyncCountdownResult(
      state: SyncCountdownState.scheduled,
      remaining: remaining,
      label: 'Next ${_format(remaining)}',
    );
  }

  String _format(Duration duration) {
    final seconds = duration.inSeconds;
    if (seconds < 60) return '${seconds}s';
    final minutes = duration.inMinutes;
    final remainderSeconds = seconds % 60;
    if (minutes < 60) {
      return '$minutes:${remainderSeconds.toString().padLeft(2, '0')}';
    }
    return '${duration.inHours}h';
  }
}
