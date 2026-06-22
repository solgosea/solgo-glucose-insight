import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../data/sqlite/status_monitor_repository.dart';
import '../domain/status_report.dart';
import '../domain/widget/status_monitor_widget_display_mode.dart';
import 'i18n/status_monitor_l10n_resolver.dart';
import 'widget/status_widget_snapshot_builder.dart';

class StatusPersistentNotificationService {
  static const notificationId = 75010;
  static const channelId = 'status_monitor_persistent';

  final StatusMonitorRepository repository;
  final FlutterLocalNotificationsPlugin plugin;
  final StatusWidgetSnapshotBuilder snapshotBuilder;

  StatusPersistentNotificationService({
    required this.repository,
    FlutterLocalNotificationsPlugin? plugin,
    this.snapshotBuilder = const StatusWidgetSnapshotBuilder(),
  }) : plugin = plugin ?? FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initialization = InitializationSettings(android: android);
    await plugin.initialize(initialization);
    await plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          AndroidNotificationChannel(
            channelId,
            StatusMonitorL10nResolver.fallback.notificationChannelTitle,
            description: StatusMonitorL10nResolver
                .fallback.notificationChannelDescription,
            importance: Importance.low,
            playSound: false,
            enableVibration: false,
          ),
        );
  }

  Future<void> setPersistentNotificationEnabled(
    StatusReport report,
    bool enabled,
  ) async {
    await repository.setPersistentNotificationEnabled(
      report.subjectId,
      enabled,
    );
    if (enabled) {
      await update(report);
    } else {
      await cancel();
    }
  }

  Future<void> setLockScreenEnabled(
    StatusReport report,
    bool enabled,
  ) async {
    await repository.setLockScreenEnabled(report.subjectId, enabled);
    await update(report);
  }

  Future<void> setLowBatteryMode(String subjectId, bool enabled) {
    return repository.setLowBatteryMode(subjectId, enabled);
  }

  Future<void> update(StatusReport report) async {
    final settings = await repository.widgetSettings(report.subjectId);
    if (!settings.persistentNotificationEnabled ||
        settings.notificationDisplayMode ==
            StatusMonitorWidgetDisplayMode.off) {
      await cancel();
      return;
    }
    final snapshot = snapshotBuilder.build(report: report, settings: settings);
    await plugin.show(
      notificationId,
      snapshot.notificationText,
      snapshot.summary,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          StatusMonitorL10nResolver.fallback.notificationChannelTitle,
          channelDescription:
              StatusMonitorL10nResolver.fallback.notificationChannelDescription,
          importance: Importance.low,
          priority: Priority.low,
          ongoing: true,
          autoCancel: false,
          showWhen: false,
          playSound: false,
          enableVibration: false,
          category: AndroidNotificationCategory.status,
          visibility: settings.lockScreenEnabled
              ? NotificationVisibility.public
              : NotificationVisibility.secret,
        ),
      ),
    );
  }

  Future<void> cancel() => plugin.cancel(notificationId);
}
