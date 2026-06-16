import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../domain/glance_display_mode.dart';
import '../../domain/glance_lock_screen_mode.dart';

class GlanceNotificationVisibilityPolicy {
  const GlanceNotificationVisibilityPolicy();

  NotificationVisibility forDisplayMode(GlanceDisplayMode mode) {
    return mode == GlanceDisplayMode.private || mode == GlanceDisplayMode.off
        ? NotificationVisibility.private
        : NotificationVisibility.public;
  }

  NotificationVisibility forLockScreenMode(GlanceLockScreenMode mode) {
    return mode == GlanceLockScreenMode.private ||
            mode == GlanceLockScreenMode.off
        ? NotificationVisibility.private
        : NotificationVisibility.public;
  }
}
