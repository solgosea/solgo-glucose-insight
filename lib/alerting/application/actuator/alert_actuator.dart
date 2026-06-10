import '../../domain/actuator/alert_actuator_command.dart';
import '../../domain/actuator/alert_actuator_result.dart';

abstract interface class AlertActuator {
  bool supports(AlertActuatorCommand command);

  Future<AlertActuatorResult> execute(AlertActuatorCommand command);
}
