import '../../../domain/analysis/status_analysis_context.dart';
import '../../../domain/component_health.dart';
import '../../../domain/status_component_kind.dart';
import '../../../domain/status_direction.dart';
import '../../../domain/status_level.dart';
import '../../rule_catalogs/juggluco_rule_catalog.dart';
import '../../rule_engine/status_rule_engine.dart';
import '../status_component_engine.dart';
import 'juggluco_detail_data_builder.dart';
import 'juggluco_health_score_calculator.dart';

class JugglucoStatusEngine implements StatusComponentEngine {
  final JugglucoRuleCatalog ruleCatalog;
  final StatusRuleEngine ruleEngine;
  final JugglucoHealthScoreCalculator scoreCalculator;
  final JugglucoDetailDataBuilder detailDataBuilder;

  const JugglucoStatusEngine({
    this.ruleCatalog = const JugglucoRuleCatalog(),
    this.ruleEngine = const StatusRuleEngine(),
    this.scoreCalculator = const JugglucoHealthScoreCalculator(),
    this.detailDataBuilder = const JugglucoDetailDataBuilder(),
  });

  @override
  Future<ComponentHealth> evaluate(StatusAnalysisContext context) async {
    final registry = ruleCatalog.build();
    final results = await ruleEngine.evaluate(
      registry: registry,
      context: context,
    );
    final metrics = results.map((result) => result.metric).toList();
    final score = scoreCalculator.calculate(results);
    final level = ComponentHealth.worstAvailableMetricLevel(
      metrics
          .where((metric) => metric.id != 'juggluco_optional_inspection')
          .toList(),
    );
    final detailData = detailDataBuilder.build(
      context: context,
      metrics: metrics,
    );
    return ComponentHealth(
      kind: StatusComponentKind.juggluco,
      level: level == StatusLevel.unknown ? StatusLevel.unknown : level,
      title: StatusComponentKind.juggluco.title,
      role: StatusComponentKind.juggluco.role,
      takeaway: _takeaway(detailData.stateLabel),
      summary: detailData.chainComparison.message,
      metrics: metrics,
      directions: [
        StatusDirection(
          title: detailData.chainComparison.focus.label,
          body: detailData.chainComparison.message,
        ),
      ],
      score: score,
      detailData: detailData,
    );
  }

  String _takeaway(String stateLabel) {
    if (stateLabel == 'Fresh') return 'Juggluco broadcast path is fresh.';
    if (stateLabel == 'Not configured') {
      return 'Enable Juggluco broadcast to inspect this local path.';
    }
    return 'Juggluco primary broadcast path is $stateLabel.';
  }
}
