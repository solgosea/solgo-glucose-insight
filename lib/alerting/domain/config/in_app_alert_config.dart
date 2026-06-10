import 'alert_strategy_config.dart';

class InAppAlertConfig implements AlertStrategyConfig {
  static const key = 'in_app';
  @override
  final bool enabled;
  final bool fullScreenForCritical;
  final int warningAutoDismissSeconds;

  const InAppAlertConfig({
    this.enabled = true,
    this.fullScreenForCritical = true,
    this.warningAutoDismissSeconds = 8,
  });

  @override
  String get strategyKey => key;

  @override
  Map<String, Object?> toJson() => {
    'enabled': enabled,
    'fullScreenForCritical': fullScreenForCritical,
    'warningAutoDismissSeconds': warningAutoDismissSeconds,
  };

  static InAppAlertConfig fromJson(Map<String, Object?> json) {
    return InAppAlertConfig(
      enabled: json['enabled'] as bool? ?? true,
      fullScreenForCritical: json['fullScreenForCritical'] as bool? ?? true,
      warningAutoDismissSeconds:
          (json['warningAutoDismissSeconds'] as num?)?.round() ?? 8,
    );
  }
}
