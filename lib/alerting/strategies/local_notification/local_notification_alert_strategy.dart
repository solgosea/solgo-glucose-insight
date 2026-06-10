import '../../domain/channel/alert_channel.dart';
import '../../domain/channel/alert_delivery_result.dart';
import '../../domain/config/local_notification_alert_config.dart';
import '../../domain/event/alert_event.dart';
import '../../domain/actuator/alert_actuator_command.dart';
import '../../application/actuator/alert_actuator_command_bus.dart';
import '../../infrastructure/local_notifications/flutter_local_notification_gateway.dart';
import '../alert_strategy.dart';

class LocalNotificationAlertStrategy
    implements AlertStrategy<LocalNotificationAlertConfig> {
  final FlutterLocalNotificationGateway gateway;
  final AlertActuatorCommandBus? commandBus;

  const LocalNotificationAlertStrategy({
    required this.gateway,
    this.commandBus,
  });

  @override
  String get strategyKey => LocalNotificationAlertConfig.key;

  @override
  AlertChannel get channel => AlertChannel.localNotification;

  @override
  bool supports(AlertEvent event) => true;

  @override
  Future<AlertDeliveryResult> deliver(
    AlertEvent event,
    LocalNotificationAlertConfig config,
  ) async {
    if (!config.enabled) {
      return const AlertDeliveryResult.skipped(
        channel: AlertChannel.localNotification,
        message: 'Local notification is disabled.',
      );
    }
    try {
      if (commandBus != null) {
        final results = await commandBus!.dispatch(
          AlertActuatorCommand.showNotification(
            id: commandBus!.idGenerator.newId('act'),
            event: event,
            config: config,
            createdAt: DateTime.now(),
          ),
        );
        final failed = results.where((result) => !result.success).toList();
        if (failed.isNotEmpty) {
          return AlertDeliveryResult.failed(
            channel: AlertChannel.localNotification,
            message: failed.first.message,
          );
        }
        return const AlertDeliveryResult.delivered(
          channel: AlertChannel.localNotification,
          message: 'System notification command dispatched.',
        );
      }
      await gateway.show(event, config);
      return const AlertDeliveryResult.delivered(
        channel: AlertChannel.localNotification,
        message: 'System notification delivered.',
      );
    } catch (error) {
      return AlertDeliveryResult.failed(
        channel: AlertChannel.localNotification,
        message: 'System notification failed: $error',
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
