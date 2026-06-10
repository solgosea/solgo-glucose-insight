import '../../domain/channel/alert_channel.dart';
import '../../domain/channel/alert_delivery_result.dart';
import '../../domain/config/vibration_alert_config.dart';
import '../../domain/event/alert_event.dart';
import '../../domain/event/alert_level.dart';
import '../../domain/actuator/alert_actuator_command.dart';
import '../../application/actuator/alert_actuator_command_bus.dart';
import '../../infrastructure/vibration/alert_vibration_gateway.dart';
import '../alert_strategy.dart';

class VibrationAlertStrategy implements AlertStrategy<VibrationAlertConfig> {
  final AlertVibrationGateway gateway;
  final AlertActuatorCommandBus? commandBus;

  const VibrationAlertStrategy({
    this.gateway = const AlertVibrationGateway(),
    this.commandBus,
  });

  @override
  String get strategyKey => VibrationAlertConfig.key;

  @override
  AlertChannel get channel => AlertChannel.vibration;

  @override
  bool supports(AlertEvent event) => true;

  @override
  Future<AlertDeliveryResult> deliver(
    AlertEvent event,
    VibrationAlertConfig config,
  ) async {
    if (!config.enabled) {
      return const AlertDeliveryResult.skipped(
        channel: AlertChannel.vibration,
        message: 'Vibration alert is disabled.',
      );
    }
    try {
      final pattern =
          event.level == AlertLevel.critical
              ? config.criticalPattern
              : config.warningPattern;
      if (commandBus != null) {
        final results = await commandBus!.dispatch(
          AlertActuatorCommand.vibrate(
            id: commandBus!.idGenerator.newId('act'),
            event: event,
            pattern: pattern,
            createdAt: DateTime.now(),
          ),
        );
        final failed = results.where((result) => !result.success).toList();
        if (failed.isNotEmpty) {
          return AlertDeliveryResult.failed(
            channel: AlertChannel.vibration,
            message: failed.first.message,
          );
        }
        return const AlertDeliveryResult.delivered(
          channel: AlertChannel.vibration,
          message: 'Vibration alert command dispatched.',
        );
      }
      await gateway.vibrate(pattern);
      return const AlertDeliveryResult.delivered(
        channel: AlertChannel.vibration,
        message: 'Vibration alert delivered.',
      );
    } catch (error) {
      return AlertDeliveryResult.failed(
        channel: AlertChannel.vibration,
        message: 'Vibration alert failed: $error',
      );
    }
  }

  @override
  Future<void> stop(String alertEventId) async {
    if (commandBus != null) {
      await commandBus!.stopEvent(alertEventId);
    }
  }
}
