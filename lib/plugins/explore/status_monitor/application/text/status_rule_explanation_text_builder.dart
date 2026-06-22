import '../../domain/analysis/status_rule_explanation.dart';
import 'status_text_renderer.dart';

class StatusRuleExplanationTextBuilder {
  final StatusTextRenderer renderer;

  const StatusRuleExplanationTextBuilder({
    this.renderer = const StatusTextRenderer(),
  });

  StatusRuleExplanation build(
    String key,
    Map<String, Object?> facts, {
    String? fallbackSummary,
    String? fallbackDetail,
  }) {
    final rendered = renderer.render(key, facts, fallback: fallbackSummary);
    return StatusRuleExplanation(
      summary: rendered.title ?? rendered.body,
      detail: rendered.body.isEmpty ? fallbackDetail ?? '' : rendered.body,
      templateKey: key,
      facts: facts,
    );
  }
}
