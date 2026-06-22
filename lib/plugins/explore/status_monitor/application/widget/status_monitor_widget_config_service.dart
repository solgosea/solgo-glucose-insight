import '../../data/sqlite/status_monitor_repository.dart';
import '../../domain/widget/status_monitor_widget_display_mode.dart';
import '../../domain/widget/status_widget_settings.dart';

class StatusMonitorWidgetConfigService {
  final StatusMonitorRepository repository;

  const StatusMonitorWidgetConfigService({required this.repository});

  Future<StatusWidgetSettings> settings(String subjectId) {
    return repository.widgetSettings(subjectId);
  }

  Future<void> setNotificationEnabled(String subjectId, bool enabled) {
    return repository.setPersistentNotificationEnabled(subjectId, enabled);
  }

  Future<void> setLockScreenEnabled(String subjectId, bool enabled) {
    return repository.setLockScreenEnabled(subjectId, enabled);
  }

  Future<void> setLowBatteryMode(String subjectId, bool enabled) {
    return repository.setLowBatteryMode(subjectId, enabled);
  }

  Future<void> setNotificationDisplayMode(
    String subjectId,
    StatusMonitorWidgetDisplayMode mode,
  ) {
    return repository.setNotificationDisplayMode(subjectId, mode);
  }

  Future<void> setLockScreenDisplayMode(
    String subjectId,
    StatusMonitorWidgetDisplayMode mode,
  ) {
    return repository.setLockScreenDisplayMode(subjectId, mode);
  }
}
