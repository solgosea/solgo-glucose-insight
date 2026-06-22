import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/scoring/status_component_score.dart';
import '../../text/status_component_text_builder.dart';

class CgmSensorSummaryBuilder {
  final StatusComponentTextBuilder textBuilder;

  const CgmSensorSummaryBuilder({
    this.textBuilder = const StatusComponentTextBuilder(),
  });

  String takeaway(StatusComponentScore score) {
    return textBuilder.takeaway('status.cgm.hero.takeaway.v1', score);
  }

  String summary(
    List<StatusRuleResult> results,
    StatusComponentScore score,
  ) {
    return textBuilder.cgmSummary(results, score);
  }
}
