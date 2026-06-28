import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/data_source/data_source_action.dart';
import 'package:smart_xdrip/domain/data_source/data_source_connection_snapshot.dart';
import 'package:smart_xdrip/domain/data_source/data_source_connection_status.dart';
import 'package:smart_xdrip/domain/data_source/data_source_kind.dart';
import 'package:smart_xdrip/domain/data_source/data_source_sync_strategy_action.dart';
import 'package:smart_xdrip/domain/sync_status/sync_status_level.dart';
import 'package:smart_xdrip/domain/sync_status/sync_status_snapshot.dart';
import 'package:smart_xdrip/plugins/datasource/domain/profile_state/datasource_profile_event.dart';
import 'package:smart_xdrip/plugins/datasource/domain/profile_state/datasource_profile_refresh_reason.dart';
import 'package:smart_xdrip/plugins/datasource/domain/profile_state/datasource_profile_refresh_scope.dart';
import 'package:smart_xdrip/plugins/datasource/domain/profile_state/datasource_profile_section_phase.dart';
import 'package:smart_xdrip/plugins/datasource/domain/profile_state/datasource_profile_state.dart';
import 'package:smart_xdrip/plugins/datasource/domain/profile_state/datasource_profile_state_machine.dart';

void main() {
  const machine = DatasourceProfileStateMachine();

  test('shell makes datasource profile renderable before async load', () {
    final state = machine.reduce(
      const DatasourceProfileState.initial(),
      const DatasourceProfileShellBuilt([_nightscoutShell]),
    );

    expect(state.phase, DatasourceProfileSectionPhase.ready);
    expect(state.snapshots, hasLength(1));
    expect(state.syncStatus, isNull);
  });

  test('refresh keeps previous shell visible', () {
    final shell = machine.reduce(
      const DatasourceProfileState.initial(),
      const DatasourceProfileShellBuilt([_nightscoutShell]),
    );
    final refreshing = machine.reduce(
      shell,
      const DatasourceProfileRefreshStarted(
        reason: DatasourceProfileRefreshReason.initial,
        scope: DatasourceProfileRefreshScope.sourceConfiguration,
      ),
    );

    expect(refreshing.phase, DatasourceProfileSectionPhase.refreshing);
    expect(refreshing.refreshing, isTrue);
    expect(refreshing.snapshots, hasLength(1));
  });

  test('failed refresh preserves previous rows as recoverable error', () {
    final shell = machine.reduce(
      const DatasourceProfileState.initial(),
      const DatasourceProfileShellBuilt([_nightscoutShell]),
    );
    final failed = machine.reduce(
      shell,
      DatasourceProfileRefreshFailed(Exception('network')),
    );

    expect(failed.phase, DatasourceProfileSectionPhase.errorRecoverable);
    expect(failed.snapshots, hasLength(1));
    expect(failed.lastError, isNotNull);
  });

  test('loaded snapshots become ready state with sync status', () {
    final loaded = machine.reduce(
      const DatasourceProfileState.initial(),
      const DatasourceProfileSnapshotsLoaded(
        snapshots: [_nightscoutShell],
        syncStatus: SyncStatusSnapshot(
          sourceLabel: 'Data sources',
          level: SyncStatusLevel.inactive,
          active: false,
        ),
      ),
    );

    expect(loaded.phase, DatasourceProfileSectionPhase.ready);
    expect(loaded.refreshing, isFalse);
    expect(loaded.syncStatus, isNotNull);
  });

  test('sync status update keeps datasource rows instead of checking shell',
      () {
    final shell = machine.reduce(
      const DatasourceProfileState.initial(),
      const DatasourceProfileShellBuilt([_nightscoutConfigured]),
    );
    final refreshing = machine.reduce(
      shell,
      const DatasourceProfileRefreshStarted(
        reason: DatasourceProfileRefreshReason.syncStatusChanged,
        scope: DatasourceProfileRefreshScope.syncStatusOnly,
      ),
    );
    final updated = machine.reduce(
      refreshing,
      const DatasourceProfileSyncStatusLoaded(
        SyncStatusSnapshot(
          sourceLabel: 'Nightscout API',
          level: SyncStatusLevel.fresh,
          active: true,
        ),
      ),
    );

    expect(updated.phase, DatasourceProfileSectionPhase.ready);
    expect(
        updated.snapshots.single.status, DataSourceConnectionStatus.configured);
    expect(updated.syncStatus, isNotNull);
  });
}

const _nightscoutShell = DataSourceConnectionSnapshot(
  kind: DataSourceKind.nightscout,
  status: DataSourceConnectionStatus.notConfigured,
  action: DataSourceConnectionAction.configure,
  strategyAction: DataSourceSyncStrategyAction.enable,
  title: 'Nightscout API',
  subtitle: 'Not configured',
  trailing: 'Set up',
  strategyTrailing: 'Enable',
  active: false,
  detected: false,
  configured: false,
  strategyEnabled: false,
  supported: true,
);

const _nightscoutConfigured = DataSourceConnectionSnapshot(
  kind: DataSourceKind.nightscout,
  status: DataSourceConnectionStatus.configured,
  action: DataSourceConnectionAction.none,
  strategyAction: DataSourceSyncStrategyAction.disable,
  title: 'Nightscout API',
  subtitle: 'Configured',
  trailing: 'Configured',
  strategyTrailing: 'Disable',
  active: true,
  detected: true,
  configured: true,
  strategyEnabled: true,
  supported: true,
);
