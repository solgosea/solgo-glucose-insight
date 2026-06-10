import 'dart:io';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../application/analysis/analysis_engine.dart';
import '../../application/analysis/analysis_facade.dart';
import '../../application/analysis/analysis_refresh_service.dart';
import '../../application/analysis/analysis_session_store.dart';
import '../../application/analysis/restore_analysis_session_use_case.dart';
import '../../application/background_runtime/background_runtime_orchestrator.dart';
import '../../application/background_runtime/background_runtime_policy.dart';
import '../../application/background_runtime/background_runtime_strategy_registry.dart';
import '../../application/background_runtime/strategies/self_datasource_background_strategy.dart';
import '../../application/background_sync/background_sync_post_task.dart';
import '../../application/background_sync/background_sync_post_task_registry.dart';
import '../../application/data_source/connection_test_result.dart';
import '../../application/data_source/data_source_connection_config.dart';
import '../../application/data_source/data_source_connection_coordinator.dart';
import '../../application/data_source/data_source_connection_result.dart';
import '../../application/data_source/data_source_connection_service.dart';
import '../../application/data_source_runtime/data_source_runtime_coordinator.dart';
import '../../application/data_source_runtime/data_source_runtime_polling_adapter.dart';
import '../../application/foreground_reconcile/foreground_reconcile_context.dart';
import '../../application/foreground_reconcile/foreground_reconcile_mode.dart';
import '../../application/foreground_reconcile/foreground_reconcile_orchestrator.dart';
import '../../application/foreground_reconcile/foreground_reconcile_pipeline.dart';
import '../../application/foreground_reconcile/foreground_reconcile_platform.dart';
import '../../application/foreground_reconcile/foreground_reconcile_step_registry.dart';
import '../../application/foreground_reconcile/steps/callback_foreground_reconcile_step.dart';
import '../../application/insight/insight_generation_service.dart';
import '../../application/polling/polling_context_builder.dart';
import '../../application/polling/polling_decision_service.dart';
import '../../application/settings/app_settings_update_coordinator.dart';
import '../../application/subject/active_subject_service.dart';
import '../../application/subject/active_subject_store.dart';
import '../../application/subject/active_subject_switcher.dart';
import '../../application/subject/active_subject_validator_registry.dart';
import '../../application/subject_data/subject_data_sync_actions.dart';
import '../../application/sync_status/sync_schedule_reporter.dart';
import '../../application/sync_status/sync_schedule_store.dart';
import '../../application/sync_status/sync_status_service.dart';
import '../../application/sync_status/sync_status_store.dart';
import '../../application/sync_strategy/data_source_sync_strategy_coordinator.dart';
import '../../application/sync_target/glucose_sync_target_registry.dart';
import '../../application/sync_target/providers/self_data_source_sync_target_provider.dart';
import '../../alerting/alerting_runtime_factory.dart';
import '../../alerting/presentation/overlays/alert_overlay_signal_bus.dart';
import '../../alerting/suppression/alert_suppression_policy_registry.dart';
import '../../domain/data_source_runtime/data_source_runtime_snapshot.dart';
import '../../data/local/glucose_database.dart';
import '../../data/local/settings_store.dart';
import '../../data/repositories/glucose_repository_impl.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/data_source/data_source_connection_snapshot.dart';
import '../../domain/data_source/data_source_kind.dart';
import '../../domain/entities/source_sync_state.dart';
import '../../domain/repositories/i_glucose_repository.dart';
import '../../domain/sources/i_glucose_source.dart';
import '../../domain/subject/analysis_subject.dart';
import '../../domain/sync_status/sync_status_snapshot.dart';
import '../../domain/sync_status/sync_schedule_mode.dart';
import '../../infrastructure/background/flutter_background_service_adapter.dart';
import '../../infrastructure/polling/foreground_polling_scheduler.dart';
import '../../plugin_platform/registry/plugin_registry.dart';
import '../../plugin_platform/install/plugin_install_context.dart';
import '../../plugin_platform/runtime/events/plugin_runtime_event.dart';
import '../../plugin_platform/runtime/events/plugin_runtime_subject_data.dart';
import '../../plugin_platform/runtime/events/plugin_runtime_event_type.dart';
import '../../plugin_platform/runtime/manager/plugin_runtime_manager.dart';
import '../../plugin_platform/schema/plugin_schema_manager.dart';
import '../../plugin_platform/schema/plugin_schema_registry.dart';
import '../../plugin_platform/services/plugin_service_registry.dart';
import '../../plugins/builtin_plugins.dart';
import '../../plugins/history/application/history_host_services.dart';
import '../../plugins/home/application/home_host_services.dart';
import '../../plugins/insights/application/insights_host_services.dart';
import '../../plugins/profile/application/profile_data_source_actions.dart';
import '../../plugins/profile/application/profile_host_services.dart';
import '../../plugins/profile/application/profile_settings_actions.dart';
import '../../plugins/settings/application/settings_actions.dart';
import '../../plugins/settings/application/settings_export_actions.dart';
import '../../plugins/settings/application/settings_host_services.dart';
import '../../plugins/settings/application/settings_storage_actions.dart';
import '../../plugins/statistics/application/statistics_host_services.dart';

