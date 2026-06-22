import 'status_monitor_widget_display_mode.dart';

class StatusWidgetSettings {
  final String subjectId;
  final bool persistentNotificationEnabled;
  final bool lockScreenEnabled;
  final bool lowBatteryMode;
  final StatusMonitorWidgetDisplayMode notificationDisplayMode;
  final StatusMonitorWidgetDisplayMode lockScreenDisplayMode;
  final DateTime updatedAt;

  const StatusWidgetSettings({
    required this.subjectId,
    required this.persistentNotificationEnabled,
    required this.lockScreenEnabled,
    required this.lowBatteryMode,
    required this.notificationDisplayMode,
    required this.lockScreenDisplayMode,
    required this.updatedAt,
  });

  factory StatusWidgetSettings.defaults(String subjectId) {
    return StatusWidgetSettings(
      subjectId: subjectId,
      persistentNotificationEnabled: false,
      lockScreenEnabled: false,
      lowBatteryMode: false,
      notificationDisplayMode: StatusMonitorWidgetDisplayMode.full,
      lockScreenDisplayMode: StatusMonitorWidgetDisplayMode.full,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  StatusWidgetSettings copyWith({
    bool? persistentNotificationEnabled,
    bool? lockScreenEnabled,
    bool? lowBatteryMode,
    StatusMonitorWidgetDisplayMode? notificationDisplayMode,
    StatusMonitorWidgetDisplayMode? lockScreenDisplayMode,
    DateTime? updatedAt,
  }) {
    return StatusWidgetSettings(
      subjectId: subjectId,
      persistentNotificationEnabled:
          persistentNotificationEnabled ?? this.persistentNotificationEnabled,
      lockScreenEnabled: lockScreenEnabled ?? this.lockScreenEnabled,
      lowBatteryMode: lowBatteryMode ?? this.lowBatteryMode,
      notificationDisplayMode:
          notificationDisplayMode ?? this.notificationDisplayMode,
      lockScreenDisplayMode:
          lockScreenDisplayMode ?? this.lockScreenDisplayMode,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
