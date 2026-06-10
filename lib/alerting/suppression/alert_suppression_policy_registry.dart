import '../domain/event/alert_event.dart';
import 'alert_suppression_decision.dart';
import 'alert_suppression_policy.dart';

class AlertSuppressionPolicyRegistry {
  final List<AlertSuppressionPolicy> _policies = [];

  List<AlertSuppressionPolicy> get policies => List.unmodifiable(_policies);

  void register(AlertSuppressionPolicy policy) {
    if (_policies.any((candidate) => candidate.id == policy.id)) return;
    _policies.add(policy);
  }

  Future<AlertSuppressionDecision> evaluate(AlertEvent event) async {
    for (final policy in _policies) {
      final decision = await policy.evaluate(event);
      if (decision.suppressed) return decision;
    }
    return const AlertSuppressionDecision.allowed();
  }
}
