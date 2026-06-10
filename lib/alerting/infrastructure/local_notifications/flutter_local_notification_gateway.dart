import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../domain/config/local_notification_alert_config.dart';
import '../../domain/event/alert_event.dart';
import '../../domain/event/alert_level.dart';

class FlutterLocalNotificationGateway {
  final FlutterLocalNotificationsPlugin plugin;
  bool _initialized = false;

  FlutterLocalNotificationGateway({FlutterLocalNotificationsPlugin? plugin})
    : plugin = plugin ?? FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    if (_initialized) return;
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwin = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: darwin);
    await plugin.initialize(settings);
    _initialized = true;
    if (Platform.isAndroid) {
      await plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }
  }

  Future<void> show(
    AlertEvent event,
    LocalNotificationAlertConfig config,
  ) async {
    await initialize();
    final importance =
        event.level == AlertLevel.critical ? Importance.max : Importance.high;
    final priority =
        event.level == AlertLevel.critical ? Priority.max : Priority.high;
    final android = AndroidNotificationDetails(
      config.channel.id,
      config.channel.name,
      channelDescription: config.channel.description,
      importance: importance,
      priority: priority,
      playSound: true,
      enableVibration: true,
      category: AndroidNotificationCategory.alarm,
    );
    const darwin = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    await plugin.show(
      event.id.hashCode,
      event.title,
      event.body,
      NotificationDetails(android: android, iOS: darwin),
      payload: event.id,
    );
  }

  Future<void> cancel(String alertEventId) async {
    await initialize();
    await plugin.cancel(alertEventId.hashCode);
  }

  Future<void> cancelAll() async {
    await initialize();
    await plugin.cancelAll();
  }
}
