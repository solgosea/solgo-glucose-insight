import '../../domain/data_source/data_source_kind.dart';
import '../../domain/sync_status/sync_schedule_mode.dart';
import '../../domain/sync_status/sync_schedule_snapshot.dart';
import '../../domain/sync_status/sync_status_level.dart';
import '../../domain/sync_status/sync_status_snapshot.dart';

class SyncStatusFormatter {
  const SyncStatusFormatter();

  String sourceName(DataSourceKind source) {
    return switch (source) {
      DataSourceKind.xdripLocal => 'xDrip+ Local',
      DataSourceKind.nightscout => 'Nightscout API',
    };
  }

  String compactText(SyncStatusSnapshot snapshot) {
    return switch (snapshot.level) {
      SyncStatusLevel.inactive => 'Not syncing',
      SyncStatusLevel.waitingFirstSync => '${snapshot.sourceLabel} - waiting',
      SyncStatusLevel.fresh =>
        '${snapshot.sourceLabel} - ${_relative(snapshot.lastSuccessAt)}',
      SyncStatusLevel.stale =>
        '${snapshot.sourceLabel} - ${_relative(snapshot.lastSuccessAt)}',
      SyncStatusLevel.failed => '${snapshot.sourceLabel} - failed',
    };
  }

  String metaTextForSource({
    required String sourceLabel,
    required bool active,
    required bool configured,
    SyncStatusSnapshot? activeSnapshot,
  }) {
    if (!active) {
      if (!configured) return 'Not configured';
      return 'Configured, not syncing';
    }
    final snapshot = activeSnapshot;
    if (snapshot == null) return 'Waiting for first sync';
    return switch (snapshot.level) {
      SyncStatusLevel.inactive => 'Not syncing',
      SyncStatusLevel.waitingFirstSync => 'Waiting for first sync',
      SyncStatusLevel.fresh => 'Synced ${_relative(snapshot.lastSuccessAt)}',
      SyncStatusLevel.stale =>
        'Last synced ${_relative(snapshot.lastSuccessAt)}',
      SyncStatusLevel.failed => 'Last sync failed',
    };
  }

  String scheduleText(SyncScheduleSnapshot? schedule) {
    if (schedule == null) return 'Schedule pending';
    return switch (schedule.mode) {
      SyncScheduleMode.unknown => 'Schedule pending',
      SyncScheduleMode.paused => 'Sync paused',
      SyncScheduleMode.waiting => 'Waiting for schedule',
      SyncScheduleMode.foreground ||
      SyncScheduleMode.background => _nextText(schedule),
    };
  }

  String _nextText(SyncScheduleSnapshot schedule) {
    final next = schedule.nextSyncAt;
    if (next == null) return 'Waiting for schedule';
    final delta = next.difference(DateTime.now());
    if (delta <= Duration.zero) return 'Sync due';
    final prefix = schedule.estimated ? 'Est. next' : 'Next';
    if (delta.inSeconds < 60) return '$prefix ${delta.inSeconds}s';
    if (delta.inMinutes < 60) {
      return '$prefix ${delta.inMinutes}:${(delta.inSeconds % 60).toString().padLeft(2, '0')}';
    }
    return '$prefix ${delta.inHours}h';
  }

  String _relative(DateTime? date) {
    if (date == null) return 'never';
    final delta = DateTime.now().difference(date);
    if (delta.inSeconds < 60) return 'just now';
    if (delta.inMinutes < 60) return '${delta.inMinutes} min ago';
    if (delta.inHours < 24) return '${delta.inHours}h ago';
    return '${delta.inDays}d ago';
  }
}
