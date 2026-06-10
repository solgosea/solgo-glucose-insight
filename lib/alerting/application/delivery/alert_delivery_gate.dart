import '../../domain/event/alert_event.dart';
import '../../suppression/alert_suppression_decision.dart';
import '../../suppression/alert_suppression_policy_registry.dart';

class AlertDeliveryGate {
  final AlertSuppressionPolicyRegistry suppressionRegistry;

  const AlertDeliveryGate({required this.suppressionRegistry});

  Future<AlertSuppressionDecision> evaluate(AlertEvent event) {
    return suppressionRegistry.evaluate(event);
  }
}
