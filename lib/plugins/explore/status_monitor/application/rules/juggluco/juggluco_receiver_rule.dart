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

class JugglucoReceiverRule implements StatusMetricRule {
  const JugglucoReceiverRule();

  @override
  Future<StatusRuleResult> evaluate(StatusAnalysisContext context) async {
    const ruleId = StatusRuleId('juggluco.receiver');
    final evidence = context.evidence.jugglucoEvidence;
    final configured = evidence.receiverConfigured;
    final level = configured ? StatusLevel.healthy : StatusLevel.unknown;
    final metric = StatusMetric(
      id: JugglucoMetricIds.receiver,
      label: 'Broadcast receiver',
      valueLabel: configured ? 'Receiver ready' : 'Not configured',
      level: level,
      source: StatusMetricSource.localProbe,
      observedAt: evidence.latestBroadcastAt,
      note: configured
          ? 'Solgo Insight is ready to receive Juggluco broadcasts.'
          : 'Enable Juggluco broadcast and select Solgo Insight as receiver.',
    );
    return StatusRuleResult(
      ruleId: ruleId,
      metric: metric,
      level: level,
      dataQuality:
          configured ? StatusDataQuality.normal : StatusDataQuality.unavailable,
      explanation: StatusRuleExplanation(
        summary: metric.valueLabel,
        detail: metric.note ?? '',
      ),
      affectsComponentLevel: configured,
    );
  }
}
