import '../../domain/actuator/alert_actuator_command.dart';
import '../../domain/actuator/alert_actuator_result.dart';
import 'alert_actuator.dart';

class AlertActuatorDispatcher {
  final List<AlertActuator> actuators;

  const AlertActuatorDispatcher({required this.actuators});

  Future<List<AlertActuatorResult>> dispatch(
    AlertActuatorCommand command,
  ) async {
    final supported =
        actuators.where((actuator) => actuator.supports(command)).toList();
    if (supported.isEmpty) {
      return [
        AlertActuatorResult.failure(
          message: 'No actuator supports ${command.type.code}.',
        ),
      ];
    }
    final results = <AlertActuatorResult>[];
    for (final actuator in supported) {
      results.add(await actuator.execute(command));
    }
    return results;
  }
}
