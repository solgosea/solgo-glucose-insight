import 'package:smart_xdrip/application/sync_status/sync_status_formatter.dart';
import 'package:smart_xdrip/domain/sync_status/sync_status_level.dart';
import 'package:smart_xdrip/domain/sync_status/sync_status_snapshot.dart';
import 'package:smart_xdrip/foundation/theme/app_colors.dart';
import 'package:flutter/material.dart';

import 'sync_status_view_model.dart';

class SyncStatusViewModelMapper {
  final SyncStatusFormatter formatter;

  const SyncStatusViewModelMapper({
    this.formatter = const SyncStatusFormatter(),
  });

  SyncStatusViewModel map(SyncStatusSnapshot snapshot) {
    final color = switch (snapshot.level) {
      SyncStatusLevel.fresh => AppColors.green,
      SyncStatusLevel.waitingFirstSync ||
      SyncStatusLevel.stale => AppColors.amber,
      SyncStatusLevel.failed => AppColors.rose,
      SyncStatusLevel.inactive => AppColors.textDim,
    };
    final label = formatter.compactText(snapshot);
    final schedule = snapshot.schedule;
    final countdownLabel = formatter.scheduleText(schedule);
    return SyncStatusViewModel(
      label: label,
      title: _title(snapshot),
      detail: _detail(snapshot, label, countdownLabel),
      semanticLabel: '$label. $countdownLabel',
      color: color,
      pulsing:
          snapshot.level == SyncStatusLevel.fresh ||
          snapshot.level == SyncStatusLevel.waitingFirstSync,
      icon: _icon(snapshot.level),
      nextSyncAt: schedule?.nextSyncAt,
      countdownLabel: countdownLabel,
      scheduleEstimated: schedule?.estimated ?? false,
      scheduleActive: schedule?.active ?? false,
    );
  }

  String _title(SyncStatusSnapshot snapshot) {
    return switch (snapshot.level) {
      SyncStatusLevel.fresh => 'Live sync active',
      SyncStatusLevel.waitingFirstSync => 'Sync warming up',
      SyncStatusLevel.stale => 'Sync needs attention',
      SyncStatusLevel.failed => 'Sync interrupted',
      SyncStatusLevel.inactive => 'Sync disabled',
    };
  }

  String _detail(
    SyncStatusSnapshot snapshot,
    String fallback,
    String countdownLabel,
  ) {
    final suffix = countdownLabel.isEmpty ? '' : '\n$countdownLabel';
    return switch (snapshot.level) {
      SyncStatusLevel.fresh => '$fallback$suffix',
      SyncStatusLevel.waitingFirstSync =>
        'Collecting the first glucose samples for this source.$suffix',
      SyncStatusLevel.stale => '$fallback$suffix',
      SyncStatusLevel.failed => '${snapshot.lastError ?? fallback}$suffix',
      SyncStatusLevel.inactive => '$fallback$suffix',
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
