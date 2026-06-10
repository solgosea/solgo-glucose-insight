abstract class AlertStrategyConfig {
  String get strategyKey;
  bool get enabled;
  Map<String, Object?> toJson();
}
