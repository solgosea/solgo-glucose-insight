import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/component_health.dart';
import '../../../domain/status_component_kind.dart';
import '../../datasets/xdrip_detail_dataset_builder.dart';
import '../../rule_catalogs/xdrip_rule_catalog.dart';
import '../../rule_engine/status_rule_engine.dart';
import '../status_component_engine.dart';
import 'xdrip_direction_builder.dart';
import 'xdrip_health_score_calculator.dart';
import 'xdrip_pipeline_gate_policy.dart';
import 'xdrip_score_label_mapper.dart';
import 'xdrip_summary_builder.dart';

class XdripStatusEngine implements StatusComponentEngine {
  final XdripRuleCatalog ruleCatalog;
  final StatusRuleEngine ruleEngine;
  final XdripPipelineGatePolicy gatePolicy;
  final XdripHealthScoreCalculator scoreCalculator;
  final XdripSummaryBuilder summaryBuilder;
  final XdripDirectionBuilder directionBuilder;
  final XdripScoreLabelMapper levelMapper;
  final XdripDetailDatasetBuilder detailDatasetBuilder;

  const XdripStatusEngine({
    this.ruleCatalog = const XdripRuleCatalog(),
    this.ruleEngine = const StatusRuleEngine(),
    this.gatePolicy = const XdripPipelineGatePolicy(),
    this.scoreCalculator = const XdripHealthScoreCalculator(),
    this.summaryBuilder = const XdripSummaryBuilder(),
    this.directionBuilder = const XdripDirectionBuilder(),
    this.levelMapper = const XdripScoreLabelMapper(),
    this.detailDatasetBuilder = const XdripDetailDatasetBuilder(),
  });

  @override
  Future<ComponentHealth> evaluate(StatusAnalysisContext context) async {
    final registry = ruleCatalog.build();
    final results = await ruleEngine.evaluate(
      registry: registry,
      context: context,
    );
    final metrics = results.map((result) => result.metric).toList();
    final gate = gatePolicy.evaluate(context);
    final scoreResult = scoreCalculator.calculateWithBreakdown(
      results,
      gate: gate,
      readingSourceLabel:
          context.evidence.selection.xdripLiveReadings.sourceLabel,
    );
    final score = scoreResult.score;
    final detailData = detailDatasetBuilder.buildWithBreakdown(
      context: context,
      metrics: metrics,
      scoreBreakdown: scoreResult.breakdown,
    );
    return ComponentHealth(
      kind: StatusComponentKind.xdrip,
      level: score.availableSignals == 0
          ? levelMapper.levelFor(null)
          : gate.levelFor(score.value, levelMapper.levelFor),
      title: StatusComponentKind.xdrip.title,
      role: StatusComponentKind.xdrip.role,
      takeaway: summaryBuilder.takeaway(score),
      summary: summaryBuilder.summary(results, score),
      metrics: metrics,
      directions: directionBuilder.build(results),
      score: score,
      detailData: detailData,
    );
  }
}
