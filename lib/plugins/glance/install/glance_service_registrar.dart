import 'package:smart_xdrip/application/subject/active_subject_service.dart';
import 'package:smart_xdrip/application/floating_surface/floating_surface_service.dart';
import 'package:smart_xdrip/data/local/glucose_database.dart';
import 'package:smart_xdrip/domain/entities/app_settings.dart';
import 'package:smart_xdrip/plugin_platform/install/plugin_install_context.dart';

import '../application/glance_navigation_action_resolver.dart';
import '../application/glance_persistent_notification_service.dart';
import '../application/glance_runtime_coordinator.dart';
import '../application/glance_snapshot_service.dart';
import '../application/glance_widget_config_service.dart';
import '../application/floating/floating_glance_runtime_coordinator.dart';
import '../application/floating/floating_glance_overlay_action_handler.dart';
import '../application/floating/floating_glance_service.dart';
import '../application/runtime/glance_runtime_refresh_pipeline.dart';
import '../data/platform/glance_widget_platform_bridge.dart';
import '../data/platform/method_channel_glance_widget_bridge.dart';
import '../data/sqlite/sqlite_floating_glance_settings_repository.dart';
import '../data/sqlite/sqlite_glance_settings_repository.dart';
import '../data/sqlite/sqlite_glance_widget_config_repository.dart';
import 'glance_service_bundle.dart';

class GlanceServiceRegistrar {
  const GlanceServiceRegistrar();

  GlanceServiceBundle install(PluginInstallContext context) {
    final database = context.services.get<GlucoseDatabase>();
    final settingsProvider = context.services.get<AppSettings Function()>();
    final snapshotService = GlanceSnapshotService(
      database: database,
      activeSubjectService: context.services.get<ActiveSubjectService>(),
      settingsProvider: settingsProvider,
    );
    final widgetConfigRepository = SqliteGlanceWidgetConfigRepository(
      databaseProvider: () => database.db,
    );
    final settingsRepository = SqliteGlanceSettingsRepository(
      databaseProvider: () => database.db,
    );
    final floatingSettingsRepository = SqliteFloatingGlanceSettingsRepository(
      databaseProvider: () => database.db,
    );
    final widgetBridge = MethodChannelGlanceWidgetBridge(
      settingsProvider: settingsRepository.get,
    );
    final notificationService = GlancePersistentNotificationService(
      settingsRepository: settingsRepository,
    );
    final floatingService = FloatingGlanceService(
      settingsRepository: floatingSettingsRepository,
      surfaceService: context.services.get<FloatingSurfaceService>(),
    );
    final floatingActionHandler = FloatingGlanceOverlayActionHandler(
      surfaceService: context.services.get<FloatingSurfaceService>(),
      settingsRepository: floatingSettingsRepository,
      snapshotService: snapshotService,
      floatingService: floatingService,
    )..start();
    final widgetConfigService = GlanceWidgetConfigService(
      repository: widgetConfigRepository,
      snapshotService: snapshotService,
      widgetBridge: widgetBridge,
      settingsProvider: settingsProvider,
    );
    final refreshPipeline = GlanceRuntimeRefreshPipeline(
      widgetConfigService: widgetConfigService,
      notificationService: notificationService,
      floatingCoordinator: FloatingGlanceRuntimeCoordinator(
        service: floatingService,
      ),
    );
    final runtimeCoordinator = GlanceRuntimeCoordinator(
      refreshPipeline: refreshPipeline,
    );
    final bundle = GlanceServiceBundle(
      snapshotService: snapshotService,
      widgetConfigRepository: widgetConfigRepository,
      settingsRepository: settingsRepository,
      floatingSettingsRepository: floatingSettingsRepository,
      widgetBridge: widgetBridge,
      notificationService: notificationService,
      floatingService: floatingService,
      floatingActionHandler: floatingActionHandler,
      widgetConfigService: widgetConfigService,
      navigationActionResolver: const GlanceNavigationActionResolver(),
      runtimeCoordinator: runtimeCoordinator,
    );
    _register(context, bundle);
    return bundle;
  }

  void _register(PluginInstallContext context, GlanceServiceBundle bundle) {
    context.services.register<GlanceSnapshotService>(bundle.snapshotService);
    context.services.register<SqliteGlanceWidgetConfigRepository>(
      bundle.widgetConfigRepository,
    );
    context.services.register<SqliteGlanceSettingsRepository>(
      bundle.settingsRepository,
    );
    context.services.register<SqliteFloatingGlanceSettingsRepository>(
      bundle.floatingSettingsRepository,
    );
    context.services.register<GlanceWidgetPlatformBridge>(bundle.widgetBridge);
    context.services.register<GlancePersistentNotificationService>(
      bundle.notificationService,
    );
    context.services.register<FloatingGlanceService>(bundle.floatingService);
    context.services.register<FloatingGlanceOverlayActionHandler>(
      bundle.floatingActionHandler,
    );
    context.services.register<GlanceWidgetConfigService>(
      bundle.widgetConfigService,
    );
    context.services.register<GlanceNavigationActionResolver>(
      bundle.navigationActionResolver,
    );
  }
}
