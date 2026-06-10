import '../../domain/actuator/alert_actuator_result.dart';
import '../../domain/control/alert_control_action.dart';
import '../../domain/control/alert_control_action_type.dart';
import '../../shared/alert_id_generator.dart';
import '../actuator/alert_actuator_command_bus.dart';

class AlertOrchestrator {
  final AlertActuatorCommandBus commandBus;
  final AlertIdGenerator idGenerator;

  const AlertOrchestrator({
    required this.commandBus,
    this.idGenerator = const AlertIdGenerator(),
  });

  Future<List<AlertActuatorResult>> handle(AlertControlAction action) {
    return switch (action.type) {
      AlertControlActionType.snooze ||
      AlertControlActionType.acknowledge ||
      AlertControlActionType.recover ||
      AlertControlActionType.disableRule ||
      AlertControlActionType.stop => _stopActionTarget(action),
    };
  }

  Future<List<AlertActuatorResult>> stopTargetType({
    required String targetId,
    required String type,
    AlertControlActionType reason = AlertControlActionType.stop,
  }) {
    return handle(
      AlertControlAction.stopTargetType(
        id: idGenerator.newId('alert_action'),
        type: reason,
        targetId: targetId,
        alertType: type,
        occurredAt: DateTime.now(),
      ),
    );
  }

  Future<List<AlertActuatorResult>> stopAll() {
    return commandBus.stopAll();
  }

  Future<List<AlertActuatorResult>> _stopActionTarget(
    AlertControlAction action,
  ) {
    final targetId = action.target.targetId;
    final type = action.target.type;
    final eventId = action.target.eventId;
    if (targetId != null &&
        targetId.isNotEmpty &&
        type != null &&
        type.isNotEmpty) {
      return commandBus.stopTargetType(targetId: targetId, type: type);
    }
    if (eventId != null && eventId.isNotEmpty) {
      return commandBus.stopEvent(eventId);
    }
    return commandBus.stopAll();
  }
}
