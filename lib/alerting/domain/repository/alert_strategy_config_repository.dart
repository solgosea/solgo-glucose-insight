import '../config/alert_strategy_config.dart';
import '../config/alerting_global_config.dart';
import '../config/in_app_alert_config.dart';
import '../config/local_notification_alert_config.dart';
import '../config/sound_alert_config.dart';
import '../config/vibration_alert_config.dart';

class AlertStrategyConfigSet {
  final AlertingGlobalConfig global;
  final InAppAlertConfig inApp;
  final LocalNotificationAlertConfig localNotification;
  final SoundAlertConfig sound;
  final VibrationAlertConfig vibration;

  const AlertStrategyConfigSet({
    this.global = const AlertingGlobalConfig(),
    this.inApp = const InAppAlertConfig(),
    this.localNotification = const LocalNotificationAlertConfig(),
    this.sound = const SoundAlertConfig(),
    this.vibration = const VibrationAlertConfig(),
  });

  AlertStrategyConfigSet copyWith({
    AlertingGlobalConfig? global,
    InAppAlertConfig? inApp,
    LocalNotificationAlertConfig? localNotification,
    SoundAlertConfig? sound,
    VibrationAlertConfig? vibration,
  }) {
    return AlertStrategyConfigSet(
      global: global ?? this.global,
      inApp: inApp ?? this.inApp,
      localNotification: localNotification ?? this.localNotification,
      sound: sound ?? this.sound,
      vibration: vibration ?? this.vibration,
    );
  }
}

abstract class AlertStrategyConfigRepository {
  Future<AlertStrategyConfigSet> load();
  Future<void> saveGlobal(AlertingGlobalConfig config);
  Future<void> save(AlertStrategyConfig config);
}
