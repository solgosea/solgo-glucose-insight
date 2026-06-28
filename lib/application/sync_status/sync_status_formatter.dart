import '../../domain/data_source/data_source_kind.dart';
import '../../domain/sync_status/sync_schedule_mode.dart';
import '../../domain/sync_status/sync_schedule_snapshot.dart';
import '../../domain/sync_status/sync_status_level.dart';
import '../../domain/sync_status/sync_status_snapshot.dart';
import '../../l10n/generated/app_localizations.dart';

class SyncStatusFormatter {
  final AppLocalizations? l10n;

  const SyncStatusFormatter({this.l10n});

  String sourceName(DataSourceKind source) {
    return switch (source) {
      DataSourceKind.xdripLocal => 'xDrip+ Local',
      DataSourceKind.nightscout => 'Nightscout API',
    };
  }

  String compactText(SyncStatusSnapshot snapshot) {
    final status = statusText(snapshot);
    return switch (snapshot.level) {
      SyncStatusLevel.inactive => status,
      _ => '${snapshot.sourceLabel} - $status',
    };
  }

  String statusText(SyncStatusSnapshot snapshot) {
    return switch (snapshot.level) {
      SyncStatusLevel.inactive => _syncNotSyncing,
      SyncStatusLevel.waitingFirstSync => _syncWaiting,
      SyncStatusLevel.fresh => _syncSynced,
      SyncStatusLevel.stale => _syncNeedsSync,
      SyncStatusLevel.failed => _syncFailed,
    };
  }

  String activityText(SyncStatusSnapshot snapshot) {
    return switch (snapshot.level) {
      SyncStatusLevel.inactive => '',
      SyncStatusLevel.waitingFirstSync => _waitingFirstSync,
      SyncStatusLevel.fresh =>
        l10n?.syncSynced(_relative(snapshot.lastSuccessAt)) ??
            'Synced ${_relative(snapshot.lastSuccessAt)}',
      SyncStatusLevel.stale =>
        l10n?.syncLastSynced(_relative(snapshot.lastSuccessAt)) ??
            'Last synced ${_relative(snapshot.lastSuccessAt)}',
      SyncStatusLevel.failed => snapshot.lastAttemptAt == null
          ? _lastFailed
          : (l10n?.syncLastAttempt(_relative(snapshot.lastAttemptAt)) ??
              'Last attempt ${_relative(snapshot.lastAttemptAt)}'),
    };
  }

  String metaTextForSource({
    required String sourceLabel,
    required bool active,
    required bool configured,
    SyncStatusSnapshot? activeSnapshot,
  }) {
    if (!active) {
      if (!configured) return _notConfigured;
      return _configuredNotSyncing;
    }
    final snapshot = activeSnapshot;
    if (snapshot == null) return _waitingFirstSync;
    return switch (snapshot.level) {
      SyncStatusLevel.inactive => _syncNotSyncing,
      SyncStatusLevel.waitingFirstSync => _waitingFirstSync,
      SyncStatusLevel.fresh =>
        l10n?.syncSynced(_relative(snapshot.lastSuccessAt)) ??
            'Synced ${_relative(snapshot.lastSuccessAt)}',
      SyncStatusLevel.stale =>
        l10n?.syncLastSynced(_relative(snapshot.lastSuccessAt)) ??
            'Last synced ${_relative(snapshot.lastSuccessAt)}',
      SyncStatusLevel.failed => _lastFailed,
    };
  }

  String scheduleText(SyncScheduleSnapshot? schedule) {
    if (schedule == null) return _schedulePending;
    return switch (schedule.mode) {
      SyncScheduleMode.unknown => _schedulePending,
      SyncScheduleMode.paused => _syncPaused,
      SyncScheduleMode.waiting => _waitingSchedule,
      SyncScheduleMode.foreground ||
      SyncScheduleMode.background =>
        _nextText(schedule),
    };
  }

  String _nextText(SyncScheduleSnapshot schedule) {
    final next = schedule.nextSyncAt;
    if (next == null) return _waitingSchedule;
    final delta = next.difference(DateTime.now());
    if (delta <= Duration.zero) return _syncDue;
    return scheduleCountdownText(schedule, delta);
  }

  String scheduleCountdownText(
    SyncScheduleSnapshot schedule,
    Duration remaining,
  ) {
    if (remaining <= Duration.zero) return _syncDue;
    final duration = remaining.inSeconds < 60
        ? _durationSeconds(remaining.inSeconds)
        : remaining.inMinutes < 60
            ? '${remaining.inMinutes}:${(remaining.inSeconds % 60).toString().padLeft(2, '0')}'
            : _durationHours(remaining.inHours);
    if (schedule.estimated) {
      return l10n?.syncEstimatedNext(duration) ?? 'Est. next in $duration';
    }
    return l10n?.syncNext(duration) ?? 'Next in $duration';
  }

  String _relative(DateTime? date) {
    if (date == null) return l10n?.timeNever ?? 'never';
    final delta = DateTime.now().difference(date);
    if (delta.inSeconds < 60) return l10n?.timeJustNow ?? 'just now';
    if (delta.inMinutes < 60) {
      return l10n?.timeMinutesAgo(delta.inMinutes) ??
          '${delta.inMinutes} min ago';
    }
    if (delta.inHours < 24) {
      return l10n?.timeHoursAgo(delta.inHours) ?? '${delta.inHours}h ago';
    }
    return l10n?.timeDaysAgo(delta.inDays) ?? '${delta.inDays}d ago';
  }

  String _durationSeconds(int value) =>
      l10n?.durationSecondsShort(value) ?? '${value}s';

  String _durationHours(int value) =>
      l10n?.durationHoursShort(value) ?? '${value}h';

  String get _syncNotSyncing => l10n?.syncNotSyncing ?? 'Not syncing';
  String get _syncWaiting => l10n?.syncStatusWaiting ?? 'Waiting';
  String get _syncSynced => l10n?.syncStatusSynced ?? 'Synced';
  String get _syncNeedsSync => l10n?.syncStatusNeedsSync ?? 'Needs sync';
  String get _syncFailed => l10n?.syncStatusFailed ?? 'Failed';
  String get _notConfigured => l10n?.syncNotConfigured ?? 'Not configured';
  String get _configuredNotSyncing =>
      l10n?.syncConfiguredNotSyncing ?? 'Configured, not syncing';
  String get _waitingFirstSync =>
      l10n?.syncWaitingFirstSync ?? 'Waiting for first sync';
  String get _lastFailed => l10n?.syncLastFailed ?? 'Last sync failed';
  String get _schedulePending =>
      l10n?.syncSchedulePending ?? 'Schedule pending';
  String get _syncPaused => l10n?.syncPaused ?? 'Sync paused';
  String get _waitingSchedule =>
      l10n?.syncWaitingSchedule ?? 'Waiting for schedule';
  String get _syncDue => l10n?.syncDue ?? 'Sync due';
}
