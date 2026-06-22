import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/cgm_sensor/cgm_sensor_pipeline_gate_result.dart';
import '../../../domain/scoring/status_component_score.dart';
import '../../rule_catalogs/cgm_sensor_rule_catalog.dart';
import '../../scoring/status_rule_score_mapper.dart';
import '../../scoring/status_score_label_mapper.dart';
import 'cgm_sensor_pipeline_score_policy.dart';

class CgmSensorHealthScoreCalculator {
  final StatusRuleScoreMapper scoreMapper;
  final StatusScoreLabelMapper labelMapper;
  final CgmSensorRuleCatalog ruleCatalog;
  final CgmSensorPipelineScorePolicy scorePolicy;

  const CgmSensorHealthScoreCalculator({
    this.scoreMapper = const StatusRuleScoreMapper(),
    this.labelMapper = const StatusScoreLabelMapper(),
    this.ruleCatalog = const CgmSensorRuleCatalog(),
    this.scorePolicy = const CgmSensorPipelineScorePolicy(),
  });

  static const weights = <String, double>{
    'cgm.sensor_freshness': 20,
    'cgm.signal_continuity': 25,
    'cgm.cv_24h': 20,
    'cgm.sudden_changes_24h': 15,
    'cgm.flat_line_periods': 10,
    'cgm.sensor_lifetime': 10,
  };

  CgmSensorPipelineScoreResult calculateWithBreakdown(
    List<StatusRuleResult> results, {
    CgmSensorPipelineGateResult gate = const CgmSensorPipelineGateResult(
      hasLiveReadings: true,
      message:
          'Live CGM readings are visible. Current status is based on freshness and continuity.',
    ),
    String liveSourceLabel = 'Live CGM readings',
    String historySourceLabel = 'Cached 24h local readings',
  }) {
    return scorePolicy.calculate(
      results: results,
      definitions: ruleCatalog.build().definitions,
      gate: gate,
      liveSourceLabel: liveSourceLabel,
      historySourceLabel: historySourceLabel,
    );
  }

  StatusComponentScore calculate(List<StatusRuleResult> results) {
    return calculateWithBreakdown(results).score;
  }
}
