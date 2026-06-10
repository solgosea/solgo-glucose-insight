import '../../domain/action/alert_action.dart';
import '../../domain/action/alert_action_result.dart';
import '../../domain/actuator/alert_actuator_target.dart';
import '../../domain/control/alert_control_action_type.dart';
import '../../domain/event/alert_event.dart';
import '../orchestration/alert_orchestrator.dart';
import 'alert_action_service.dart';
import 'alert_snooze_policy.dart';

class AlertActionOrchestrator {
  final AlertActionService actionService;
  final AlertOrchestrator actuatorOrchestrator;
  final AlertSnoozePolicy snoozePolicy;

  const AlertActionOrchestrator({
    required this.actionService,
    required this.actuatorOrchestrator,
    this.snoozePolicy = const AlertSnoozePolicy(),
  });

  Future<AlertActionResult> apply(
    AlertEvent event,
    AlertAction action, {
    String actor = 'local_user',
  }) async {
    final result = await actionService.apply(
      event.id,
      action,
      actor: actor,
      snoozeDuration: AlertSnoozePolicy.defaultDuration,
    );
    if (action == AlertAction.snooze ||
        action == AlertAction.stop ||
        action == AlertAction.dismiss) {
      await _stopEventTarget(event, action);
    }
    return result;
  }

  Future<void> _stopEventTarget(AlertEvent event, AlertAction action) async {
    final target = AlertActuatorTarget.fromEvent(event);
    final type = target.type;
    final targetId = target.targetId;
    final reason = switch (action) {
      AlertAction.snooze => AlertControlActionType.snooze,
      AlertAction.acknowledge => AlertControlActionType.acknowledge,
      AlertAction.dismiss || AlertAction.stop => AlertControlActionType.stop,
    };
    if (targetId != null &&
        targetId.isNotEmpty &&
        type != null &&
        type.isNotEmpty) {
      await actuatorOrchestrator.stopTargetType(
        targetId: targetId,
        type: type,
        reason: reason,
      );
      return;
    }
    await actuatorOrchestrator.stopAll();
  }
}
