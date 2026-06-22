import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/component_health.dart';
import '../../../domain/status_component_kind.dart';
import '../../datasets/nightscout_detail_dataset_builder.dart';
import '../../rule_catalogs/nightscout_rule_catalog.dart';
import '../../rule_engine/status_rule_engine.dart';
import '../status_component_engine.dart';
import 'nightscout_direction_builder.dart';
import 'nightscout_pipeline_gate_policy.dart';
import 'nightscout_pipeline_score_policy.dart';
import 'nightscout_score_label_mapper.dart';
import 'nightscout_summary_builder.dart';

class NightscoutStatusEngine implements StatusComponentEngine {
  final NightscoutRuleCatalog ruleCatalog;
  final StatusRuleEngine ruleEngine;
  final NightscoutPipelineGatePolicy gatePolicy;
  final NightscoutPipelineScorePolicy scorePolicy;
  final NightscoutSummaryBuilder summaryBuilder;
  final NightscoutDirectionBuilder directionBuilder;
  final NightscoutScoreLabelMapper levelMapper;
  final NightscoutDetailDatasetBuilder detailDatasetBuilder;

  const NightscoutStatusEngine({
    this.ruleCatalog = const NightscoutRuleCatalog(),
    this.ruleEngine = const StatusRuleEngine(),
    this.gatePolicy = const NightscoutPipelineGatePolicy(),
    this.scorePolicy = const NightscoutPipelineScorePolicy(),
    this.summaryBuilder = const NightscoutSummaryBuilder(),
    this.directionBuilder = const NightscoutDirectionBuilder(),
    this.levelMapper = const NightscoutScoreLabelMapper(),
    this.detailDatasetBuilder = const NightscoutDetailDatasetBuilder(),
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
    );
    final score = scoreResult.score;
    final detailData = detailDatasetBuilder.buildWithBreakdown(
      context: context,
      metrics: metrics,
      scoreBreakdown: scoreResult.breakdown,
    );
    return ComponentHealth(
      kind: StatusComponentKind.nightscout,
      level: score.availableSignals == 0
          ? levelMapper.levelFor(null)
          : gate.levelFor(score.value, levelMapper.levelFor),
      title: StatusComponentKind.nightscout.title,
      role: StatusComponentKind.nightscout.role,
      takeaway: summaryBuilder.takeaway(score),
      summary: summaryBuilder.summary(results, score),
      metrics: metrics,
      directions: directionBuilder.build(results),
      score: score,
      detailData: detailData,
    );
  }
}
