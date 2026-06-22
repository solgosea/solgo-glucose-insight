import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../application/i18n/alerting_l10n_resolver.dart';
import '../../domain/notification/alert_notification_action_category.dart';
import '../../l10n/generated/alerting_localizations.dart';
import 'alert_notification_action_ids.dart';

class IosAlertNotificationCategoryFactory {
  const IosAlertNotificationCategoryFactory();

  List<DarwinNotificationCategory> categories({
    AlertingLocalizations? l10n,
  }) {
    final strings = l10n ?? AlertingL10nResolver.fallback;
    return [
      DarwinNotificationCategory(
        AlertNotificationActionCategory.alertActions,
        actions: [
          DarwinNotificationAction.plain(
            AlertNotificationActionIds.snooze,
            strings.alertActionSnooze5m,
          ),
          DarwinNotificationAction.plain(
            AlertNotificationActionIds.dismiss,
            strings.alertActionDismiss,
            options: {
              DarwinNotificationActionOption.destructive,
            },
          ),
        ],
      ),
    ];
  }
}
