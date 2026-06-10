import '../../domain/action/alert_action.dart';
import '../../domain/action/alert_action_result.dart';
import '../../domain/actuator/alert_actuator_target.dart';
import '../../domain/event/alert_event_state.dart';
import '../../domain/repository/alert_action_repository.dart';
import '../../domain/repository/alert_event_repository.dart';
import 'alert_snooze_policy.dart';

class AlertActionService {
  final AlertEventRepository eventRepository;
  final AlertActionRepository actionRepository;

  const AlertActionService({
    required this.eventRepository,
    required this.actionRepository,
  });

  Future<AlertActionResult> apply(
    String eventId,
    AlertAction action, {
    String actor = 'local_user',
    Duration snoozeDuration = AlertSnoozePolicy.defaultDuration,
  }) async {
    final event = await eventRepository.byId(eventId);
    final state = switch (action) {
      AlertAction.acknowledge => AlertEventState.acknowledged,
      AlertAction.snooze => AlertEventState.snoozed,
      AlertAction.dismiss => AlertEventState.dismissed,
      AlertAction.stop => AlertEventState.dismissed,
    };
    await eventRepository.updateState(eventId, state);
    await actionRepository.insertAction(
      alertEventId: eventId,
      action: action,
      actor: actor,
    );
    if (action == AlertAction.snooze) {
      final target =
          event == null
              ? const AlertActuatorTarget()
              : AlertActuatorTarget.fromEvent(event);
      await actionRepository.insertSnooze(
        alertEventId: eventId,
        snoozedUntil: DateTime.now().add(snoozeDuration),
        targetId: target.targetId,
        alertType: target.type,
        source: event?.source.code,
        category: event?.category.code,
        level: event?.level.code,
        reason: 'User snoozed alert.',
      );
    }
    return const AlertActionResult(success: true, message: 'Updated.');
  }
}