/// Lightweight DI container, single source of truth for app-wide singletons.
/// Created once in main.dart and held by App widget; not a global static.
class AppContainer extends ChangeNotifier {
  final PluginRegistry pluginRegistry;

  AppContainer({PluginRegistry? pluginRegistry})
    : pluginRegistry = pluginRegistry ?? builtInPluginRegistry;

  late final GlucoseDatabase glucoseDatabase;
  late final SettingsStore settingsStore;
  late final DataSourceConnectionService dataSourceConnectionService;
  late final DataSourceConnectionCoordinator dataSourceConnectionCoordinator;
  late final DataSourceRuntimeCoordinator dataSourceRuntimeCoordinator;
  late final DataSourceSyncStrategyCoordinator syncStrategyCoordinator;
  late final GlucoseSyncTargetRegistry syncTargetRegistry;
  late final BackgroundRuntimeStrategyRegistry
  backgroundRuntimeStrategyRegistry;
  late final BackgroundSyncPostTaskRegistry backgroundSyncPostTaskRegistry;
  late final ForegroundReconcileStepRegistry foregroundReconcileStepRegistry;
  late final SyncStatusService syncStatusService;
  late final SyncScheduleStore syncScheduleStore;
  late final SyncScheduleReporter syncScheduleReporter;
  late final SyncStatusStore syncStatusStore;
  late final FlutterBackgroundServiceAdapter backgroundServiceAdapter;
  late final BackgroundRuntimeOrchestrator backgroundRuntimeOrchestrator;
  late final ForegroundReconcileOrchestrator foregroundReconcileOrchestrator;
  late final ForegroundPollingScheduler foregroundPollingScheduler;
  late final AppSettingsUpdateCoordinator settingsUpdateCoordinator;
  late final GlucoseRepositoryImpl glucoseRepository;
  late final AnalysisRefreshService analysisRefreshService;
  late final ActiveSubjectStore activeSubjectStore;
  late final ActiveSubjectService activeSubjectService;
  late final ActiveSubjectSwitcher activeSubjectSwitcher;
  late final ActiveSubjectValidatorRegistry activeSubjectValidatorRegistry;
  late final AlertOverlaySignalBus alertOverlaySignalBus;
  late final AlertSuppressionPolicyRegistry alertSuppressionPolicyRegistry;
  late final AlertingRuntimeFactory alertingRuntimeFactory;
  late final PluginServiceRegistry pluginServices;
  late final PluginRuntimeManager pluginRuntimeManager;
  late final PluginSchemaRegistry pluginSchemaRegistry;
  late AppSettings settings;
  StreamSubscription<Map<String, dynamic>?>? _backgroundSyncSubscription;
  DateTime? _lastBackgroundSyncAt;

