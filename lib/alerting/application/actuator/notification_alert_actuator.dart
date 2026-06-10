import '../../domain/actuator/alert_actuator_command.dart';
import '../../domain/actuator/alert_actuator_command_type.dart';
import '../../domain/actuator/alert_actuator_result.dart';
import '../../infrastructure/local_notifications/flutter_local_notification_gateway.dart';
import 'alert_actuator.dart';

class NotificationAlertActuator implements AlertActuator {
  final FlutterLocalNotificationGateway gateway;

  const NotificationAlertActuator({required this.gateway});

  @override
  bool supports(AlertActuatorCommand command) {
    return switch (command.type) {
      AlertActuatorCommandType.showNotification ||
      AlertActuatorCommandType.stopEvent ||
      AlertActuatorCommandType.stopAll => true,
      _ => false,
    };
  }

  @override
  Future<AlertActuatorResult> execute(AlertActuatorCommand command) async {
    switch (command.type) {
      case AlertActuatorCommandType.showNotification:
        final event = command.event;
        final config = command.notificationConfig;
        if (event == null || config == null) {
          return const AlertActuatorResult.failure(
            message: 'Notification command is missing event or config.',
          );
        }
        await gateway.show(event, config);
        return const AlertActuatorResult.success(
          message: 'System notification delivered.',
        );
      case AlertActuatorCommandType.stopEvent:
        final eventId = command.target.eventId;
        if (eventId != null && eventId.isNotEmpty) {
          await gateway.cancel(eventId);
        }
        return const AlertActuatorResult.success(
          message: 'System notification cancelled.',
        );
      case AlertActuatorCommandType.stopAll:
        await gateway.cancelAll();
        return const AlertActuatorResult.success(
          message: 'All system notifications cancelled.',
        );
      default:
        return const AlertActuatorResult.failure(
          message: 'Unsupported notification actuator command.',
        );
    }
  }
}
