import '../domain/channel/alert_channel.dart';
import '../domain/channel/alert_delivery_result.dart';
import '../domain/config/alert_strategy_config.dart';
import '../domain/event/alert_event.dart';

abstract class AlertStrategy<T extends AlertStrategyConfig> {
  String get strategyKey;
  AlertChannel get channel;
  bool supports(AlertEvent event);
  Future<AlertDeliveryResult> deliver(AlertEvent event, T config);
  Future<void> stop(String alertEventId) async {}
}