  Future<void> bootstrap() async {
    glucoseDatabase = GlucoseDatabase();
    settingsStore = SettingsStore();
    dataSourceConnectionService = const DataSourceConnectionService();
    dataSourceConnectionCoordinator = DataSourceConnectionCoordinator();
    syncStrategyCoordinator = const DataSourceSyncStrategyCoordinator();
    syncTargetRegistry = GlucoseSyncTargetRegistry(
      providers: const [SelfDataSourceSyncTargetProvider()],
    );
    backgroundRuntimeStrategyRegistry = BackgroundRuntimeStrategyRegistry(
      strategies: const [SelfDatasourceBackgroundStrategy()],
    );
    backgroundSyncPostTaskRegistry = BackgroundSyncPostTaskRegistry();
    foregroundReconcileStepRegistry = ForegroundReconcileStepRegistry();
    dataSourceRuntimeCoordinator = DataSourceRuntimeCoordinator(
      xdripSupported: Platform.isAndroid,
      syncStateLoader: _runtimeSyncStateFor,
    );
    syncStatusService = const SyncStatusService();
    syncScheduleStore = SyncScheduleStore();
    syncScheduleReporter = SyncScheduleReporter(store: syncScheduleStore);
    syncStatusStore = SyncStatusStore();
    syncScheduleStore.addListener(_scheduleStatusChangedNotification);
    backgroundServiceAdapter = FlutterBackgroundServiceAdapter();
    backgroundRuntimeOrchestrator = BackgroundRuntimeOrchestrator(
      policy: BackgroundRuntimePolicy(
        registry: backgroundRuntimeStrategyRegistry,
      ),
      serviceAdapter: backgroundServiceAdapter,
    );
    alertOverlaySignalBus = AlertOverlaySignalBus();
    alertSuppressionPolicyRegistry = AlertSuppressionPolicyRegistry();
    pluginServices = PluginServiceRegistry();
    pluginRuntimeManager = PluginRuntimeManager.create();
    pluginSchemaRegistry = PluginSchemaRegistry();
    activeSubjectStore = ActiveSubjectStore();
    activeSubjectService = ActiveSubjectService(store: activeSubjectStore);
    activeSubjectSwitcher = ActiveSubjectSwitcher(
      service: activeSubjectService,
    );
    activeSubjectValidatorRegistry = ActiveSubjectValidatorRegistry();

    settings = await settingsStore.load();
    await activeSubjectService.restore();
    AnalysisSessionStore.instance.setActiveSubject(
      activeSubjectService.current,
    );

    glucoseRepository = GlucoseRepositoryImpl(
      db: glucoseDatabase,
      syncTargetRegistry: syncTargetRegistry,
    );
    foregroundPollingScheduler = ForegroundPollingScheduler(
      pollingAdapter: DataSourceRuntimePollingAdapter(
        decisionService: PollingDecisionService(
          contextBuilder: PollingContextBuilder(
            database: glucoseDatabase,
            sourceStateLoader: _runtimeSyncStateFor,
          ),
        ),
        syncExecutor: glucoseRepository.sync,
      ),
      afterSync: () async {
        await _runPostSyncPluginWork(syncSucceeded: true);
        await _refreshAnalysisSafely();
        _publishSubjectDataChanged({
          activeSubjectService.current.id,
        }, trigger: 'foregroundPolling');
        notifyListeners();
      },
      scheduleReporter: syncScheduleReporter,
    );
    await glucoseRepository.applySettings(settings);

    analysisRefreshService = AnalysisRefreshService(
      analysisEngine: AnalysisEngine(database: glucoseDatabase),
      insightService: InsightGenerationService(database: glucoseDatabase),
    );
    _registerCoreForegroundReconcileSteps();
    foregroundReconcileOrchestrator = ForegroundReconcileOrchestrator(
      loadContext: _loadForegroundReconcileContext,
      pipeline: ForegroundReconcilePipeline(
        registry: foregroundReconcileStepRegistry,
      ),
    );
    alertingRuntimeFactory = AlertingRuntimeFactory(
      database: glucoseDatabase,
      overlaySignalBus: alertOverlaySignalBus,
      suppressionRegistry: alertSuppressionPolicyRegistry,
    );
    await _installFeaturePlugins();
    await _validateRestoredActiveSubject();
    settingsUpdateCoordinator = AppSettingsUpdateCoordinator(
      store: settingsStore,
      publishSettings: _publishSettings,
      applyRepositorySettings: glucoseRepository.applySettings,
      refreshAnalysis: _refreshAnalysisSafely,
      syncBackgroundService: _syncBackgroundServiceWithSettings,
      updateForegroundPolling: _updateForegroundPolling,
      updateRuntimeSettings: dataSourceRuntimeCoordinator.updateSettings,
    );

    await RestoreAnalysisSessionUseCase(
      database: glucoseDatabase,
      store: AnalysisSessionStore.instance,
      settings: settings,
      subjectId: activeSubjectService.current.id,
      subject: activeSubjectService.current,
    ).call();
    await _refreshAnalysisSafely();

    await backgroundServiceAdapter.initialize();
    _backgroundSyncSubscription = backgroundServiceAdapter.listenSyncStatus(
      _handleBackgroundSyncEvent,
    );
    await _syncBackgroundServiceWithSettings(settings);
    _updateForegroundPolling(settings);
    await pluginRuntimeManager.startAppRuntimes();
  }

  Future<void> updateSettings(AppSettings next) async {
    final result = await settingsUpdateCoordinator.update(
      previous: settings,
      next: next,
    );
    if (result.applied && result.impact.hasDeferredWork) {
      notifyListeners();
    }
  }

  IGlucoseRepository get repo => glucoseRepository;

  Future<SourceSyncState?> sourceState(DataSource source) {
    return glucoseDatabase.getSourceState(source.name);
  }

  Future<ConnectionTestResult> detectXdripLocal() {
    return dataSourceConnectionService.testXdripLocal(
      baseUrl:
          settings.xdripBaseUrl ?? DataSourceConnectionService.defaultXdripUrl,
      apiSecret: settings.xdripApiSecret,
    );
  }

  Future<ConnectionTestResult> connectXdripLocal() async {
    final result = await dataSourceConnectionCoordinator.connect(
      kind: DataSourceKind.xdripLocal,
      settings: settings,
    );
    await _applyConnectionResult(result);
    return ConnectionTestResult(
      success: result.success,
      message: result.message,
    );
  }

