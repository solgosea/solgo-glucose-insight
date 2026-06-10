import '../../../domain/entities/glucose_reading.dart';
import '../../domain/rule/alert_rule.dart';
import '../../domain/rule/alert_rule_evaluation_result.dart';

class AlertRuleEvaluationContext {
  final List<GlucoseReading> readings;
  final DateTime now;

  const AlertRuleEvaluationContext({required this.readings, required this.now});

  GlucoseReading? get latest => readings.isEmpty ? null : readings.last;
}

abstract class AlertRuleEvaluator {
  const AlertRuleEvaluator();

  bool supports(AlertRule rule);

  AlertRuleEvaluationResult? evaluate(
    AlertRule rule,
    AlertRuleEvaluationContext context,
  );
}
