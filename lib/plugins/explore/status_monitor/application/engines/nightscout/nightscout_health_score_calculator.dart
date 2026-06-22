import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/nightscout/nightscout_pipeline_gate_result.dart';
import '../../../domain/scoring/status_component_score.dart';
import '../../rule_catalogs/nightscout_rule_catalog.dart';
import '../../scoring/status_rule_score_mapper.dart';
import 'nightscout_score_label_mapper.dart';
import 'nightscout_pipeline_score_policy.dart';

class NightscoutHealthScoreCalculator {
  final StatusRuleScoreMapper scoreMapper;
  final NightscoutScoreLabelMapper labelMapper;
  final NightscoutRuleCatalog ruleCatalog;
  final NightscoutPipelineScorePolicy scorePolicy;

  const NightscoutHealthScoreCalculator({
    this.scoreMapper = const StatusRuleScoreMapper(),
    this.labelMapper = const NightscoutScoreLabelMapper(),
    this.ruleCatalog = const NightscoutRuleCatalog(),
    this.scorePolicy = const NightscoutPipelineScorePolicy(),
  });

  static const weights = <String, double>{
    'nightscout.api_reachable': 35,
    'nightscout.entries_endpoint': 25,
    'nightscout.server_data_freshness': 20,
    'nightscout.response_time': 15,
    'nightscout.device_status': 5,
  };

  NightscoutPipelineScoreResult calculateWithBreakdown(
    List<StatusRuleResult> results, {
    NightscoutPipelineGateResult gate = const NightscoutPipelineGateResult(
      apiReachable: true,
      entriesAvailable: true,
      serverDataFresh: true,
      message: 'Nightscout API, entries, and server freshness are healthy.',
    ),
  }) {
    return scorePolicy.calculate(
      results: results,
      definitions: ruleCatalog.build().definitions,
      gate: gate,
    );
  }

  StatusComponentScore calculate(List<StatusRuleResult> results) {
    return calculateWithBreakdown(results).score;
  }
}
