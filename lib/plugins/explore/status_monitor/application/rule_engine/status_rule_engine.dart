import '../../domain/analysis/status_analysis_context.dart';
import '../../domain/analysis/status_rule_result.dart';
import 'status_rule_result_normalizer.dart';
import 'status_rule_registry.dart';

class StatusRuleEngine {
  final StatusRuleResultNormalizer normalizer;

  const StatusRuleEngine({
    this.normalizer = const StatusRuleResultNormalizer(),
  });

  Future<List<StatusRuleResult>> evaluate({
    required StatusRuleRegistry registry,
    required StatusAnalysisContext context,
  }) async {
    final results = <StatusRuleResult>[];
    for (final evaluator in registry.evaluators) {
      final result = await evaluator.rule.evaluate(context);
      results.add(
        normalizer.normalize(
          definition: evaluator.definition,
          result: result,
        ),
      );
    }
    return results;
  }
}
