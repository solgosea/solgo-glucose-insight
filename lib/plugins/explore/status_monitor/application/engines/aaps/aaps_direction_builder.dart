import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/status_direction.dart';
import '../../text/status_aaps_text_builder.dart';

class AapsDirectionBuilder {
  final StatusAapsTextBuilder textBuilder;

  const AapsDirectionBuilder({
    this.textBuilder = const StatusAapsTextBuilder(),
  });

  List<StatusDirection> build(List<StatusRuleResult> results) {
    final directions = results
        .where(
          (result) => !result.metric.available || result.level.severity > 0,
        )
        .map(
          (result) => StatusDirection(
            title: result.explanation.summary,
            body: result.explanation.detail,
          ),
        )
        .where(
          (direction) =>
              direction.title.trim().isNotEmpty ||
              direction.body.trim().isNotEmpty,
        )
        .toList(growable: false);
    if (directions.isNotEmpty) return directions;
    return [textBuilder.defaultDirection()];
  }
}
