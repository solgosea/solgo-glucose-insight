import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/platform_runtime/sync_runtime_capability.dart';
import 'package:smart_xdrip/application/sync_runtime/sync_runtime_mode.dart';
import 'package:smart_xdrip/application/sync_runtime/sync_runtime_status.dart';
import 'package:smart_xdrip/domain/data_source/data_source_action.dart';
import 'package:smart_xdrip/domain/data_source/data_source_connection_snapshot.dart';
import 'package:smart_xdrip/domain/data_source/data_source_connection_status.dart';
import 'package:smart_xdrip/domain/data_source/data_source_kind.dart';
import 'package:smart_xdrip/domain/data_source/data_source_sync_strategy_action.dart';
import 'package:smart_xdrip/domain/entities/source_sync_state.dart';
import 'package:smart_xdrip/domain/sync_status/sync_schedule_mode.dart';
import 'package:smart_xdrip/domain/sync_status/sync_schedule_snapshot.dart';
import 'package:smart_xdrip/domain/sync_status/sync_status_level.dart';
import 'package:smart_xdrip/domain/sync_status/sync_status_snapshot.dart';
import 'package:smart_xdrip/plugins/datasource/presentation/profile_section/datasource_profile_view_model_mapper.dart';

void main() {
  test('active datasource uses shared sync status instead of meta text', () {
    final now = DateTime.now();

    final viewModel = const DatasourceProfileViewModelMapper().map(
      syncStatus: SyncStatusSnapshot(
        sourceLabel: 'Nightscout API',
        level: SyncStatusLevel.fresh,
        active: true,
        lastSuccessAt: now.subtract(const Duration(minutes: 3)),
        lastAttemptAt: now.subtract(const Duration(minutes: 3)),
        schedule: SyncScheduleSnapshot(
          reportedAt: now,
          mode: SyncScheduleMode.background,
          nextSyncAt: now.add(const Duration(minutes: 2)),
          nextInterval: const Duration(minutes: 2),
          estimated: true,
        ),
      ),
      snapshots: [
        DataSourceConnectionSnapshot(
          kind: DataSourceKind.nightscout,
          status: DataSourceConnectionStatus.syncing,
          action: DataSourceConnectionAction.sync,
          strategyAction: DataSourceSyncStrategyAction.disable,
          title: 'Nightscout API',
          subtitle: 'Sync enabled',
          trailing: 'Sync',
          strategyTrailing: 'Disable',
          active: true,
          detected: true,
          configured: true,
          strategyEnabled: true,
          supported: true,
          syncState: SourceSyncState(
            sourceKey: 'nightscout',
            lastSuccessAt: now.subtract(const Duration(minutes: 3)),
            lastAttemptAt: now.subtract(const Duration(minutes: 3)),
            updatedAt: now,
          ),
        ),
      ],
    );

    final source = viewModel.sources.single;
    expect(source.meta, isNull);
    expect(source.syncStatus, isNotNull);
    expect(source.syncStatus!.label, contains('3m'));
    expect(source.syncStatus!.countdownLabel, contains('Est. next'));
  });

  test('datasource profile does not expose runtime idle copy', () {
    final viewModel = const DatasourceProfileViewModelMapper().map(
      syncStatus: const SyncStatusSnapshot(
        sourceLabel: 'No data source',
        level: SyncStatusLevel.inactive,
        active: false,
      ),
      syncRuntimeStatus: const SyncRuntimeStatus(
        mode: SyncRuntimeMode.continuousBackground,
        capability: SyncRuntimeCapability.android(),
        continuousBackgroundActive: false,
        message: 'Continuous background sync is available but idle.',
      ),
      snapshots: [
        const DataSourceConnectionSnapshot(
          kind: DataSourceKind.nightscout,
          status: DataSourceConnectionStatus.configured,
          action: DataSourceConnectionAction.sync,
          strategyAction: DataSourceSyncStrategyAction.enable,
          title: 'Nightscout API',
          subtitle: 'Configured',
          trailing: 'Sync',
          strategyTrailing: 'Enable',
          active: false,
          detected: true,
          configured: true,
          strategyEnabled: false,
          supported: true,
        ),
      ],
    );

    expect(viewModel.runtimeLimitationText, isEmpty);
    expect(viewModel.foregroundReconcileLabel, isEmpty);
    expect(viewModel.sources.single.syncStatus, isNull);
  });
}
