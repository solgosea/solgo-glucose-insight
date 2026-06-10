import '../../domain/config/alerting_global_config.dart';
import '../../domain/config/in_app_alert_config.dart';
import '../../domain/config/local_notification_alert_config.dart';
import '../../domain/config/sound_alert_config.dart';
import '../../domain/config/vibration_alert_config.dart';
import '../../domain/repository/alert_strategy_config_repository.dart';

class DefaultAlertingSettings {
  const DefaultAlertingSettings();

  AlertStrategyConfigSet build() => const AlertStrategyConfigSet(
    global: AlertingGlobalConfig(),
    inApp: InAppAlertConfig(),
    localNotification: LocalNotificationAlertConfig(),
    sound: SoundAlertConfig(),
    vibration: VibrationAlertConfig(),
  );
}
