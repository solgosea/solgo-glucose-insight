import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/analysis/status_data_quality.dart';
import '../../../domain/analysis/status_rule_explanation.dart';
import '../../../domain/analysis/status_rule_id.dart';
import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/status_level.dart';
import '../../../domain/status_metric.dart';
import '../../../domain/status_metric_source.dart';
import '../../engines/juggluco/juggluco_metric_ids.dart';
import '../status_metric_rule.dart';

class JugglucoOptionalInspectionRule implements StatusMetricRule {
  const JugglucoOptionalInspectionRule();

  @override
  Future<StatusRuleResult> evaluate(StatusAnalysisContext context) async {
    const ruleId = StatusRuleId('juggluco.optional_inspection');
    const metric = StatusMetric(
      id: JugglucoMetricIds.optionalInspection,
      label: 'Juggluco Web Server',
      valueLabel: 'Optional',
      level: StatusLevel.healthy,
      source: StatusMetricSource.localProbe,
      note:
          'Web Server can improve history inspection, but it is not required for the primary Juggluco broadcast path.',
    );
    return const StatusRuleResult(
      ruleId: ruleId,
      metric: metric,
      level: StatusLevel.healthy,
      dataQuality: StatusDataQuality.normal,
      explanation: StatusRuleExplanation(
        summary: 'Optional inspection',
        detail:
            'Web Server not enabled should not mark Juggluco as broken. Broadcast remains the primary path evidence.',
      ),
      affectsComponentLevel: false,
    );
  }
}
