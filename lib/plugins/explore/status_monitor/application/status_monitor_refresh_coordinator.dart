import '../domain/status_report.dart';
import 'floating/status_floating_runtime_coordinator.dart';
import 'status_monitor_service.dart';
import 'status_persistent_notification_service.dart';
import 'widget/status_monitor_widget_refresh_pipeline.dart';
import 'widget/status_widget_service.dart';

class StatusMonitorRefreshCoordinator {
  final StatusMonitorService service;
  final StatusPersistentNotificationService notificationService;
  final StatusWidgetService widgetService;
  final StatusMonitorWidgetRefreshPipeline widgetRefreshPipeline;
  final StatusFloatingRuntimeCoordinator? floatingCoordinator;

  StatusMonitorRefreshCoordinator({
    required this.service,
    required this.notificationService,
    required this.widgetService,
    this.floatingCoordinator,
  }) : widgetRefreshPipeline = StatusMonitorWidgetRefreshPipeline(
          widgetService: widgetService,
          notificationService: notificationService,
        );

  String get currentSubjectId => service.currentSubjectId;

  Future<void> initialize() => notificationService.initialize();

  Future<bool> lowBatteryMode(String subjectId) {
    return widgetService.lowBatteryMode(subjectId);
  }

  Future<StatusReport> refresh() async {
    final report = await service.evaluate();
    await widgetRefreshPipeline.publish(report);
    await floatingCoordinator?.refresh(report);
    return report;
  }
}
