import '../../../domain/event/alert_category.dart';
import '../../../domain/rule/alert_rule.dart';
import '../../../domain/rule/alert_rule_comparator.dart';
import '../../../domain/rule/alert_rule_evaluation_result.dart';
import '../alert_rule_evaluator.dart';

class GlucoseRapidFallRuleEvaluator extends AlertRuleEvaluator {
  const GlucoseRapidFallRuleEvaluator();

  @override
  bool supports(AlertRule rule) {
    return rule.category == AlertCategory.glucoseRapidFall &&
        rule.comparator == AlertRuleComparator.rateBelow;
  }

  @override
  AlertRuleEvaluationResult? evaluate(
    AlertRule rule,
    AlertRuleEvaluationContext context,
  ) {
    final latest = context.latest;
    final threshold = rule.thresholdValue;
    final rate = latest?.ratePerMin;
    if (latest == null ||
        threshold == null ||
        rate == null ||
        rate > threshold) {
      return null;
    }
    return AlertRuleEvaluationResult(
      rule: rule,
      category: rule.category,
      level: rule.level,
      type: 'rapidFall',
      title: 'Rapid fall',
      body: 'Glucose is falling quickly.',
      value: latest.value,
      occurredAt: latest.timestamp,
    );
  }
}
