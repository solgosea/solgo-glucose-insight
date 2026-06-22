import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/nightscout/nightscout_pipeline_gate_result.dart';
import '../../../domain/status_level.dart';
import 'nightscout_metric_ids.dart';

class NightscoutPipelineGatePolicy {
  const NightscoutPipelineGatePolicy();

  NightscoutPipelineGateResult evaluate(
    StatusAnalysisContext context,
    List<StatusRuleResult> results,
  ) {
    final apiReachable =
        _metricLevel(results, NightscoutMetricIds.apiReachable) ==
            StatusLevel.healthy;
    final entriesLevel =
        _metricLevel(results, NightscoutMetricIds.entriesEndpoint);
    final freshnessLevel =
        _metricLevel(results, NightscoutMetricIds.serverDataFreshness);
    final entriesAvailable = entriesLevel == StatusLevel.healthy ||
        entriesLevel == StatusLevel.watch;
    final serverDataFresh = freshnessLevel == StatusLevel.healthy;

    if (!apiReachable) {
      return const NightscoutPipelineGateResult(
        apiReachable: false,
        entriesAvailable: false,
        serverDataFresh: false,
        maxScore: 25,
        forcedLevel: StatusLevel.issue,
        message: 'Nightscout API is not reachable.',
      );
    }
    if (!entriesAvailable) {
      return const NightscoutPipelineGateResult(
        apiReachable: true,
        entriesAvailable: false,
        serverDataFresh: false,
        maxScore: 55,
        maxLevel: StatusLevel.watch,
        message:
            'Nightscout is reachable, but entries are not currently available.',
      );
    }
    if (!serverDataFresh) {
      return const NightscoutPipelineGateResult(
        apiReachable: true,
        entriesAvailable: true,
        serverDataFresh: false,
        maxScore: 70,
        maxLevel: StatusLevel.watch,
        message: 'Nightscout entries are visible, but server data is stale.',
      );
    }
    return const NightscoutPipelineGateResult(
      apiReachable: true,
      entriesAvailable: true,
      serverDataFresh: true,
      message: 'Nightscout API, entries, and server freshness are healthy.',
    );
  }

  StatusLevel _metricLevel(List<StatusRuleResult> results, String metricId) {
    for (final result in results) {
      if (result.metric.id == metricId) return result.level;
    }
    return StatusLevel.unknown;
  }
}
