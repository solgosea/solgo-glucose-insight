import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/scoring/status_component_score.dart';
import '../../text/status_aaps_text_builder.dart';

class AapsSummaryBuilder {
  final StatusAapsTextBuilder textBuilder;

  const AapsSummaryBuilder({
    this.textBuilder = const StatusAapsTextBuilder(),
  });

  String takeaway(StatusComponentScore score) => textBuilder.takeaway(score);

  String summary(
    List<StatusRuleResult> results,
    StatusComponentScore score,
  ) =>
      textBuilder.summary(results, score);
}
