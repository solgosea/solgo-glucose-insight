import '../application/history/status_history_service.dart';
import '../application/history/status_history_recorder.dart';
import '../application/status_monitor_refresh_coordinator.dart';
import '../application/status_monitor_service.dart';
import '../application/status_monitor_target_resolver.dart';
import '../application/status_persistent_notification_service.dart';
import '../application/floating/status_floating_service.dart';
import '../application/text/status_text_template_installer.dart';
import '../application/widget/status_widget_service.dart';
import '../data/platform/status_widget_platform_bridge.dart';
import '../data/sqlite/sqlite_status_floating_settings_repository.dart';
import '../data/sqlite/status_monitor_probe_repository.dart';
import '../data/sqlite/status_monitor_repository.dart';
import '../data/sqlite/status_monitor_template_repository.dart';
import '../runtime/status_monitor_polling_runtime_binding.dart';
import '../runtime/status_monitor_runtime.dart';
import '../runtime/status_monitor_runtime_cache.dart';

class StatusMonitorServiceBundle {
  final StatusMonitorRepository repository;
  final StatusMonitorProbeRepository probeRepository;
  final SqliteStatusFloatingSettingsRepository floatingSettingsRepository;
  final StatusMonitorTemplateRepository templateRepository;
  final StatusTextTemplateInstaller textTemplateInstaller;
  final StatusHistoryRecorder historyRecorder;
  final StatusHistoryService historyService;
  final StatusPersistentNotificationService notificationService;
  final StatusWidgetPlatformBridge widgetBridge;
  final StatusWidgetService widgetService;
  final StatusFloatingService floatingService;
  final StatusMonitorTargetResolver targetResolver;
  final StatusMonitorRuntimeCache cache;
  final StatusMonitorService service;
  final StatusMonitorRefreshCoordinator refreshCoordinator;
  final StatusMonitorPollingRuntimeBinding pollingBinding;
  final StatusMonitorRuntime runtime;

  const StatusMonitorServiceBundle({
    required this.repository,
    required this.probeRepository,
    required this.floatingSettingsRepository,
    required this.templateRepository,
    required this.textTemplateInstaller,
    required this.historyRecorder,
    required this.historyService,
    required this.notificationService,
    required this.widgetBridge,
    required this.widgetService,
    required this.floatingService,
    required this.targetResolver,
    required this.cache,
    required this.service,
    required this.refreshCoordinator,
    required this.pollingBinding,
    required this.runtime,
  });
}
