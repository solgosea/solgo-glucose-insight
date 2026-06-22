import '../../domain/widget/status_monitor_widget_display_mode.dart';
import '../../domain/widget/status_widget_settings.dart';
import 'status_monitor_repository.dart';

class SqliteStatusMonitorWidgetSettingsRepository {
  final StatusMonitorRepository repository;

  const SqliteStatusMonitorWidgetSettingsRepository({
    required this.repository,
  });

  Future<StatusWidgetSettings> settings(String subjectId) {
    return repository.widgetSettings(subjectId);
  }

  Future<void> setPersistentNotificationEnabled(
    String subjectId,
    bool enabled,
  ) {
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
