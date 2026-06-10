import '../resource/alert_notification_channel_ref.dart';
import 'alert_strategy_config.dart';

class LocalNotificationAlertConfig implements AlertStrategyConfig {
  static const key = 'local_notification';
  @override
  final bool enabled;
  final AlertNotificationChannelRef channel;
  final bool showCriticalOnLockScreen;

  const LocalNotificationAlertConfig({
    this.enabled = true,
    this.channel = const AlertNotificationChannelRef.critical(),
    this.showCriticalOnLockScreen = true,
  });

  @override
  String get strategyKey => key;

  @override
  Map<String, Object?> toJson() => {
    'enabled': enabled,
    'channel': channel.toJson(),
    'showCriticalOnLockScreen': showCriticalOnLockScreen,
  };

  static LocalNotificationAlertConfig fromJson(Map<String, Object?> json) {
    return LocalNotificationAlertConfig(
      enabled: json['enabled'] as bool? ?? true,
      channel: AlertNotificationChannelRef.fromJson(
        (json['channel'] as Map?)?.cast<String, Object?>() ?? const {},
      ),
      showCriticalOnLockScreen:
          json['showCriticalOnLockScreen'] as bool? ?? true,
    );
  }
}
