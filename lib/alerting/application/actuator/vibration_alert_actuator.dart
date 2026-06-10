import '../../domain/actuator/alert_actuator_command.dart';
import '../../domain/actuator/alert_actuator_command_type.dart';
import '../../domain/actuator/alert_actuator_result.dart';
import '../../infrastructure/vibration/alert_vibration_gateway.dart';
import 'alert_actuator.dart';

class VibrationAlertActuator implements AlertActuator {
  final AlertVibrationGateway gateway;

  const VibrationAlertActuator({this.gateway = const AlertVibrationGateway()});

  @override
  bool supports(AlertActuatorCommand command) {
    return switch (command.type) {
      AlertActuatorCommandType.vibrate ||
      AlertActuatorCommandType.stopEvent ||
      AlertActuatorCommandType.stopTarget ||
      AlertActuatorCommandType.stopAll => true,
      _ => false,
    };
  }

  @override
  Future<AlertActuatorResult> execute(AlertActuatorCommand command) async {
    switch (command.type) {
      case AlertActuatorCommandType.vibrate:
        final pattern = command.vibrationPattern;
        if (pattern == null) {
          return const AlertActuatorResult.failure(
            message: 'Vibration command is missing pattern.',
          );
        }
        await gateway.vibrate(pattern);
        return const AlertActuatorResult.success(
          message: 'Vibration alert delivered.',
        );
      case AlertActuatorCommandType.stopEvent:
      case AlertActuatorCommandType.stopTarget:
      case AlertActuatorCommandType.stopAll:
        await gateway.cancel();
        return const AlertActuatorResult.success(
          message: 'Vibration alert stopped.',
        );
      default:
        return const AlertActuatorResult.failure(
          message: 'Unsupported vibration actuator command.',
        );
    }
  }
}
