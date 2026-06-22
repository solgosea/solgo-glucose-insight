import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/scoring/status_component_score.dart';
import '../../text/status_component_text_builder.dart';

class XdripSummaryBuilder {
  final StatusComponentTextBuilder textBuilder;

  const XdripSummaryBuilder({
    this.textBuilder = const StatusComponentTextBuilder(),
  });

  String takeaway(StatusComponentScore score) {
    return textBuilder.takeaway('status.xdrip.hero.takeaway.v1', score);
  }

  String summary(
    List<StatusRuleResult> results,
    StatusComponentScore score,
  ) {
    return textBuilder.xdripSummary(results, score);
  }
}
