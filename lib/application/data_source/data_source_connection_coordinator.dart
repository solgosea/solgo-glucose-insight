import '../../domain/data_source/data_source_connection_snapshot.dart';
import '../../domain/data_source/data_source_kind.dart';
import '../../domain/data_source_runtime/data_source_runtime_snapshot.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/entities/source_sync_state.dart';
import 'data_source_connection_config.dart';
import 'data_source_connection_result.dart';
import 'data_source_registry.dart';

class DataSourceConnectionCoordinator {
  final DataSourceRegistry registry;

  DataSourceConnectionCoordinator({DataSourceRegistry? registry})
    : registry = registry ?? DataSourceRegistry();

  Future<List<DataSourceConnectionSnapshot>> snapshots({
    required AppSettings settings,
    required SourceSyncState? xdripState,
    required SourceSyncState? nightscoutState,
    required bool xdripSupported,
    DataSourceRuntimeSnapshot? xdripRuntime,
    DataSourceRuntimeSnapshot? nightscoutRuntime,
  }) async {
    final snapshots = <DataSourceConnectionSnapshot>[];
    if (xdripSupported) {
      snapshots.add(
        await registry
            .handlerFor(DataSourceKind.xdripLocal)
            .snapshot(
              settings: settings,
              syncState: xdripState,
              supported: true,
              runtime: xdripRuntime,
            ),
      );
    }
    snapshots.add(
      await registry
          .handlerFor(DataSourceKind.nightscout)
          .snapshot(
            settings: settings,
            syncState: nightscoutState,
            supported: true,
            runtime: nightscoutRuntime,
          ),
    );
    return snapshots;
  }

  Future<DataSourceConnectionResult> connect({
    required DataSourceKind kind,
    required AppSettings settings,
    DataSourceConnectionConfig config = const DataSourceConnectionConfig(),
  }) {
    return registry
        .handlerFor(kind)
        .connect(settings: settings, config: config);
  }

  Future<DataSourceConnectionResult> disconnect({
    required DataSourceKind kind,
    required AppSettings settings,
  }) {
    return registry.handlerFor(kind).disconnect(settings: settings);
  }
}
