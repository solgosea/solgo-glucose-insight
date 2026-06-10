import '../../domain/actuator/alert_actuator_command.dart';
import '../../domain/actuator/alert_actuator_command_type.dart';
import '../../domain/actuator/alert_actuator_result.dart';
import '../sound/alert_sound_session_manager.dart';
import 'alert_actuator.dart';

class SoundAlertActuator implements AlertActuator {
  final AlertSoundSessionManager sessionManager;

  SoundAlertActuator({AlertSoundSessionManager? sessionManager})
    : sessionManager = sessionManager ?? AlertSoundSessionManager.shared;

  @override
  bool supports(AlertActuatorCommand command) {
    return switch (command.type) {
      AlertActuatorCommandType.playSound ||
      AlertActuatorCommandType.stopEvent ||
      AlertActuatorCommandType.stopTarget ||
      AlertActuatorCommandType.stopAll => true,
      _ => false,
    };
  }

  @override
  Future<AlertActuatorResult> execute(AlertActuatorCommand command) async {
    switch (command.type) {
      case AlertActuatorCommandType.playSound:
        final event = command.event;
        final sound = command.sound;
        final policy = command.soundPolicy;
        if (event == null || sound == null || policy == null) {
          return const AlertActuatorResult.failure(
            message: 'Sound command is missing event, sound, or policy.',
          );
        }
        sessionManager.start(event: event, sound: sound, policy: policy);
        return const AlertActuatorResult.success(
          message: 'Sound alert session started.',
        );
      case AlertActuatorCommandType.stopEvent:
        final eventId = command.target.eventId;
        if (eventId != null && eventId.isNotEmpty) {
          sessionManager.stopEvent(eventId);
        }
        return const AlertActuatorResult.success(
          message: 'Sound alert event stopped.',
        );
      case AlertActuatorCommandType.stopTarget:
        final targetId = command.target.targetId;
        final type = command.target.type;
        if (targetId != null &&
            targetId.isNotEmpty &&
            type != null &&
            type.isNotEmpty) {
          sessionManager.stopTargetType(targetId: targetId, type: type);
        }
        return const AlertActuatorResult.success(
          message: 'Sound alert target stopped.',
        );
      case AlertActuatorCommandType.stopAll:
        sessionManager.stopAll();
        return const AlertActuatorResult.success(
          message: 'All sound alerts stopped.',
        );
      default:
        return const AlertActuatorResult.failure(
          message: 'Unsupported sound actuator command.',
        );
    }
  }
}
