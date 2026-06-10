import 'background_sync_status.dart';

class BackgroundSyncSnapshot {
  final BackgroundSyncStatus status;
  final String sourceLabel;
  final DateTime checkedAt;
  final DateTime? lastSuccessAt;
  final String message;
  final Duration nextSyncInterval;

  const BackgroundSyncSnapshot({
    required this.status,
    required this.sourceLabel,
    required this.checkedAt,
    required this.message,
    this.nextSyncInterval = const Duration(minutes: 5),
    this.lastSuccessAt,
  });

  bool get completed =>
      status == BackgroundSyncStatus.synced ||
      status == BackgroundSyncStatus.failed ||
      status == BackgroundSyncStatus.disabled;

  Map<String, dynamic> toMap() {
    return {
      'status': status.name,
      'source': sourceLabel,
      'checkedAt': checkedAt.toIso8601String(),
      'lastSuccessAt': lastSuccessAt?.toIso8601String(),
      'message': message,
      'nextSyncIntervalSeconds': nextSyncInterval.inSeconds,
    };
  }
}
