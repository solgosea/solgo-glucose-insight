import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/component_health.dart';
import '../../../domain/status_component_kind.dart';
import '../../datasets/aaps_detail_dataset_builder.dart';
import '../../rule_catalogs/aaps_rule_catalog.dart';
import '../../rule_engine/status_rule_engine.dart';
import '../status_component_engine.dart';
import 'aaps_direction_builder.dart';
import 'aaps_pipeline_gate_policy.dart';
import 'aaps_pipeline_score_policy.dart';
import 'aaps_score_label_mapper.dart';
import 'aaps_summary_builder.dart';

class AapsStatusEngine implements StatusComponentEngine {
  final AapsRuleCatalog ruleCatalog;
  final StatusRuleEngine ruleEngine;
  final AapsPipelineGatePolicy gatePolicy;
  final AapsPipelineScorePolicy scorePolicy;
  final AapsSummaryBuilder summaryBuilder;
  final AapsDirectionBuilder directionBuilder;
  final AapsScoreLabelMapper levelMapper;
  final AapsDetailDatasetBuilder detailDatasetBuilder;

  const AapsStatusEngine({
    this.ruleCatalog = const AapsRuleCatalog(),
    this.ruleEngine = const StatusRuleEngine(),
    this.gatePolicy = const AapsPipelineGatePolicy(),
    this.scorePolicy = const AapsPipelineScorePolicy(),
    this.summaryBuilder = const AapsSummaryBuilder(),
    this.directionBuilder = const AapsDirectionBuilder(),
    this.levelMapper = const AapsScoreLabelMapper(),
    this.detailDatasetBuilder = const AapsDetailDatasetBuilder(),
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
      kind: StatusComponentKind.aapsLoop,
      level: score.availableSignals == 0
          ? levelMapper.levelFor(null)
          : gate.levelFor(score.value, levelMapper.levelFor),
      title: StatusComponentKind.aapsLoop.title,
      role: StatusComponentKind.aapsLoop.role,
      takeaway: summaryBuilder.takeaway(score),
      summary: summaryBuilder.summary(results, score),
      metrics: metrics,
      directions: directionBuilder.build(results),
      score: score,
      detailData: detailData,
    );
  }
}
