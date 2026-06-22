import '../application/rule_engine/status_rule_evaluator.dart';
import '../application/rule_engine/status_rule_registry.dart';
import '../application/rules/status_metric_rule.dart';
import '../domain/analysis/status_analysis_context.dart';
import '../domain/analysis/status_rule_result.dart';
import '../domain/rules/status_rule_catalog.dart';
import '../domain/rules/status_rule_definition.dart';
import '../domain/rules/status_rule_group.dart';

class FakeStatusRuleCatalogFactory {
  const FakeStatusRuleCatalogFactory();

  StatusRuleRegistry single({
    required StatusRuleDefinition definition,
    required StatusRuleResult result,
  }) {
    return StatusRuleRegistry(
      catalog: StatusRuleCatalog(
        group: StatusRuleGroup.cgmSensor,
        definitions: [definition],
      ),
      evaluators: [
        StatusRuleEvaluator(
          definition: definition,
          rule: _StaticStatusMetricRule(result),
        ),
      ],
    );
  }
}

class _StaticStatusMetricRule implements StatusMetricRule {
  final StatusRuleResult result;

  const _StaticStatusMetricRule(this.result);

  @override
  Future<StatusRuleResult> evaluate(StatusAnalysisContext context) async {
    return result;
  }
}
