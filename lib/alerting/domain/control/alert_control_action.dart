import '../actuator/alert_actuator_target.dart';
import 'alert_control_action_type.dart';

class AlertControlAction {
  final String id;
  final AlertControlActionType type;
  final AlertActuatorTarget target;
  final String actor;
  final DateTime occurredAt;
  final Map<String, Object?> metadata;

  const AlertControlAction({
    required this.id,
    required this.type,
    required this.target,
    required this.actor,
    required this.occurredAt,
    this.metadata = const {},
  });

  factory AlertControlAction.stopTargetType({
    required String id,
    required AlertControlActionType type,
    required String targetId,
    required String alertType,
    required DateTime occurredAt,
    String actor = 'local_user',
    Map<String, Object?> metadata = const {},
  }) {
    return AlertControlAction(
      id: id,
      type: type,
      target: AlertActuatorTarget(targetId: targetId, type: alertType),
      actor: actor,
      occurredAt: occurredAt,
      metadata: metadata,
    );
  }
}
