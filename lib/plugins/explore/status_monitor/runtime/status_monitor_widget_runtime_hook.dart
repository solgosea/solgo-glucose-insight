import '../application/widget/status_monitor_widget_runtime_coordinator.dart';
import '../domain/status_report.dart';

class StatusMonitorWidgetRuntimeHook {
  final StatusMonitorWidgetRuntimeCoordinator coordinator;

  const StatusMonitorWidgetRuntimeHook({required this.coordinator});

  Future<void> onReportUpdated(StatusReport report) {
    return coordinator.onStatusReportUpdated(report);
  }
}
