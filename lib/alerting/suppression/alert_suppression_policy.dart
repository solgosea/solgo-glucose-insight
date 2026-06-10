import '../domain/event/alert_event.dart';
import 'alert_suppression_decision.dart';

abstract interface class AlertSuppressionPolicy {
  String get id;

  Future<AlertSuppressionDecision> evaluate(AlertEvent event);
}
