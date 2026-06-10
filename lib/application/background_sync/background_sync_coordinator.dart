import '../../application/data_source_runtime/data_source_runtime_coordinator.dart';
import '../../application/polling/polling_context_builder.dart';
import '../../application/polling/polling_decision_service.dart';
import '../../application/sync/glucose_sync_coordinator.dart';
import '../../application/sync/glucose_sync_result.dart';
import '../../application/sync_status/sync_status_formatter.dart';
import '../../application/sync_status/sync_status_service.dart';
import '../../application/sync_strategy/data_source_sync_strategy_coordinator.dart';
import '../../application/sync_target/glucose_sync_target_registry.dart';
import '../../application/sync_target/glucose_sync_target_runner.dart';
import '../../application/sync_target/providers/self_data_source_sync_target_provider.dart';
import '../../data/local/glucose_database.dart';
import '../../data/local/settings_store.dart';
import '../../data/repositories/glucose_repository_impl.dart';
import '../../domain/background_sync/background_sync_snapshot.dart';
import '../../domain/background_sync/background_sync_status.dart';
import '../../domain/data_source/data_source_kind.dart';
import '../../domain/data_source_runtime/data_source_runtime_snapshot.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/entities/source_sync_state.dart';
import '../../domain/polling/polling_decision.dart';
import '../../domain/polling/polling_mode.dart';
import '../../domain/sources/i_glucose_source.dart';
import '../../domain/sync_status/sync_status_level.dart';
import '../../domain/sync_status/sync_status_snapshot.dart';
import 'background_sync_post_task.dart';
import 'background_sync_post_task_registry.dart';

class BackgroundSyncCoordinator {
  final SettingsStore settingsStore;
  final GlucoseDatabase database;
  final DataSourceRuntimeCoordinator runtimeCoordinator;
  final SyncStatusService syncStatusService;
  final SyncStatusFormatter formatter;
  final GlucoseRepositoryImpl repository;
  final DataSourceSyncStrategyCoordinator strategyCoordinator;
  final PollingDecisionService pollingDecisionService;
  final GlucoseSyncTargetRegistry syncTargetRegistry;
  final BackgroundSyncPostTaskRegistry postTaskRegistry;

  BackgroundSyncCoordinator({
    required this.settingsStore,
    required this.database,
    required this.runtimeCoordinator,
    required this.repository,
    required this.pollingDecisionService,
    BackgroundSyncPostTaskRegistry? postTaskRegistry,
    List<BackgroundSyncPostTask> postTasks = const [],
    GlucoseSyncTargetRegistry? syncTargetRegistry,
    this.strategyCoordinator = const DataSourceSyncStrategyCoordinator(),
    this.syncStatusService = const SyncStatusService(),
    this.formatter = const SyncStatusFormatter(),
  }) : syncTargetRegistry =
           syncTargetRegistry ??
           GlucoseSyncTargetRegistry(
             providers: const [SelfDataSourceSyncTargetProvider()],
           ),
       postTaskRegistry =
           postTaskRegistry ?? BackgroundSyncPostTaskRegistry(tasks: postTasks);

