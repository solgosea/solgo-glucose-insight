import '../../application/data_source_runtime/data_source_runtime_coordinator.dart';
import '../../application/polling/polling_context_builder.dart';
import '../../application/polling/polling_decision_service.dart';
import '../../application/sync_target/glucose_sync_target_registry.dart';
import '../../application/sync_target/providers/self_data_source_sync_target_provider.dart';
import '../../data/local/glucose_database.dart';
import '../../data/local/settings_store.dart';
import '../../data/repositories/glucose_repository_impl.dart';
import '../../domain/data_source/data_source_kind.dart';
import '../../domain/entities/source_sync_state.dart';
import '../../domain/sources/i_glucose_source.dart';
import 'background_sync_coordinator.dart';
import 'background_sync_post_task_registry.dart';

class BackgroundSyncCoordinatorFactory {
  final GlucoseDatabase database;
  final GlucoseSyncTargetRegistry syncTargetRegistry;
  final BackgroundSyncPostTaskRegistry postTaskRegistry;
  final bool xdripSupported;

  const BackgroundSyncCoordinatorFactory({
    required this.database,
    required this.syncTargetRegistry,
    required this.postTaskRegistry,
    required this.xdripSupported,
  });

  factory BackgroundSyncCoordinatorFactory.core({
    required bool xdripSupported,
    GlucoseDatabase? database,
  }) {
    return BackgroundSyncCoordinatorFactory(
      database: database ?? GlucoseDatabase(),
      syncTargetRegistry: GlucoseSyncTargetRegistry(
        providers: const [SelfDataSourceSyncTargetProvider()],
      ),
      postTaskRegistry: BackgroundSyncPostTaskRegistry(),
      xdripSupported: xdripSupported,
    );
  }

  BackgroundSyncCoordinator create() {
    return BackgroundSyncCoordinator(
      settingsStore: SettingsStore(),
      database: database,
      runtimeCoordinator: DataSourceRuntimeCoordinator(
        xdripSupported: xdripSupported,
        syncStateLoader: (kind) => _sourceStateFor(database, kind),
      ),
      repository: GlucoseRepositoryImpl(
        db: database,
        syncTargetRegistry: syncTargetRegistry,
      ),
      pollingDecisionService: PollingDecisionService(
        contextBuilder: PollingContextBuilder(
          database: database,
          sourceStateLoader: (kind) => _sourceStateFor(database, kind),
        ),
      ),
      syncTargetRegistry: syncTargetRegistry,
      postTaskRegistry: postTaskRegistry,
    );
  }

  static Future<SourceSyncState?> _sourceStateFor(
    GlucoseDatabase database,
    DataSourceKind kind,
  ) {
    return switch (kind) {
      DataSourceKind.xdripLocal => database.getSourceState(
        DataSource.xdripHttp.name,
      ),
      DataSourceKind.nightscout => database.getSourceState(
        DataSource.nightscout.name,
      ),
    };
  }
}
