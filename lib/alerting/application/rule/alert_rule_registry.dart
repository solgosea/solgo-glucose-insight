import 'alert_rule_evaluator.dart';
import '../../domain/rule/alert_rule.dart';
import 'evaluators/glucose_high_rule_evaluator.dart';
import 'evaluators/glucose_low_rule_evaluator.dart';
import 'evaluators/glucose_no_data_rule_evaluator.dart';
import 'evaluators/glucose_rapid_fall_rule_evaluator.dart';
import 'evaluators/glucose_urgent_low_rule_evaluator.dart';

class AlertRuleRegistry {
  static const defaults = AlertRuleRegistry([
    GlucoseNoDataRuleEvaluator(),
    GlucoseUrgentLowRuleEvaluator(),
    GlucoseLowRuleEvaluator(),
    GlucoseHighRuleEvaluator(),
    GlucoseRapidFallRuleEvaluator(),
  ]);

  final List<AlertRuleEvaluator> evaluators;

  const AlertRuleRegistry(this.evaluators);

  AlertRuleEvaluator? evaluatorFor(AlertRule rule) {
    for (final evaluator in evaluators) {
      if (evaluator.supports(rule)) return evaluator;
    }
    return null;
  }
}
