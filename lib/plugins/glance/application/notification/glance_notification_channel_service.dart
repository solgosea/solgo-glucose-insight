import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../i18n/glance_l10n_resolver.dart';
import 'glance_notification_channels.dart';

class GlanceNotificationChannelService {
  final FlutterLocalNotificationsPlugin plugin;

  const GlanceNotificationChannelService({
    required this.plugin,
  });

  Future<void> ensureConfigured() async {
    final androidPlugin = plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final l10n = GlanceL10nResolver.fallback;
    await androidPlugin?.createNotificationChannel(
      AndroidNotificationChannel(
        GlanceNotificationChannels.lockScreen,
        l10n.glanceNotificationChannelTitle,
        description: l10n.glanceNotificationChannelDescription,
        importance: Importance.high,
        playSound: false,
        enableVibration: false,
        showBadge: false,
      ),
    );
  }
}