  Future<DataSourceConnectionResult> connectNightscout({
    required String baseUrl,
    String? token,
  }) async {
    final result = await dataSourceConnectionCoordinator.connect(
      kind: DataSourceKind.nightscout,
      settings: settings,
      config: DataSourceConnectionConfig(baseUrl: baseUrl, token: token),
    );
    await _applyConnectionResult(result);
    return result;
  }

  Future<DataSourceConnectionResult> useConfiguredNightscout() async {
    final result = await dataSourceConnectionCoordinator.connect(
      kind: DataSourceKind.nightscout,
      settings: settings,
    );
    await _applyConnectionResult(result);
    return result;
  }

  Future<DataSourceConnectionResult> disconnectDataSource(
    DataSourceKind kind,
  ) async {
    final result = await dataSourceConnectionCoordinator.disconnect(
      kind: kind,
      settings: settings,
    );
    await _applyConnectionResult(result, syncAfterApply: false);
    return result;
  }

  Future<DataSourceConnectionResult> enableDataSourceSync(
    DataSourceKind kind,
  ) async {
    final next = syncStrategyCoordinator.enable(settings: settings, kind: kind);
    await updateSettings(next);
    await dataSourceRuntimeCoordinator.updateSettings(next);
    _updateSyncStatusStore();
    final runtime = dataSourceRuntimeCoordinator.snapshotFor(kind);
    if (runtime.reachable) {
      await _syncAllTargetsAndPublish(
        trigger: 'enableDataSourceSync',
        payload: {'source': kind.name},
      );
    }
    _publishRuntimeEvent(
      PluginRuntimeEventType.datasourceChanged,
      payload: {'source': kind.name, 'enabled': true},
    );
    notifyListeners();
    return DataSourceConnectionResult.success(
      message: '${_sourceTitle(kind)} sync enabled',
      nextSettings: next,
    );
  }

  Future<DataSourceConnectionResult> disableDataSourceSync(
    DataSourceKind kind,
  ) async {
    final next = syncStrategyCoordinator.disable(
      settings: settings,
      kind: kind,
    );
    await updateSettings(next);
    await dataSourceRuntimeCoordinator.updateSettings(next);
    _updateSyncStatusStore();
    _publishRuntimeEvent(
      PluginRuntimeEventType.datasourceChanged,
      payload: {'source': kind.name, 'enabled': false},
    );
    notifyListeners();
    return DataSourceConnectionResult.success(
      message: '${_sourceTitle(kind)} sync disabled',
      nextSettings: next,
    );
  }

  Future<List<DataSourceConnectionSnapshot>> dataSourceSnapshots({
    required bool xdripSupported,
  }) async {
    await dataSourceRuntimeCoordinator.refresh(settings: settings);
    _updateSyncStatusStore();
    return dataSourceConnectionCoordinator.snapshots(
      settings: settings,
      xdripState:
          dataSourceRuntimeCoordinator
              .snapshotFor(DataSourceKind.xdripLocal)
              .syncState,
      nightscoutState:
          dataSourceRuntimeCoordinator
              .snapshotFor(DataSourceKind.nightscout)
              .syncState,
      xdripSupported: xdripSupported,
      xdripRuntime: dataSourceRuntimeCoordinator.snapshotFor(
        DataSourceKind.xdripLocal,
      ),
      nightscoutRuntime: dataSourceRuntimeCoordinator.snapshotFor(
        DataSourceKind.nightscout,
      ),
    );
  }

  Future<SyncStatusSnapshot> syncStatusSnapshot() async {
    await dataSourceRuntimeCoordinator.refresh(settings: settings);
    return _updateSyncStatusStore();
  }

  SyncStatusSnapshot _updateSyncStatusStore() {
    final snapshot = syncStatusService.evaluate(
      settings: settings,
      runtimeSnapshot: _activeRuntimeSnapshot(),
      scheduleSnapshot: syncScheduleStore.snapshot,
    );
    syncStatusStore.update(snapshot);
    return snapshot;
  }

  List<DataSourceRuntimeSnapshot> dataSourceRuntimeSnapshots() {
    return dataSourceRuntimeCoordinator.snapshots;
  }

  Future<DataSourceRuntimeSnapshot> refreshDataSourceRuntime(
    DataSourceKind kind,
  ) {
    final future = dataSourceRuntimeCoordinator.refreshOne(
      kind,
      settings: settings,
    );
    future.whenComplete(() {
      _publishRuntimeEvent(
        PluginRuntimeEventType.datasourceChanged,
        payload: {'source': kind.name, 'trigger': 'refresh'},
      );
      _scheduleStatusChangedNotification();
    });
    return future;
  }

