import 'package:smart_xdrip/application/nightscout_targets/nightscout_sync_target_registry.dart';
import 'package:smart_xdrip/application/floating_surface/floating_surface_service.dart';
import 'package:smart_xdrip/application/polling_runtime/polling_runtime.dart';
import 'package:smart_xdrip/application/subject/active_subject_service.dart';
import 'package:smart_xdrip/data/local/glucose_database.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/plugin_platform/install/plugin_install_context.dart';

import '../application/history/status_history_service.dart';
import '../application/history/status_history_recorder.dart';
import '../application/status_monitor_refresh_coordinator.dart';
import '../application/status_monitor_service.dart';
import '../application/status_monitor_target_resolver.dart';
import '../application/status_persistent_notification_service.dart';
import '../application/floating/status_floating_runtime_coordinator.dart';
import '../application/floating/status_floating_service.dart';
import '../application/polling/status_monitor_polling_job.dart';
import '../application/text/status_text_template_installer.dart';
import '../application/widget/status_widget_service.dart';
import '../data/platform/method_channel_status_widget_bridge.dart';
import '../data/platform/status_widget_platform_bridge.dart';
import '../data/sqlite/sqlite_status_floating_settings_repository.dart';
import '../data/sqlite/sqlite_status_monitor_template_repository.dart';
import '../data/sqlite/status_monitor_probe_repository.dart';
import '../data/sqlite/status_monitor_repository.dart';
import '../data/sqlite/status_monitor_template_repository.dart';
import '../runtime/status_monitor_polling_runtime_binding.dart';
import '../runtime/status_monitor_runtime.dart';
import '../runtime/status_monitor_runtime_cache.dart';
import 'status_monitor_service_bundle.dart';

class StatusMonitorServiceRegistrar {
  const StatusMonitorServiceRegistrar();

  StatusMonitorServiceBundle install(PluginInstallContext context) {
    final database = context.services.get<GlucoseDatabase>();
    final repository = StatusMonitorRepository(
      databaseProvider: () => database.db,
    );
    final probeRepository = StatusMonitorProbeRepository(
      databaseProvider: () => database.db,
    );
    final floatingSettingsRepository = SqliteStatusFloatingSettingsRepository(
      databaseProvider: () => database.db,
    );
    final templateRepository = SqliteStatusMonitorTemplateRepository(
      databaseProvider: () => database.db,
    );
    final textTemplateInstaller = StatusTextTemplateInstaller(
      repository: templateRepository,
    );
    final historyRecorder = StatusHistoryRecorder(repository: repository);
    final historyService = StatusHistoryService(repository: repository);
    final notificationService =
        StatusPersistentNotificationService(repository: repository);
    const widgetBridge = MethodChannelStatusWidgetBridge();
    final widgetService = StatusWidgetService(
      repository: repository,
      bridge: widgetBridge,
    );
    final floatingService = StatusFloatingService(
      settingsRepository: floatingSettingsRepository,
      surfaceService: context.services.get<FloatingSurfaceService>(),
    );
    final cache = StatusMonitorRuntimeCache();
    final targetResolver = StatusMonitorTargetResolver(
      targetRegistry: context.services.get<NightscoutSyncTargetRegistry>(),
      settingsProvider: context.services.get<AppSettings Function()>(),
    );
    final service = StatusMonitorService(
      database: database,
      activeSubjectService: context.services.get<ActiveSubjectService>(),
      settingsProvider: context.services.get<AppSettings Function()>(),
      targetResolver: targetResolver,
      historyRecorder: historyRecorder,
      probeRepository: probeRepository,
    );
    final refreshCoordinator = StatusMonitorRefreshCoordinator(
      service: service,
      notificationService: notificationService,
      widgetService: widgetService,
      floatingCoordinator: StatusFloatingRuntimeCoordinator(
        service: floatingService,
      ),
    );
    final pollingBinding = StatusMonitorPollingRuntimeBinding(
      runtime: PollingRuntime(),
      job: StatusMonitorPollingJob(
        refreshCoordinator: refreshCoordinator,
        onReport: cache.update,
        onError: cache.markError,
      ),
    );
    final runtime = StatusMonitorRuntime(
      refreshCoordinator: refreshCoordinator,
      cache: cache,
      textTemplateInstaller: textTemplateInstaller,
      pollingBinding: pollingBinding,
    );
    final bundle = StatusMonitorServiceBundle(
      repository: repository,
      probeRepository: probeRepository,
      floatingSettingsRepository: floatingSettingsRepository,
      templateRepository: templateRepository,
      textTemplateInstaller: textTemplateInstaller,
      historyRecorder: historyRecorder,
      historyService: historyService,
      notificationService: notificationService,
      widgetBridge: widgetBridge,
      widgetService: widgetService,
      floatingService: floatingService,
      targetResolver: targetResolver,
      cache: cache,
      service: service,
      refreshCoordinator: refreshCoordinator,
      pollingBinding: pollingBinding,
      runtime: runtime,
    );
    _register(context, bundle);
    return bundle;
  }

  void _register(
    PluginInstallContext context,
    StatusMonitorServiceBundle bundle,
  ) {
    context.services.register<StatusMonitorRepository>(bundle.repository);
    context.services.register<StatusMonitorProbeRepository>(
      bundle.probeRepository,
    );
    context.services.register<SqliteStatusFloatingSettingsRepository>(
      bundle.floatingSettingsRepository,
    );
    context.services.register<StatusMonitorTemplateRepository>(
      bundle.templateRepository,
    );
    context.services.register<StatusTextTemplateInstaller>(
      bundle.textTemplateInstaller,
    );
    context.services.register<StatusHistoryRecorder>(bundle.historyRecorder);
    context.services.register<StatusHistoryService>(bundle.historyService);
    context.services.register<StatusPersistentNotificationService>(
      bundle.notificationService,
    );
    context.services.register<StatusWidgetPlatformBridge>(bundle.widgetBridge);
    context.services.register<StatusWidgetService>(bundle.widgetService);
    context.services.register<StatusFloatingService>(bundle.floatingService);
    context.services.register<StatusMonitorTargetResolver>(
      bundle.targetResolver,
    );
    context.services.register<StatusMonitorRuntimeCache>(bundle.cache);
    context.services.register<StatusMonitorService>(bundle.service);
    context.services.register<StatusMonitorRefreshCoordinator>(
      bundle.refreshCoordinator,
    );
    context.services.register<StatusMonitorPollingRuntimeBinding>(
      bundle.pollingBinding,
    );
    context.services.register<StatusMonitorRuntime>(bundle.runtime);
  }
}
