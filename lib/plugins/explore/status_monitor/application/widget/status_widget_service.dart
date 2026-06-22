import '../../data/platform/status_widget_platform_bridge.dart';
import '../../data/sqlite/status_monitor_repository.dart';
import '../../domain/status_report.dart';
import '../../domain/widget/status_widget_settings.dart';
import '../../domain/widget/status_widget_snapshot.dart';
import 'status_widget_snapshot_builder.dart';

class StatusWidgetService {
  final StatusMonitorRepository repository;
  final StatusWidgetPlatformBridge bridge;
  final StatusWidgetSnapshotBuilder snapshotBuilder;

  const StatusWidgetService({
    required this.repository,
    required this.bridge,
    this.snapshotBuilder = const StatusWidgetSnapshotBuilder(),
  });

  Future<StatusWidgetSettings> settings(String subjectId) {
    return repository.widgetSettings(subjectId);
  }

  Future<bool> lowBatteryMode(String subjectId) {
    return repository.lowBatteryMode(subjectId);
  }

  Future<StatusWidgetSnapshot> snapshot(StatusReport report) async {
    final settings = await repository.widgetSettings(report.subjectId);
    return snapshotBuilder.build(report: report, settings: settings);
  }

  Future<void> publish(StatusReport report) async {
    final settings = await repository.widgetSettings(report.subjectId);
    final snapshot = snapshotBuilder.build(report: report, settings: settings);
    await bridge.publish(snapshot);
  }
}
