import '../../domain/actuator/alert_actuator_command.dart';
import '../../domain/actuator/alert_actuator_result.dart';
import '../../shared/alert_id_generator.dart';
import 'alert_actuator_command_queue.dart';
import 'alert_actuator_dispatcher.dart';

typedef AlertActuatorBackgroundForwarder =
    Future<void> Function(AlertActuatorCommand command);

class AlertActuatorCommandBus {
  final AlertActuatorCommandQueue queue;
  final AlertActuatorDispatcher dispatcher;
  final AlertIdGenerator idGenerator;
  final AlertActuatorBackgroundForwarder? backgroundForwarder;

  const AlertActuatorCommandBus({
    required this.queue,
    required this.dispatcher,
    this.idGenerator = const AlertIdGenerator(),
    this.backgroundForwarder,
  });

  Future<List<AlertActuatorResult>> dispatch(
    AlertActuatorCommand command, {
    bool forwardToBackground = false,
  }) async {
    queue.publish(command);
    final results = await dispatcher.dispatch(command);
    if (forwardToBackground) {
      await backgroundForwarder?.call(command);
    }
    return results;
  }

  Future<List<AlertActuatorResult>> stopEvent(
    String eventId, {
    bool forwardToBackground = true,
  }) {
    return dispatch(
      AlertActuatorCommand.stopEvent(
        id: idGenerator.newId('act'),
        eventId: eventId,
        createdAt: DateTime.now(),
      ),
      forwardToBackground: forwardToBackground,
    );
  }

  Future<List<AlertActuatorResult>> stopTargetType({
    required String targetId,
    required String type,
    bool forwardToBackground = true,
  }) {
    return dispatch(
      AlertActuatorCommand.stopTarget(
        id: idGenerator.newId('act'),
        targetId: targetId,
        type: type,
        createdAt: DateTime.now(),
      ),
      forwardToBackground: forwardToBackground,
    );
  }

  Future<List<AlertActuatorResult>> stopAll({bool forwardToBackground = true}) {
    return dispatch(
      AlertActuatorCommand.stopAll(
        id: idGenerator.newId('act'),
        createdAt: DateTime.now(),
      ),
      forwardToBackground: forwardToBackground,
    );
  }
}
