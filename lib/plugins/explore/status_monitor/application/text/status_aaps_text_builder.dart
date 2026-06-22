import '../../domain/analysis/status_rule_explanation.dart';
import '../../domain/analysis/status_rule_result.dart';
import '../../domain/scoring/status_component_score.dart';
import '../../domain/status_direction.dart';
import '../../domain/status_level.dart';
import '../engines/aaps/aaps_metric_ids.dart';
import 'status_rule_explanation_text_builder.dart';
import 'status_text_renderer.dart';

class StatusAapsTextBuilder {
  final StatusTextRenderer renderer;
  final StatusRuleExplanationTextBuilder ruleTextBuilder;

  const StatusAapsTextBuilder({
    this.renderer = const StatusTextRenderer(),
    this.ruleTextBuilder = const StatusRuleExplanationTextBuilder(),
  });

  String takeaway(StatusComponentScore score) {
    final key = score.availableSignals == 0
        ? 'status.aaps.hero.takeaway.empty.v1'
        : score.value >= 85
            ? 'status.aaps.hero.takeaway.healthy.v1'
            : score.value >= 50
                ? 'status.aaps.hero.takeaway.watch.v1'
                : 'status.aaps.hero.takeaway.issue.v1';
    return renderer.render(key, const {}).body;
  }

  String summary(
    List<StatusRuleResult> results,
    StatusComponentScore score,
  ) {
    final facts = _summaryFacts(results, score);
    final key = score.availableSignals == 0
        ? 'status.aaps.hero.summary.empty.v1'
        : results.any((result) => result.level == StatusLevel.issue)
            ? 'status.aaps.hero.summary.issue.v1'
            : 'status.aaps.hero.summary.default.v1';
    return renderer.render(key, facts).body;
  }

  StatusDirection defaultDirection() {
    final rendered = renderer.render(
      'status.aaps.direction.default.v1',
      const {},
    );
    return StatusDirection(
      title: rendered.title ?? rendered.body,
      body: rendered.body,
    );
  }

  StatusRuleExplanation ruleExplanation(
    String key,
    Map<String, Object?> facts, {
    String? fallbackSummary,
    String? fallbackDetail,
  }) {
    return ruleTextBuilder.build(
      key,
      facts,
      fallbackSummary: fallbackSummary,
      fallbackDetail: fallbackDetail,
    );
  }

  String safetyNotice() {
    return renderer.render('status.aaps.safety_notice.v1', const {}).body;
  }

  Map<String, Object?> _summaryFacts(
    List<StatusRuleResult> results,
    StatusComponentScore score,
  ) {
    final metrics = {
      for (final result in results) result.metric.id: result.metric,
    };
    return {
      'availableSignals': score.availableSignals,
      'totalSignals': score.totalSignals,
      'latestContext':
          metrics[AapsMetricIds.syncFreshness]?.valueLabel ?? 'Unknown',
      'loop': metrics[AapsMetricIds.loopContext]?.valueLabel ?? 'Unknown',
      'pump': metrics[AapsMetricIds.pumpContext]?.valueLabel ?? 'Unknown',
    };
  }
}
