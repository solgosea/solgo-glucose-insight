import '../../domain/entities/app_settings.dart';
import '../../domain/sync_target/glucose_sync_target.dart';
import '../../domain/sync_window/sync_window_change.dart';
import '../../domain/sync_window/sync_window_coverage.dart';

class SyncWindowBackfillDecisionContext {
  final AppSettings previousSettings;
  final AppSettings nextSettings;
  final GlucoseSyncTarget target;
  final SyncWindowCoverage coverage;
  final DateTime now;

  const SyncWindowBackfillDecisionContext({
    required this.previousSettings,
    required this.nextSettings,
    required this.target,
    required this.coverage,
    required this.now,
  });

  SyncWindowChange get change => SyncWindowChange(
        previousDays: previousSettings.initialSyncDays,
        nextDays: nextSettings.initialSyncDays,
      );

  DateTime get desiredFrom =>
      now.subtract(Duration(days: nextSettings.initialSyncDays));

  DateTime get previousWindowFrom =>
      now.subtract(Duration(days: previousSettings.initialSyncDays));
}
