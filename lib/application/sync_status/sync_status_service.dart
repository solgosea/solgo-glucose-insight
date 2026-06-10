import '../../application/sync_status/sync_status_formatter.dart';
import '../../application/sync_strategy/data_source_sync_strategy_coordinator.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/data_source_runtime/data_source_health_status.dart';
import '../../domain/data_source_runtime/data_source_runtime_snapshot.dart';
import '../../domain/sync_status/sync_schedule_snapshot.dart';
import '../../domain/sync_status/sync_status_level.dart';
import '../../domain/sync_status/sync_status_snapshot.dart';

class SyncStatusService {
  final Duration freshThreshold;
  final DataSourceSyncStrategyCoordinator strategyCoordinator;
  final SyncStatusFormatter formatter;

  const SyncStatusService({
    this.freshThreshold = const Duration(minutes: 10),
    this.strategyCoordinator = const DataSourceSyncStrategyCoordinator(),
    this.formatter = const SyncStatusFormatter(),
  });

  SyncStatusSnapshot evaluate({
    required AppSettings settings,
    DataSourceRuntimeSnapshot? runtimeSnapshot,
    SyncScheduleSnapshot? scheduleSnapshot,
  }) {
    if (!strategyCoordinator.hasEnabledStrategy(settings)) {
      return SyncStatusSnapshot(
        sourceLabel: 'No data source',
        level: SyncStatusLevel.inactive,
        active: false,
        schedule: scheduleSnapshot,
      );
    }

    final runtime = runtimeSnapshot;
    if (runtime == null) {
      return SyncStatusSnapshot(
        sourceLabel: 'Data sources',
        level: SyncStatusLevel.waitingFirstSync,
        active: true,
        schedule: scheduleSnapshot,
      );
    }
    final sourceLabel = formatter.sourceName(runtime.kind);
    final state = runtime.syncState;
    if (runtime.healthStatus == DataSourceHealthStatus.unreachable) {
      return SyncStatusSnapshot(
        sourceLabel: sourceLabel,
        level: SyncStatusLevel.failed,
        active: true,
        lastSuccessAt: state?.lastSuccessAt,
        lastAttemptAt: state?.lastAttemptAt,
        lastError: runtime.lastHealthMessage,
        schedule: scheduleSnapshot,
      );
    }

    if (state?.lastError != null && state!.lastError!.trim().isNotEmpty) {
      return SyncStatusSnapshot(
        sourceLabel: sourceLabel,
        level: SyncStatusLevel.failed,
        active: true,
        lastSuccessAt: state.lastSuccessAt,
        lastAttemptAt: state.lastAttemptAt,
        lastError: state.lastError,
        schedule: scheduleSnapshot,
      );
    }

    final success = state?.lastSuccessAt;
    if (success == null) {
      return SyncStatusSnapshot(
        sourceLabel: sourceLabel,
        level: SyncStatusLevel.waitingFirstSync,
        active: true,
        lastAttemptAt: state?.lastAttemptAt,
        schedule: scheduleSnapshot,
      );
    }

    final age = DateTime.now().difference(success);
    return SyncStatusSnapshot(
      sourceLabel: sourceLabel,
      level:
          age <= freshThreshold ? SyncStatusLevel.fresh : SyncStatusLevel.stale,
      active: true,
      lastSuccessAt: success,
      lastAttemptAt: state?.lastAttemptAt,
      schedule: scheduleSnapshot,
    );
  }
}
