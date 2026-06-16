import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../data/sqlite/sqlite_glance_settings_repository.dart';
import '../domain/glance_lock_screen_mode.dart';
import '../domain/glance_snapshot.dart';
import 'notification/glance_notification_channel_service.dart';
import 'notification/glance_notification_channels.dart';
import 'notification/glance_notification_content_builder.dart';
import 'notification/glance_notification_permission_service.dart';

class GlancePersistentNotificationService {
  static const notificationId = 74001;

  final FlutterLocalNotificationsPlugin plugin;
  final SqliteGlanceSettingsRepository settingsRepository;
  final GlanceNotificationChannelService channelService;
  final GlanceNotificationPermissionService permissionService;
  final GlanceNotificationContentBuilder contentBuilder;

  factory GlancePersistentNotificationService({
    required SqliteGlanceSettingsRepository settingsRepository,
    FlutterLocalNotificationsPlugin? plugin,
    GlanceNotificationContentBuilder contentBuilder =
        const GlanceNotificationContentBuilder(),
  }) {
    final resolvedPlugin = plugin ?? FlutterLocalNotificationsPlugin();
    return GlancePersistentNotificationService._(
      settingsRepository: settingsRepository,
      plugin: resolvedPlugin,
      channelService: GlanceNotificationChannelService(plugin: resolvedPlugin),
      permissionService: GlanceNotificationPermissionService(
        plugin: resolvedPlugin,
      ),
      contentBuilder: contentBuilder,
    );
  }

  const GlancePersistentNotificationService._({
    required this.settingsRepository,
    required this.plugin,
    required this.channelService,
    required this.permissionService,
    required this.contentBuilder,
  });

  Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initialization = InitializationSettings(android: android);
    await plugin.initialize(initialization);
    await channelService.ensureConfigured();
  }

  Future<bool> requestPermission() => permissionService.requestPermission();

  Future<bool> areNotificationsEnabled() =>
      permissionService.areNotificationsEnabled();

  Future<void> update(GlanceSnapshot snapshot) async {
    final settings = await settingsRepository.get();
    if (!settings.enabled) {
      await cancel();
      return;
    }
    if (!await areNotificationsEnabled()) {
      return;
    }
    final content = contentBuilder.build(
      snapshot: snapshot,
      privacyMode: settings.privacyMode,
      displayMode: settings.notificationDisplayMode,
      aodFriendly: settings.aodFriendlyEnabled,
    );
    await plugin.show(
      notificationId,
      content.title,
      content.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          GlanceNotificationChannels.lockScreen,
          'Glance status',
          channelDescription:
              'Lock screen glucose status without sound or vibration.',
          importance: Importance.high,
          priority: Priority.high,
          ongoing: true,
          autoCancel: false,
          showWhen: false,
          playSound: false,
          enableVibration: false,
          category: AndroidNotificationCategory.status,
          visibility: settings.lockScreenMode == GlanceLockScreenMode.off
              ? NotificationVisibility.secret
              : content.visibility,
        ),
      ),
    );
  }

  Future<void> cancel() => plugin.cancel(notificationId);
}
