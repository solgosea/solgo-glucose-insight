import '../../../domain/entities/glucose_reading.dart';
import '../../domain/rule/alert_rule.dart';
import '../../domain/rule/alert_rule_evaluation_result.dart';
import 'alert_rule_evaluator.dart';
import 'alert_rule_registry.dart';

class AlertRuleEngine {
  final AlertRuleRegistry registry;

  const AlertRuleEngine({this.registry = AlertRuleRegistry.defaults});

  List<AlertRuleEvaluationResult> evaluate({
    required List<GlucoseReading> readings,
    required List<AlertRule> rules,
    required DateTime now,
  }) {
    final context = AlertRuleEvaluationContext(readings: readings, now: now);
    final results = <AlertRuleEvaluationResult>[];
    for (final rule in rules.where((rule) => rule.enabled)) {
      final evaluator = registry.evaluatorFor(rule);
      final result = evaluator?.evaluate(rule, context);
      if (result != null) results.add(result);
    }
    results.sort((a, b) => b.rule.priority.compareTo(a.rule.priority));
    return results;
  }
}
