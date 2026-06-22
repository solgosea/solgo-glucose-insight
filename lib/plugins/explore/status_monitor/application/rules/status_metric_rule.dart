import '../../domain/analysis/status_analysis_context.dart';
import '../../domain/analysis/status_rule_result.dart';

abstract interface class StatusMetricRule {
  Future<StatusRuleResult> evaluate(StatusAnalysisContext context);
}
