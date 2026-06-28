import 'package:smart_xdrip/application/sync_status/sync_status_formatter.dart';
import 'package:smart_xdrip/application/sync_runtime/sync_runtime_status.dart';
import 'package:smart_xdrip/domain/sync_status/sync_status_level.dart';
import 'package:smart_xdrip/domain/sync_status/sync_status_snapshot.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:smart_xdrip/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

import 'sync_status_view_model.dart';

class SyncStatusViewModelMapper {
  final SyncStatusFormatter formatter;

  const SyncStatusViewModelMapper({
    this.formatter = const SyncStatusFormatter(),
  });

  SyncStatusViewModel map(
    SyncStatusSnapshot snapshot, {
    SyncRuntimeStatus? runtimeStatus,
    AppLocalizations? l10n,
  }) {
    final strings = l10n;
    final effectiveFormatter =
        strings == null ? formatter : SyncStatusFormatter(l10n: strings);
    final color = switch (snapshot.level) {
      SyncStatusLevel.fresh => AppColors.green,
      SyncStatusLevel.waitingFirstSync ||
      SyncStatusLevel.stale =>
        AppColors.amber,
      SyncStatusLevel.failed => AppColors.rose,
      SyncStatusLevel.inactive => AppColors.textDim,
    };
    final label = effectiveFormatter.compactText(snapshot);
    final statusLabel = effectiveFormatter.statusText(snapshot);
    final timeLabel = effectiveFormatter.activityText(snapshot);
    final schedule = snapshot.schedule;
    final scheduleLabel = effectiveFormatter.scheduleText(schedule);
    return SyncStatusViewModel(
      label: label,
      statusLabel: statusLabel,
      timeLabel: timeLabel,
      scheduleLabel: scheduleLabel,
      title: _title(snapshot, strings),
      detail: _detail(snapshot, timeLabel, scheduleLabel, strings),
      semanticLabel: [
        statusLabel,
        if (timeLabel.isNotEmpty) timeLabel,
        if (_syncCountLabel(snapshot, strings).isNotEmpty)
          _syncCountLabel(snapshot, strings),
        if (scheduleLabel.isNotEmpty) scheduleLabel,
      ].join('. '),
      color: color,
      pulsing: snapshot.level == SyncStatusLevel.fresh ||
          snapshot.level == SyncStatusLevel.waitingFirstSync,
      icon: _icon(snapshot.level),
      nextSyncAt: schedule?.nextSyncAt,
      countdownLabel: scheduleLabel,
      countdownFormatter: schedule == null
          ? null
          : (remaining) =>
              effectiveFormatter.scheduleCountdownText(schedule, remaining),
      syncCountLabel: _syncCountLabel(snapshot, strings),
      scheduleEstimated: schedule?.estimated ?? false,
      scheduleActive: schedule?.active ?? false,
      display: snapshot.active,
      runtimeLimitationText: _runtimeLimitationText(snapshot, runtimeStatus),
      lastForegroundReconcileAt: runtimeStatus?.lastForegroundReconcileAt,
      lastForegroundReconcileLabel:
          _foregroundLabel(runtimeStatus?.lastForegroundReconcileAt, strings),
    );
  }

  String _foregroundLabel(DateTime? at, AppLocalizations? l10n) {
    if (at == null) return '';
    final elapsed = DateTime.now().difference(at);
    final relative = elapsed.inSeconds < 60
        ? (l10n?.timeJustNow ?? 'just now')
        : elapsed.inMinutes < 60
            ? (l10n?.timeMinutesAgo(elapsed.inMinutes) ??
                '${elapsed.inMinutes}m ago')
            : (l10n?.timeHoursAgo(elapsed.inHours) ??
                '${elapsed.inHours}h ago');
    if (l10n != null) return l10n.syncForegroundRefresh(relative);
    if (elapsed.inSeconds < 60) return 'Foreground refresh just now';
    if (elapsed.inMinutes < 60) {
      return 'Foreground refresh ${elapsed.inMinutes}m ago';
    }
    return 'Foreground refresh ${elapsed.inHours}h ago';
  }

  String _runtimeLimitationText(
    SyncStatusSnapshot snapshot,
    SyncRuntimeStatus? status,
  ) {
    if (!snapshot.active) return '';
    if (status == null) return '';
    if (status.supportsReliableBackgroundSync) return '';
    if (status.message.toLowerCase().contains('available but idle')) return '';
    return status.message;
  }

  String _syncCountLabel(
    SyncStatusSnapshot snapshot,
    AppLocalizations? l10n,
  ) {
    if (snapshot.level == SyncStatusLevel.inactive ||
        snapshot.level == SyncStatusLevel.waitingFirstSync) {
      return '';
    }
    final count = snapshot.lastStoredCount;
    if (count == null) return '';
    if (l10n != null) return l10n.syncNewCount(count.clamp(0, 999999));
    if (count <= 0) return '0 new';
    return count == 1 ? '1 new' : '$count new';
  }

  String _title(SyncStatusSnapshot snapshot, AppLocalizations? l10n) {
    return switch (snapshot.level) {
      SyncStatusLevel.fresh => l10n?.syncTitleLive ?? 'Live sync active',
      SyncStatusLevel.waitingFirstSync =>
        l10n?.syncTitleWarming ?? 'Sync warming up',
      SyncStatusLevel.stale =>
        l10n?.syncTitleNeedsAttention ?? 'Sync needs attention',
      SyncStatusLevel.failed =>
        l10n?.syncTitleInterrupted ?? 'Sync interrupted',
      SyncStatusLevel.inactive => l10n?.syncTitleDisabled ?? 'Sync disabled',
    };
  }

  String _detail(
    SyncStatusSnapshot snapshot,
    String timeLabel,
    String scheduleLabel,
    AppLocalizations? l10n,
  ) {
    final suffix = scheduleLabel.isEmpty ? '' : '\n$scheduleLabel';
    return switch (snapshot.level) {
      SyncStatusLevel.fresh => '$timeLabel$suffix',
      SyncStatusLevel.waitingFirstSync =>
        '${l10n?.syncDetailCollectingFirstSamples ?? 'Collecting the first glucose samples for this source.'}$suffix',
      SyncStatusLevel.stale => '$timeLabel$suffix',
      SyncStatusLevel.failed => '${snapshot.lastError ?? timeLabel}$suffix',
      SyncStatusLevel.inactive => '$timeLabel$suffix',
    };
  }

  IconData _icon(SyncStatusLevel level) {
    return switch (level) {
      SyncStatusLevel.fresh => Icons.cloud_done_rounded,
      SyncStatusLevel.waitingFirstSync => Icons.sync_rounded,
      SyncStatusLevel.stale => Icons.schedule_rounded,
      SyncStatusLevel.failed => Icons.cloud_off_rounded,
      SyncStatusLevel.inactive => Icons.pause_circle_filled_rounded,
    };
  }
}
