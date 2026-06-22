import 'dart:io';
import 'dart:ui';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../application/i18n/alerting_l10n_resolver.dart';
import '../../domain/config/local_notification_alert_config.dart';
import '../../domain/event/alert_event.dart';
import '../../domain/event/alert_level.dart';
import '../../domain/notification/alert_notification_action_category.dart';
import '../../l10n/generated/alerting_localizations.dart';
import 'android_alert_notification_action_factory.dart';
import 'alert_notification_id.dart';
import 'alert_notification_action_router.dart';
import 'alert_notification_payload_codec.dart';
import 'ios_alert_notification_category_factory.dart';

class FlutterLocalNotificationGateway {
  final FlutterLocalNotificationsPlugin plugin;
  final AlertNotificationPayloadCodec payloadCodec;
  final AlertNotificationId notificationId;
  final AndroidAlertNotificationActionFactory androidActionFactory;
  final IosAlertNotificationCategoryFactory iosCategoryFactory;
  final DidReceiveBackgroundNotificationResponseCallback?
      backgroundActionHandler;
  final Locale? Function()? localeProvider;
  AlertNotificationActionRouter? _actionRouter;
  bool _initialized = false;

  FlutterLocalNotificationGateway({
    FlutterLocalNotificationsPlugin? plugin,
    this.payloadCodec = const AlertNotificationPayloadCodec(),
    this.notificationId = const AlertNotificationId(),
    this.androidActionFactory = const AndroidAlertNotificationActionFactory(),
    this.iosCategoryFactory = const IosAlertNotificationCategoryFactory(),
    this.backgroundActionHandler,
    this.localeProvider,
  }) : plugin = plugin ?? FlutterLocalNotificationsPlugin();

  void bindActionRouter(AlertNotificationActionRouter router) {
    _actionRouter = router;
  }

  Future<void> initialize() async {
    if (_initialized) return;
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final darwin = DarwinInitializationSettings(
      notificationCategories: iosCategoryFactory.categories(l10n: _l10n()),
    );
    final settings = InitializationSettings(android: android, iOS: darwin);
    await plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        _actionRouter?.handle(response);
      },
      onDidReceiveBackgroundNotificationResponse: backgroundActionHandler,
    );
    _initialized = true;
    if (Platform.isAndroid) {
      await plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
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
      actions: androidActionFactory.actions(l10n: _l10n()),
    );
    const darwin = DarwinNotificationDetails(
      categoryIdentifier: AlertNotificationActionCategory.alertActions,
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    await plugin.show(
      notificationId.fromAlertEventId(event.id),
      event.title,
      event.body,
      NotificationDetails(android: android, iOS: darwin),
      payload: payloadCodec.encode(alertEventId: event.id),
    );
  }

  Future<void> cancel(String alertEventId) async {
    await initialize();
    await plugin.cancel(notificationId.fromAlertEventId(alertEventId));
  }

  Future<void> cancelAll() async {
    await initialize();
    await plugin.cancelAll();
  }

  AlertingLocalizations _l10n() {
    return AlertingL10nResolver.resolve(
      localeProvider?.call() ?? PlatformDispatcher.instance.locale,
    );
  }
}
