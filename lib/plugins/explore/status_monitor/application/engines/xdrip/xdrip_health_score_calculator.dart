import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/scoring/status_component_score.dart';
import '../../../domain/xdrip/xdrip_pipeline_gate_result.dart';
import '../../../domain/xdrip/xdrip_reading_source_state.dart';
import '../../rule_catalogs/xdrip_rule_catalog.dart';
import '../../scoring/status_rule_score_mapper.dart';
import 'xdrip_pipeline_score_policy.dart';
import 'xdrip_score_label_mapper.dart';

class XdripHealthScoreCalculator {
  final StatusRuleScoreMapper scoreMapper;
  final XdripScoreLabelMapper labelMapper;
  final XdripRuleCatalog ruleCatalog;
  final XdripPipelineScorePolicy scorePolicy;

  const XdripHealthScoreCalculator({
    this.scoreMapper = const StatusRuleScoreMapper(),
    this.labelMapper = const XdripScoreLabelMapper(),
    this.ruleCatalog = const XdripRuleCatalog(),
    this.scorePolicy = const XdripPipelineScorePolicy(),
  });

  static const weights = <String, double>{
    'xdrip.local_service': 25,
    'xdrip.reading_freshness': 30,
    'xdrip.completeness_24h': 25,
    'xdrip.upload_latency_p95': 0,
    'xdrip.uploader_battery': 10,
    'xdrip.sensor_collector_context': 10,
  };

  XdripPipelineScoreResult calculateWithBreakdown(
    List<StatusRuleResult> results, {
    XdripPipelineGateResult gate = const XdripPipelineGateResult(
      hasLocalService: true,
      hasLiveReadings: true,
      readingSourceState: XdripReadingSourceState.xdripLocal,
      message: 'xDrip+ Local service and live readings are visible.',
    ),
    String readingSourceLabel = 'xDrip+ Local readings',
  }) {
    return scorePolicy.calculate(
      results: results,
      definitions: ruleCatalog.build().definitions,
      gate: gate,
      readingSourceLabel: readingSourceLabel,
    );
  }

  StatusComponentScore calculate(List<StatusRuleResult> results) {
    return calculateWithBreakdown(results).score;
  }
}
