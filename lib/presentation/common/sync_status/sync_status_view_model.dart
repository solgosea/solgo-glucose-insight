import 'package:flutter/material.dart';

class SyncStatusViewModel {
  final String label;
  final String statusLabel;
  final String timeLabel;
  final String scheduleLabel;
  final String title;
  final String detail;
  final String semanticLabel;
  final Color color;
  final bool pulsing;
  final IconData icon;
  final DateTime? nextSyncAt;
  final String countdownLabel;
  final String Function(Duration remaining)? countdownFormatter;
  final String syncCountLabel;
  final String intervalLabel;
  final bool scheduleEstimated;
  final bool scheduleActive;
  final bool display;
  final String runtimeLimitationText;
  final DateTime? lastForegroundReconcileAt;
  final String lastForegroundReconcileLabel;

  const SyncStatusViewModel({
    required this.label,
    String? statusLabel,
    this.timeLabel = '',
    this.scheduleLabel = '',
    this.title = '',
    this.detail = '',
    required this.semanticLabel,
    required this.color,
    required this.pulsing,
    this.icon = Icons.sync_rounded,
    this.nextSyncAt,
    this.countdownLabel = '',
    this.countdownFormatter,
    this.syncCountLabel = '',
    this.intervalLabel = '',
    this.scheduleEstimated = false,
    this.scheduleActive = false,
    this.display = true,
    this.runtimeLimitationText = '',
    this.lastForegroundReconcileAt,
    this.lastForegroundReconcileLabel = '',
  }) : statusLabel = statusLabel ?? label;
}
