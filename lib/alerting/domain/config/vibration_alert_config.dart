import '../resource/alert_vibration_pattern.dart';
import 'alert_strategy_config.dart';

class VibrationAlertConfig implements AlertStrategyConfig {
  static const key = 'vibration';
  @override
  final bool enabled;
  final AlertVibrationPattern criticalPattern;
  final AlertVibrationPattern warningPattern;
  final bool repeatCritical;

  const VibrationAlertConfig({
    this.enabled = true,
    this.criticalPattern = const AlertVibrationPattern.criticalRepeat(),
    this.warningPattern = const AlertVibrationPattern.shortWarning(),
    this.repeatCritical = true,
  });

  @override
  String get strategyKey => key;

  @override
  Map<String, Object?> toJson() => {
    'enabled': enabled,
    'criticalPattern': criticalPattern.toJson(),
    'warningPattern': warningPattern.toJson(),
    'repeatCritical': repeatCritical,
  };

  static VibrationAlertConfig fromJson(Map<String, Object?> json) {
    return VibrationAlertConfig(
      enabled: json['enabled'] as bool? ?? true,
      criticalPattern: AlertVibrationPattern.fromJson(
        (json['criticalPattern'] as Map?)?.cast<String, Object?>() ?? const {},
      ),
      warningPattern: AlertVibrationPattern.fromJson(
        (json['warningPattern'] as Map?)?.cast<String, Object?>() ?? const {},
      ),
      repeatCritical: json['repeatCritical'] as bool? ?? true,
    );
  }
}