  factory BackgroundSyncCoordinator.create({required bool xdripSupported}) {
    final database = GlucoseDatabase();
    final syncTargetRegistry = GlucoseSyncTargetRegistry(
      providers: const [SelfDataSourceSyncTargetProvider()],
    );
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
    );
  }

  Future<BackgroundSyncSnapshot> runOnce() async {
    final checkedAt = DateTime.now();
    final settings = await settingsStore.load();
    await repository.applySettings(settings);

    final targets = await syncTargetRegistry.targetsFor(settings);
    if (targets.isEmpty) {
      return BackgroundSyncSnapshot(
        status: BackgroundSyncStatus.disabled,
        sourceLabel: 'No data source',
        checkedAt: checkedAt,
        message: 'No enabled sync target.',
        nextSyncInterval: PollingDecision.disabled.nextInterval,
      );
    }

    final enabledKinds = _enabledKinds(settings);
    final runtimes = <DataSourceRuntimeSnapshot>[];
    for (final kind in enabledKinds) {
      runtimes.add(
        await runtimeCoordinator.refreshOne(kind, settings: settings),
      );
    }

    final results = await _runTargets(settings);
    final refreshed = <DataSourceRuntimeSnapshot>[];
    for (final kind in enabledKinds) {
      refreshed.add(
        await runtimeCoordinator.refreshOne(kind, settings: settings),
      );
    }
    final primaryRuntime = _primaryRuntime(
      refreshed.isEmpty ? runtimes : refreshed,
    );
    final syncStatus = _syncStatusFor(
      settings: settings,
      runtimeSnapshot: primaryRuntime,
      results: results,
    );
    await _runPostTasks(
      BackgroundSyncPostTaskContext(
        settings: settings,
        runtimeSnapshots: refreshed.isEmpty ? runtimes : refreshed,
        syncSucceeded: results.any((result) => result.success),
        checkedAt: DateTime.now(),
      ),
    );
    return BackgroundSyncSnapshot(
      status:
          syncStatus.lastError == null
              ? BackgroundSyncStatus.synced
              : BackgroundSyncStatus.failed,
      sourceLabel: syncStatus.sourceLabel,
      checkedAt: DateTime.now(),
      lastSuccessAt: syncStatus.lastSuccessAt,
      message: formatter.compactText(syncStatus),
      nextSyncInterval:
          (await pollingDecisionService.decide(
            settings: settings,
            mode: PollingMode.background,
          )).nextInterval,
    );
  }

  Future<List<GlucoseSyncResult>> _runTargets(AppSettings settings) async {
    final runner = GlucoseSyncTargetRunner(
      syncCoordinator: GlucoseSyncCoordinator(database: database),
    );
    final targets = await syncTargetRegistry.targetsFor(settings);
    final results = <GlucoseSyncResult>[];
    for (final target in targets) {
      results.add(await runner.run(target: target, settings: settings));
    }
    return results;
  }

  SyncStatusSnapshot _syncStatusFor({
    required AppSettings settings,
    required DataSourceRuntimeSnapshot? runtimeSnapshot,
    required List<GlucoseSyncResult> results,
  }) {
    if (strategyCoordinator.hasEnabledStrategy(settings)) {
      return syncStatusService.evaluate(
        settings: settings,
        runtimeSnapshot: runtimeSnapshot,
      );
    }
    final success = results.where((result) => result.success).toList();
    if (success.isNotEmpty) {
      return SyncStatusSnapshot(
        sourceLabel: 'Plugin sync targets',
        level: SyncStatusLevel.fresh,
        active: true,
        lastSuccessAt: DateTime.now(),
        lastAttemptAt: DateTime.now(),
      );
    }
    return SyncStatusSnapshot(
      sourceLabel: 'Plugin sync targets',
      level: SyncStatusLevel.failed,
      active: true,
      lastAttemptAt: DateTime.now(),
      lastError: results
          .map((result) => result.error)
          .whereType<String>()
          .where((error) => error.trim().isNotEmpty)
          .join('; '),
    );
  }

  Future<void> _runPostTasks(BackgroundSyncPostTaskContext context) async {
    for (final task in postTaskRegistry.tasks) {
      try {
        await task.run(context);
      } catch (_) {
        // Post-sync tasks must not break glucose data synchronization.
      }
    }
  }

  void dispose() {
    runtimeCoordinator.dispose();
    repository.dispose();
  }

  List<DataSourceKind> _enabledKinds(AppSettings settings) {
    return [
      if (settings.nightscoutSyncEnabled) DataSourceKind.nightscout,
      if (settings.xdripSyncEnabled) DataSourceKind.xdripLocal,
    ];
  }

  DataSourceRuntimeSnapshot? _primaryRuntime(
    List<DataSourceRuntimeSnapshot> snapshots,
  ) {
    if (snapshots.isEmpty) return null;
    snapshots.sort((a, b) {
      final aSuccess = a.syncState?.lastSuccessAt;
      final bSuccess = b.syncState?.lastSuccessAt;
      if (aSuccess == null && bSuccess == null) return 0;
      if (aSuccess == null) return 1;
      if (bSuccess == null) return -1;
      return bSuccess.compareTo(aSuccess);
    });
    return snapshots.first;
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
