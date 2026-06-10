import '../domain/actuator/alert_actuator_target.dart';
import '../domain/event/alert_event.dart';
import '../domain/repository/alert_action_repository.dart';
import 'alert_suppression_decision.dart';
import 'alert_suppression_policy.dart';

class AlertCoreSnoozeSuppressionPolicy implements AlertSuppressionPolicy {
  final AlertActionRepository repository;
  final DateTime Function() clock;

  const AlertCoreSnoozeSuppressionPolicy({
    required this.repository,
    DateTime Function()? clock,
  }) : clock = clock ?? DateTime.now;

  @override
  String get id => 'alerting.core.snooze';

  @override
  Future<AlertSuppressionDecision> evaluate(AlertEvent event) async {
    final target = AlertActuatorTarget.fromEvent(event);
    final targetId = target.targetId;
    final type = target.type;
    if (targetId == null || targetId.isEmpty || type == null || type.isEmpty) {
      return const AlertSuppressionDecision.allowed();
    }
    final until = await repository.activeSnoozeUntil(
      targetId: targetId,
      alertType: type,
      now: clock(),
    );
    if (until == null) return const AlertSuppressionDecision.allowed();
    return const AlertSuppressionDecision.suppressed('alerting.snoozed');
  }
}