  /// Approximate on-disk size of the local SQLite database file in bytes.
  /// Returns null when the file is not present yet (e.g. first launch before
  /// any reads have triggered openDatabase).
  Future<int?> databaseFileSizeBytes() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final path = p.join(dir.path, 'smart_xdrip.db');
      final file = File(path);
      if (!await file.exists()) return null;
      return await file.length();
    } catch (_) {
      return null;
    }
  }

  /// Wipe every reading, event, snapshot, gap, and stats row. Settings,
  /// secrets, and source-state metadata are preserved (those are user
  /// configuration, not user data).
  Future<void> clearAllData() async {
    glucoseRepository.stopPolling();
    await glucoseDatabase.clearAll();
    AnalysisSessionStore.instance.clear();
    await _refreshAnalysisSafely();
    await _syncBackgroundServiceWithSettings(settings);
    _updateForegroundPolling(settings);
    await dataSourceRuntimeCoordinator.updateSettings(settings);
    notifyListeners();
  }

  Future<void> switchAnalysisSubject(AnalysisSubject subject) async {
    await activeSubjectSwitcher.switchTo(subject);
    AnalysisSessionStore.instance.setActiveSubject(subject);
    await RestoreAnalysisSessionUseCase(
      database: glucoseDatabase,
      store: AnalysisSessionStore.instance,
      settings: settings,
      subjectId: subject.id,
      subject: subject,
    ).call();
    await _refreshAnalysisSafely();
    _publishRuntimeEvent(
      PluginRuntimeEventType.activeSubjectChanged,
      payload: {'subjectId': subject.id},
    );
    notifyListeners();
  }

  Future<void> switchToSelfSubject() async {
    final subject = await activeSubjectSwitcher.switchToSelf();
    AnalysisSessionStore.instance.setActiveSubject(subject);
    await RestoreAnalysisSessionUseCase(
      database: glucoseDatabase,
      store: AnalysisSessionStore.instance,
      settings: settings,
      subjectId: subject.id,
      subject: subject,
    ).call();
    await _refreshAnalysisSafely();
    _publishRuntimeEvent(
      PluginRuntimeEventType.activeSubjectChanged,
      payload: {'subjectId': subject.id},
    );
    notifyListeners();
  }

  Future<void> reconcileOnForeground() async {
    final decision = await foregroundReconcileOrchestrator.run();
    if (!decision.shouldRun) return;
    _publishRuntimeEvent(
      PluginRuntimeEventType.appResumed,
      payload: {'mode': decision.mode.name, 'reason': decision.reason},
    );
    notifyListeners();
  }

  Future<void> _validateRestoredActiveSubject() async {
    final subject = activeSubjectService.current;
    if (subject.isSelf) return;
    final result = await activeSubjectValidatorRegistry.validate(subject);
    if (result.resetToSelf) {
      await activeSubjectSwitcher.switchToSelf();
      AnalysisSessionStore.instance.setActiveSubject(
        activeSubjectService.current,
      );
      return;
    }
    final refreshed = result.refreshedSubject;
    if (refreshed != null) {
      await activeSubjectSwitcher.switchTo(refreshed);
      AnalysisSessionStore.instance.setActiveSubject(refreshed);
    }
  }

  Future<void> _refreshAnalysisSafely() async {
    try {
      final subject = activeSubjectService.current;
      final result = await analysisRefreshService.refresh(
        settings: settings,
        subjectId: subject.id,
      );
      AnalysisSessionStore.instance.update(
        result,
        settings: settings,
        subject: subject,
      );
    } catch (_) {
      // Analysis snapshots are a local cache. Startup should continue even if a
      // malformed upstream payload or migration issue prevents refresh.
      AnalysisSessionStore.instance.clear();
    }
  }

  void _registerCoreForegroundReconcileSteps() {
    foregroundReconcileStepRegistry
      ..register(
        CallbackForegroundReconcileStep(
          id: 'core.runtime_state',
          modes: const {
            ForegroundReconcileMode.light,
            ForegroundReconcileMode.full,
          },
          callback:
              (_) => dataSourceRuntimeCoordinator.updateSettings(settings),
        ),
      )
      ..register(
        CallbackForegroundReconcileStep(
          id: 'core.sync_targets',
          modes: const {ForegroundReconcileMode.full},
          callback: (_) async {
            await _syncAllTargetsAndPublish(trigger: 'foregroundReconcile');
          },
        ),
      )
      ..register(
        CallbackForegroundReconcileStep(
          id: 'core.analysis_refresh',
          modes: const {
            ForegroundReconcileMode.light,
            ForegroundReconcileMode.full,
          },
          callback: (_) => _refreshAnalysisSafely(),
        ),
      );
  }

  Future<ForegroundReconcileContext> _loadForegroundReconcileContext(
    DateTime? lastForegroundReconcileAt,
  ) async {
    final targets = await syncTargetRegistry.targetsFor(settings);
    return ForegroundReconcileContext(
      settings: settings,
      platform: _foregroundReconcilePlatform(),
      now: DateTime.now(),
      lastBackgroundSyncAt: _lastBackgroundSyncAt,
      lastForegroundReconcileAt: lastForegroundReconcileAt,
      hasSyncTargets: targets.isNotEmpty,
    );
  }

  ForegroundReconcilePlatform _foregroundReconcilePlatform() {
    if (Platform.isAndroid) return ForegroundReconcilePlatform.android;
    if (Platform.isIOS) return ForegroundReconcilePlatform.ios;
    return ForegroundReconcilePlatform.other;
  }

  Future<void> _installFeaturePlugins() async {
    pluginServices.register<PluginRegistry>(pluginRegistry);
    pluginServices.register<PluginSchemaRegistry>(pluginSchemaRegistry);
    pluginServices.register<GlucoseDatabase>(glucoseDatabase);
    pluginServices.register<SettingsStore>(settingsStore);
    pluginServices.register<DataSourceRuntimeCoordinator>(
      dataSourceRuntimeCoordinator,
    );
    pluginServices.register<DataSourceConnectionService>(
      dataSourceConnectionService,
    );
    pluginServices.register<DataSourceConnectionCoordinator>(
      dataSourceConnectionCoordinator,
    );
    pluginServices.register<DataSourceSyncStrategyCoordinator>(
      syncStrategyCoordinator,
    );
    pluginServices.register<GlucoseSyncTargetRegistry>(syncTargetRegistry);
    pluginServices.register<BackgroundRuntimeStrategyRegistry>(
      backgroundRuntimeStrategyRegistry,
    );
    pluginServices.register<BackgroundSyncPostTaskRegistry>(
      backgroundSyncPostTaskRegistry,
    );
    pluginServices.register<ForegroundReconcileStepRegistry>(
      foregroundReconcileStepRegistry,
    );
    pluginServices.register<SyncStatusService>(syncStatusService);
    pluginServices.register<SyncScheduleStore>(syncScheduleStore);
    pluginServices.register<SyncScheduleReporter>(syncScheduleReporter);
    pluginServices.register<SyncStatusStore>(syncStatusStore);
    pluginServices.register<GlucoseRepositoryImpl>(glucoseRepository);
    pluginServices.register<IGlucoseRepository>(glucoseRepository);
    pluginServices.register<SubjectDataSyncActions>(
      SubjectDataSyncActions(
        syncAllTargets: ({
          required String trigger,
          Map<String, Object?> payload = const {},
        }) {
          return _syncAllTargetsAndPublish(trigger: trigger, payload: payload);
        },
      ),
    );
    pluginServices.register<AnalysisRefreshService>(analysisRefreshService);
    pluginServices.register<ActiveSubjectService>(activeSubjectService);
    pluginServices.register<ActiveSubjectSwitcher>(activeSubjectSwitcher);
    pluginServices.register<ActiveSubjectValidatorRegistry>(
      activeSubjectValidatorRegistry,
    );
    pluginServices.register<AlertingRuntimeFactory>(alertingRuntimeFactory);
    pluginServices.register<AlertSuppressionPolicyRegistry>(
      alertSuppressionPolicyRegistry,
    );
    pluginServices.register<AlertOverlaySignalBus>(alertOverlaySignalBus);
    pluginServices.register<FlutterBackgroundServiceAdapter>(
      backgroundServiceAdapter,
    );
    pluginServices.register<Listenable>(this);
    pluginServices.register<AppSettings Function()>(() => settings);
    pluginServices.register<List<DataSourceRuntimeSnapshot> Function()>(
      dataSourceRuntimeSnapshots,
    );
    pluginServices.register<Future<void> Function(AnalysisSubject)>(
      switchAnalysisSubject,
    );
    pluginServices.register<HomeHostServices>(
      HomeHostServices(
        changeSignal: this,
        syncStatusSnapshot: syncStatusSnapshot,
        switchToSelfSubject: switchToSelfSubject,
      ),
    );
    pluginServices.register<HistoryHostServices>(
      HistoryHostServices(
        changeSignal: this,
        facadeProvider: AnalysisFacade.current,
        settingsProvider: () => settings,
      ),
    );
    pluginServices.register<StatisticsHostServices>(
      StatisticsHostServices(
        changeSignal: this,
        facadeProvider: AnalysisFacade.current,
        settingsProvider: () => settings,
      ),
    );
    pluginServices.register<InsightsHostServices>(
      InsightsHostServices(
        changeSignal: this,
        facadeProvider: AnalysisFacade.current,
        settingsProvider: () => settings,
      ),
    );
    pluginServices.register<ProfileHostServices>(
      ProfileHostServices(
        changeSignal: this,
        facadeProvider: AnalysisFacade.current,
        settingsProvider: () => settings,
        syncStatusSnapshot: syncStatusSnapshot,
        xdripSupported: () => Platform.isAndroid,
        dataSourceSnapshots: dataSourceSnapshots,
      ),
    );
    pluginServices.register<ProfileDataSourceActions>(
      ProfileDataSourceActions(
        detectXdripLocal: detectXdripLocal,
        connectXdripLocal: connectXdripLocal,
        connectNightscout: connectNightscout,
        useConfiguredNightscout: useConfiguredNightscout,
        disconnectDataSource: disconnectDataSource,
        enableDataSourceSync: enableDataSourceSync,
        disableDataSourceSync: disableDataSourceSync,
      ),
    );
    pluginServices.register<ProfileSettingsActions>(
      ProfileSettingsActions(
        updateSettings: updateSettings,
        settingsProvider: () => settings,
      ),
    );
    final settingsHostServices = SettingsHostServices(
      changeSignal: this,
      settingsProvider: () => settings,
      databaseFileSizeBytes: databaseFileSizeBytes,
      readingsForDays: glucoseRepository.lastDays,
    );
    pluginServices.register<SettingsHostServices>(settingsHostServices);
    pluginServices.register<SettingsActions>(
      SettingsActions(
        settingsProvider: () => settings,
        updateSettings: updateSettings,
      ),
    );
    pluginServices.register<SettingsStorageActions>(
      SettingsStorageActions(clearAllData: clearAllData),
    );
    pluginServices.register<SettingsExportActions>(
      SettingsExportActions(hostServices: settingsHostServices),
    );

    final context = PluginInstallContext(
      runtimeManager: pluginRuntimeManager,
      services: pluginServices,
      schemaRegistry: pluginSchemaRegistry,
    );
    for (final plugin in builtInFeaturePlugins) {
      plugin.install(context);
    }
    await PluginSchemaManager(
      databaseProvider: () => glucoseDatabase.db,
      registry: pluginSchemaRegistry,
    ).ensureInstalled();
  }

  void _publishSettings(AppSettings next) {
    settings = next;
    AnalysisSessionStore.instance.updateSettings(next);
    AnalysisSessionStore.instance.setActiveSubject(
      activeSubjectService.current,
    );
    _publishRuntimeEvent(
      PluginRuntimeEventType.settingsChanged,
      payload: {
        'unit': next.unit.name,
        'xdripSyncEnabled': next.xdripSyncEnabled,
        'nightscoutSyncEnabled': next.nightscoutSyncEnabled,
      },
    );
    notifyListeners();
  }

  Future<SourceSyncState?> _runtimeSyncStateFor(DataSourceKind kind) {
    return switch (kind) {
      DataSourceKind.xdripLocal => sourceState(DataSource.xdripHttp),
      DataSourceKind.nightscout => sourceState(DataSource.nightscout),
    };
  }

  DataSourceRuntimeSnapshot? _activeRuntimeSnapshot() {
    final snapshots = [
      if (settings.nightscoutSyncEnabled)
        dataSourceRuntimeCoordinator.snapshotFor(DataSourceKind.nightscout),
      if (settings.xdripSyncEnabled)
        dataSourceRuntimeCoordinator.snapshotFor(DataSourceKind.xdripLocal),
    ];
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

  Future<void> _applyConnectionResult(
    DataSourceConnectionResult result, {
    bool syncAfterApply = true,
  }) async {
    final next = result.nextSettings;
    if (!result.success || next == null) return;
    await updateSettings(next);
    if (syncAfterApply && syncStrategyCoordinator.hasEnabledStrategy(next)) {
      await dataSourceRuntimeCoordinator.updateSettings(next);
      _updateSyncStatusStore();
      final runtime = _activeRuntimeSnapshot();
      if (runtime != null && !runtime.reachable) return;
      await _syncAllTargetsAndPublish(trigger: 'connectDataSource');
    }
    await dataSourceRuntimeCoordinator.updateSettings(settings);
    _updateSyncStatusStore();
    _publishRuntimeEvent(
      PluginRuntimeEventType.datasourceChanged,
      payload: {'trigger': 'connectionChanged'},
    );
    notifyListeners();
  }

  bool get _usesBackgroundServiceForSync => Platform.isAndroid;

  void _updateForegroundPolling(AppSettings current) {
    if (!syncStrategyCoordinator.hasEnabledStrategy(current) ||
        _usesBackgroundServiceForSync) {
      foregroundPollingScheduler.stop();
      return;
    }
    unawaited(foregroundPollingScheduler.updateSettings(current));
  }

  Future<void> _syncBackgroundServiceWithSettings(AppSettings current) async {
    if (!_usesBackgroundServiceForSync) return;
    if (syncStrategyCoordinator.hasEnabledStrategy(current)) {
      syncScheduleReporter.reportWaiting(
        reason: 'Waiting for Android background service schedule',
      );
    } else {
      syncScheduleReporter.reportPaused(reason: 'No enabled data source');
    }
    await backgroundRuntimeOrchestrator.sync(current);
  }

  String _sourceTitle(DataSourceKind kind) {
    return switch (kind) {
      DataSourceKind.xdripLocal => 'xDrip+ Local',
      DataSourceKind.nightscout => 'Nightscout API',
    };
  }

  void _handleBackgroundSyncEvent(Map<String, dynamic>? event) {
    if (event == null) return;
    _lastBackgroundSyncAt = DateTime.now();
    _reportBackgroundSchedule(event);
    _refreshAfterBackgroundSync();
  }

  void _reportBackgroundSchedule(Map<String, dynamic> event) {
    final secondsValue = event['nextSyncIntervalSeconds'];
    final seconds =
        secondsValue is int
            ? secondsValue
            : int.tryParse(secondsValue?.toString() ?? '');
    if (seconds == null || seconds <= 0) {
      syncScheduleReporter.reportWaiting(reason: event['message']?.toString());
      return;
    }
    syncScheduleReporter.reportInterval(
      interval: Duration(seconds: seconds),
      mode: SyncScheduleMode.background,
      reason: event['message']?.toString(),
      estimated: true,
    );
  }

  Future<void> _refreshAfterBackgroundSync() async {
    await dataSourceRuntimeCoordinator.updateSettings(settings);
    _updateSyncStatusStore();
    await _runPostSyncPluginWork(syncSucceeded: true);
    await _refreshAnalysisSafely();
    final activeSubjectId = activeSubjectService.current.id;
    _publishSubjectDataChanged({activeSubjectId}, trigger: 'backgroundService');
    notifyListeners();
  }

  Future<void> _syncAllTargetsAndPublish({
    required String trigger,
    Map<String, Object?> payload = const {},
  }) async {
    final result = await glucoseRepository.syncWithResult();
    await _handleSyncCompleted(
      result.updatedSubjectIds,
      trigger: trigger,
      payload: payload,
      syncSucceeded: result.success,
    );
  }

  Future<void> _handleSyncCompleted(
    Set<String> updatedSubjectIds, {
    required String trigger,
    required bool syncSucceeded,
    Map<String, Object?> payload = const {},
  }) async {
    await dataSourceRuntimeCoordinator.updateSettings(settings);
    _updateSyncStatusStore();
    await _runPostSyncPluginWork(syncSucceeded: syncSucceeded);
    final activeSubjectId = activeSubjectService.current.id;
    if (updatedSubjectIds.isEmpty ||
        updatedSubjectIds.contains(activeSubjectId)) {
      await _refreshAnalysisSafely();
    }
    if (updatedSubjectIds.isNotEmpty) {
      _publishSubjectDataChanged(
        updatedSubjectIds,
        trigger: trigger,
        payload: payload,
      );
    }
  }

  void _publishSubjectDataChanged(
    Set<String> subjectIds, {
    required String trigger,
    Map<String, Object?> payload = const {},
  }) {
    if (subjectIds.isEmpty) return;
    _publishRuntimeEvent(
      PluginRuntimeEventType.subjectDataChanged,
      payload: PluginRuntimeSubjectData.payload(
        subjectIds: subjectIds,
        activeSubjectId: activeSubjectService.current.id,
        trigger: trigger,
        extra: payload,
      ),
    );
  }

  Future<void> _runPostSyncPluginWork({required bool syncSucceeded}) async {
    final context = BackgroundSyncPostTaskContext(
      settings: settings,
      runtimeSnapshots: dataSourceRuntimeCoordinator.snapshots,
      syncSucceeded: syncSucceeded,
      checkedAt: DateTime.now(),
    );
    for (final task in backgroundSyncPostTaskRegistry.tasks) {
      try {
        await task.run(context);
      } catch (_) {
        // Plugin post-sync work must not block core glucose synchronization.
      }
    }
  }

  void _publishRuntimeEvent(
    PluginRuntimeEventType type, {
    Map<String, Object?> payload = const {},
  }) {
    pluginRuntimeManager.eventBus.publish(
      PluginRuntimeEvent(
        type: type,
        occurredAt: DateTime.now(),
        payload: payload,
      ),
    );
  }

  @override
  void dispose() {
    _backgroundSyncSubscription?.cancel();
    unawaited(backgroundServiceAdapter.dispose());
    dataSourceRuntimeCoordinator.dispose();
    foregroundPollingScheduler.dispose();
    glucoseRepository.dispose();
    unawaited(alertOverlaySignalBus.dispose());
    unawaited(pluginRuntimeManager.dispose());
    syncScheduleStore.removeListener(_scheduleStatusChangedNotification);
    super.dispose();
  }

  bool _statusNotificationQueued = false;

  void _scheduleStatusChangedNotification() {
    if (_statusNotificationQueued) return;
    _statusNotificationQueued = true;
    scheduleMicrotask(() {
      _statusNotificationQueued = false;
      _updateSyncStatusStore();
      notifyListeners();
    });
  }
}
