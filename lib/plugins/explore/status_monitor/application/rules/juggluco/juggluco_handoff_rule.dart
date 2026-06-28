import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/analysis/status_data_quality.dart';
import '../../../domain/analysis/status_rule_explanation.dart';
import '../../../domain/analysis/status_rule_id.dart';
import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/juggluco/juggluco_chain_focus.dart';
import '../../../domain/status_level.dart';
import '../../../domain/status_metric.dart';
import '../../../domain/status_metric_source.dart';
import '../../engines/juggluco/juggluco_chain_comparison_builder.dart';
import '../../engines/juggluco/juggluco_metric_ids.dart';
import '../../engines/juggluco/juggluco_path_state_calculator.dart';
import '../status_metric_rule.dart';

class JugglucoHandoffRule implements StatusMetricRule {
  final JugglucoPathStateCalculator stateCalculator;
  final JugglucoChainComparisonBuilder chainBuilder;

  const JugglucoHandoffRule({
    this.stateCalculator = const JugglucoPathStateCalculator(),
    this.chainBuilder = const JugglucoChainComparisonBuilder(),
  });

  @override
  Future<StatusRuleResult> evaluate(StatusAnalysisContext context) async {
    const ruleId = StatusRuleId('juggluco.handoff');
    final evidence = context.evidence.jugglucoEvidence;
    final state = stateCalculator.calculate(
      receiverConfigured: evidence.receiverConfigured,
      broadcastObserved: evidence.broadcastObserved,
      xdripCompatibleObserved: evidence.hasXdripCompatiblePath,
      age: evidence.latestXdripCompatibleAge(context.now),
    );
    final comparison = chainBuilder.build(context: context, state: state);
    final level = comparison.focus == JugglucoChainFocus.jugglucoToXdrip
        ? StatusLevel.watch
        : comparison.focus == JugglucoChainFocus.setupRequired
            ? StatusLevel.unknown
            : StatusLevel.healthy;
    final metric = StatusMetric(
      id: JugglucoMetricIds.handoff,
      label: 'Juggluco -> xDrip+ handoff',
      valueLabel: comparison.focus == JugglucoChainFocus.jugglucoToXdrip
          ? 'Check handoff'
          : 'No handoff gap',
      level: level,
      source: StatusMetricSource.localProbe,
      observedAt: evidence.latestBroadcastAt,
      note: comparison.message,
      metadata: {'focus': comparison.focus.name},
    );
    return StatusRuleResult(
      ruleId: ruleId,
      metric: metric,
      level: level,
      dataQuality: StatusDataQuality.normal,
      explanation: StatusRuleExplanation(
        summary: metric.valueLabel,
        detail: comparison.message,
        facts: {'focus': comparison.focus.name},
      ),
      affectsComponentLevel:
          comparison.focus == JugglucoChainFocus.jugglucoToXdrip,
    );
  }
}
