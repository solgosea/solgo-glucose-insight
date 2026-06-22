import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../application/i18n/alerting_l10n_resolver.dart';
import '../../l10n/generated/alerting_localizations.dart';
import 'alert_notification_action_ids.dart';

class AndroidAlertNotificationActionFactory {
  const AndroidAlertNotificationActionFactory();

  List<AndroidNotificationAction> actions({
    AlertingLocalizations? l10n,
  }) {
    final strings = l10n ?? AlertingL10nResolver.fallback;
    return [
      AndroidNotificationAction(
        AlertNotificationActionIds.snooze,
        strings.alertActionSnooze5m,
        showsUserInterface: false,
        cancelNotification: true,
      ),
      AndroidNotificationAction(
        AlertNotificationActionIds.dismiss,
        strings.alertActionDismiss,
        showsUserInterface: false,
        cancelNotification: true,
      ),
    ];
  }
}
