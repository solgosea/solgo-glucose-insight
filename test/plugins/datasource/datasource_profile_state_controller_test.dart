import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/application/data_source/datasource_profile_section_services.dart';
import 'package:smart_xdrip/application/platform_runtime/platform_runtime_capability_snapshot.dart';
import 'package:smart_xdrip/application/platform_runtime/sync_runtime_capability.dart';
import 'package:smart_xdrip/application/sync_runtime/sync_runtime_mode.dart';
import 'package:smart_xdrip/application/sync_runtime/sync_runtime_status.dart';
import 'package:smart_xdrip/domain/data_source/data_source_action.dart';
import 'package:smart_xdrip/domain/data_source/data_source_connection_snapshot.dart';
import 'package:smart_xdrip/domain/data_source/data_source_connection_status.dart';
import 'package:smart_xdrip/domain/data_source/data_source_kind.dart';
import 'package:smart_xdrip/domain/data_source/data_source_sync_strategy_action.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/domain/sync_status/sync_status_level.dart';
import 'package:smart_xdrip/domain/sync_status/sync_status_snapshot.dart';
import 'package:smart_xdrip/plugins/datasource/application/profile_section/datasource_profile_state_controller.dart';
import 'package:smart_xdrip/plugins/datasource/domain/profile_state/datasource_profile_refresh_reason.dart';
import 'package:smart_xdrip/plugins/datasource/domain/profile_state/datasource_profile_refresh_scope.dart';

void main() {
  test('syncStatusOnly refresh does not load datasource snapshots', () async {
    var snapshotCalls = 0;
    final controller = DatasourceProfileStateController();
    final services = _services(
      snapshotLoader: () async {
        snapshotCalls++;
        return const [_nightscoutConfigured];
      },
    );

    controller.buildInitial(services);
    final scope = controller.scopeFor(
      DatasourceProfileRefreshReason.runtimeTick,
    );
    controller.startRefresh(
      reason: DatasourceProfileRefreshReason.runtimeTick,
      scope: scope,
    );
    await controller.loadSyncStatus(services);

    expect(scope, DatasourceProfileRefreshScope.syncStatusOnly);
    expect(snapshotCalls, 0);
    expect(controller.state.snapshots, isNotEmpty);
    expect(controller.state.syncStatus, isNotNull);
  });
}

DatasourceProfileSectionServices _services({
  required Future<List<DataSourceConnectionSnapshot>> Function() snapshotLoader,
}) {
  return DatasourceProfileSectionServices(
    changeSignal: ValueNotifier<int>(0),
    settingsProvider: () => const AppSettings(
      nightscoutBaseUrl: 'http://example.test',
      nightscoutSyncEnabled: true,
    ),
    syncStatusSnapshot: () async => const SyncStatusSnapshot(
      sourceLabel: 'Nightscout API',
      level: SyncStatusLevel.fresh,
      active: true,
    ),
    syncRuntimeStatus: () => const SyncRuntimeStatus(
      mode: SyncRuntimeMode.foregroundOnly,
      capability: SyncRuntimeCapability.android(),
      continuousBackgroundActive: false,
      message: '',
    ),
    platformCapabilities: () =>
        const PlatformRuntimeCapabilitySnapshot.android(),
    xdripSupported: () => true,
    dataSourceSnapshots: ({required bool xdripSupported}) => snapshotLoader(),
  );
}

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
