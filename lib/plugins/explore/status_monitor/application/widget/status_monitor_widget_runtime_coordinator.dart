import '../../domain/status_report.dart';
import 'status_monitor_widget_refresh_pipeline.dart';

class StatusMonitorWidgetRuntimeCoordinator {
  final StatusMonitorWidgetRefreshPipeline pipeline;

  const StatusMonitorWidgetRuntimeCoordinator({required this.pipeline});

  Future<void> onStatusReportUpdated(StatusReport report) {
    return pipeline.publish(report);
  }
}
