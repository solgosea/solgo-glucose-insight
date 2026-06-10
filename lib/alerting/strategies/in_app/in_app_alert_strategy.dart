import '../../domain/channel/alert_channel.dart';
import '../../domain/channel/alert_delivery_result.dart';
import '../../domain/config/in_app_alert_config.dart';
import '../../domain/event/alert_event.dart';
import '../../presentation/overlays/alert_overlay_signal_bus.dart';
import '../alert_strategy.dart';

class InAppAlertStrategy implements AlertStrategy<InAppAlertConfig> {
  final AlertOverlaySignalBus signalBus;

  const InAppAlertStrategy({required this.signalBus});

  @override
  String get strategyKey => InAppAlertConfig.key;

  @override
  AlertChannel get channel => AlertChannel.inApp;

  @override
  bool supports(AlertEvent event) => true;

  @override
  Future<AlertDeliveryResult> deliver(
    AlertEvent event,
    InAppAlertConfig config,
  ) async {
    if (!config.enabled) {
      return const AlertDeliveryResult.skipped(
        channel: AlertChannel.inApp,
        message: 'In-app alert is disabled.',
      );
    }
    signalBus.show(event);
    return const AlertDeliveryResult.delivered(
      channel: AlertChannel.inApp,
      message: 'In-app alert queued.',
    );
  }

  @override
  Future<void> stop(String alertEventId) async {}
}
