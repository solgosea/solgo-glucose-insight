import '../../../domain/event/alert_category.dart';
import '../../../domain/rule/alert_rule.dart';
import '../../../domain/rule/alert_rule_comparator.dart';
import '../../../domain/rule/alert_rule_evaluation_result.dart';
import '../alert_rule_evaluator.dart';

class GlucoseLowRuleEvaluator extends AlertRuleEvaluator {
  const GlucoseLowRuleEvaluator();

  @override
  bool supports(AlertRule rule) {
    return rule.category == AlertCategory.glucoseLow &&
        rule.comparator == AlertRuleComparator.lessThan;
  }

  @override
  AlertRuleEvaluationResult? evaluate(
    AlertRule rule,
    AlertRuleEvaluationContext context,
  ) {
    final latest = context.latest;
    final threshold = rule.thresholdValue;
    if (latest == null || threshold == null || latest.value >= threshold) {
      return null;
    }
    return AlertRuleEvaluationResult(
      rule: rule,
      category: rule.category,
      level: rule.level,
      type: 'low',
      title: 'Low glucose',
      body: 'Glucose is ${latest.value.toStringAsFixed(1)} mmol/L.',
      value: latest.value,
      occurredAt: latest.timestamp,
    );
  }
}
