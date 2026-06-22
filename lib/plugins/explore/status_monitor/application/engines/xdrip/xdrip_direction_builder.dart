import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/status_direction.dart';

class XdripDirectionBuilder {
  const XdripDirectionBuilder();

  List<StatusDirection> build(List<StatusRuleResult> results) {
    return results
        .where(
          (result) => result.level.severity > 0 || !result.metric.available,
        )
        .map(
          (result) => StatusDirection(
            title: result.explanation.summary,
            body: result.explanation.detail,
          ),
        )
        .toList(growable: false);
  }
}
