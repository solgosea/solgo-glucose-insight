import '../../domain/status_report.dart';
import '../status_persistent_notification_service.dart';
import 'status_widget_service.dart';

class StatusMonitorWidgetRefreshPipeline {
  final StatusWidgetService widgetService;
  final StatusPersistentNotificationService notificationService;

  const StatusMonitorWidgetRefreshPipeline({
    required this.widgetService,
    required this.notificationService,
  });

  Future<void> publish(StatusReport report) async {
    await widgetService.publish(report);
    await notificationService.update(report);
  }
}
