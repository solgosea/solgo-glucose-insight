import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/component_health.dart';
import '../../../domain/status_component_kind.dart';
import '../../datasets/cgm_sensor_detail_dataset_builder.dart';
import '../../rule_catalogs/cgm_sensor_rule_catalog.dart';
import '../../rule_engine/status_rule_engine.dart';
import '../../scoring/status_score_label_mapper.dart';
import '../status_component_engine.dart';
import 'cgm_sensor_direction_builder.dart';
import 'cgm_sensor_pipeline_gate_policy.dart';
import 'cgm_sensor_pipeline_score_policy.dart';
import 'cgm_sensor_summary_builder.dart';

class CgmSensorStatusEngine implements StatusComponentEngine {
  final CgmSensorRuleCatalog ruleCatalog;
  final StatusRuleEngine ruleEngine;
  final CgmSensorPipelineGatePolicy gatePolicy;
  final CgmSensorPipelineScorePolicy scorePolicy;
  final CgmSensorSummaryBuilder summaryBuilder;
  final CgmSensorDirectionBuilder directionBuilder;
  final StatusScoreLabelMapper levelMapper;
  final CgmSensorDetailDatasetBuilder detailDatasetBuilder;

  const CgmSensorStatusEngine({
    this.ruleCatalog = const CgmSensorRuleCatalog(),
    this.ruleEngine = const StatusRuleEngine(),
    this.gatePolicy = const CgmSensorPipelineGatePolicy(),
    this.scorePolicy = const CgmSensorPipelineScorePolicy(),
    this.summaryBuilder = const CgmSensorSummaryBuilder(),
    this.directionBuilder = const CgmSensorDirectionBuilder(),
    this.levelMapper = const StatusScoreLabelMapper(),
    this.detailDatasetBuilder = const CgmSensorDetailDatasetBuilder(),
  });

  @override
  Future<ComponentHealth> evaluate(StatusAnalysisContext context) async {
    final registry = ruleCatalog.build();
    final results = await ruleEngine.evaluate(
      registry: registry,
      context: context,
    );
    final metrics = results.map((result) => result.metric).toList();
    final gate = gatePolicy.evaluate(context, results);
    final scoreResult = scorePolicy.calculate(
      results: results,
      definitions: registry.definitions,
      gate: gate,
      liveSourceLabel: context.evidence.selection.cgmLiveReadings.sourceLabel,
      historySourceLabel:
          context.evidence.selection.cgmHistoryReadings.sourceLabel,
    );
    final score = scoreResult.score;
    final detailData = detailDatasetBuilder.buildWithBreakdown(
      context: context,
      metrics: metrics,
      scoreBreakdown: scoreResult.breakdown,
    );
    return ComponentHealth(
      kind: StatusComponentKind.cgmSensor,
      level: score.availableSignals == 0
          ? levelMapper.levelFor(null)
          : gate.levelFor(score.value, levelMapper.levelFor),
      title: StatusComponentKind.cgmSensor.title,
      role: StatusComponentKind.cgmSensor.role,
      takeaway: summaryBuilder.takeaway(score),
      summary: summaryBuilder.summary(results, score),
      metrics: metrics,
      directions: directionBuilder.build(results),
      score: score,
      detailData: detailData,
    );
  }
}
