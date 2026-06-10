import '../../../domain/event/alert_category.dart';
import '../../../domain/rule/alert_rule.dart';
import '../../../domain/rule/alert_rule_comparator.dart';
import '../../../domain/rule/alert_rule_evaluation_result.dart';
import '../alert_rule_evaluator.dart';

class GlucoseNoDataRuleEvaluator extends AlertRuleEvaluator {
  const GlucoseNoDataRuleEvaluator();

  @override
  bool supports(AlertRule rule) {
    return rule.category == AlertCategory.noData &&
        rule.comparator == AlertRuleComparator.staleForMinutes;
  }

  @override
  AlertRuleEvaluationResult? evaluate(
    AlertRule rule,
    AlertRuleEvaluationContext context,
  ) {
    final minutes = rule.thresholdValue ?? 20;
    final latest = context.latest;
    final stale =
        latest == null ||
        context.now.difference(latest.timestamp).inSeconds >= minutes * 60;
    if (!stale) return null;
    return AlertRuleEvaluationResult(
      rule: rule,
      category: rule.category,
      level: rule.level,
      type: 'noData',
      title: 'No recent glucose data',
      body: 'No fresh glucose data has been received recently.',
      value: null,
      occurredAt: latest?.timestamp ?? context.now,
    );
  }
}
