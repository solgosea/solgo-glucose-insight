import '../../../domain/aaps/aaps_pipeline_gate_result.dart';
import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/status_level.dart';
import 'aaps_metric_ids.dart';

class AapsPipelineGatePolicy {
  const AapsPipelineGatePolicy();

  AapsPipelineGateResult evaluate(
    StatusAnalysisContext context,
    List<StatusRuleResult> results,
  ) {
    final evidence = context.evidence.aapsEvidence;
    final loopLevel = _metricLevel(results, AapsMetricIds.loopContext);
    final syncLevel = _metricLevel(results, AapsMetricIds.syncFreshness);
    final hasFreshLoopContext =
        loopLevel == StatusLevel.healthy && syncLevel == StatusLevel.healthy;

    if (!evidence.nightscoutReachable) {
      return const AapsPipelineGateResult(
        nightscoutReachable: false,
        hasAapsContext: false,
        hasFreshLoopContext: false,
        maxScore: 0,
        forcedLevel: StatusLevel.unknown,
        message: 'Nightscout evidence is unavailable for AAPS Loop.',
      );
    }
    if (!evidence.hasAapsContext) {
      return const AapsPipelineGateResult(
        nightscoutReachable: true,
        hasAapsContext: false,
        hasFreshLoopContext: false,
        maxScore: 0,
        forcedLevel: StatusLevel.unknown,
        message:
            'Nightscout is reachable, but no AAPS/OpenAPS context is visible.',
      );
    }
    if (!hasFreshLoopContext) {
      return const AapsPipelineGateResult(
        nightscoutReachable: true,
        hasAapsContext: true,
        hasFreshLoopContext: false,
        maxScore: 70,
        maxLevel: StatusLevel.watch,
        message: 'AAPS context is visible, but loop freshness needs attention.',
      );
    }
    return const AapsPipelineGateResult(
      nightscoutReachable: true,
      hasAapsContext: true,
      hasFreshLoopContext: true,
      message: 'Fresh AAPS loop context is visible through Nightscout.',
    );
  }

  StatusLevel _metricLevel(List<StatusRuleResult> results, String metricId) {
    for (final result in results) {
      if (result.metric.id == metricId) return result.level;
    }
    return StatusLevel.unknown;
  }
}
