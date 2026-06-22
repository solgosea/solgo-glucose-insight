import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/status_direction.dart';
import '../../text/status_direction_text_builder.dart';

class CgmSensorDirectionBuilder {
  final StatusDirectionTextBuilder textBuilder;

  const CgmSensorDirectionBuilder({
    this.textBuilder = const StatusDirectionTextBuilder(),
  });

  List<StatusDirection> build(List<StatusRuleResult> results) {
    final generated = results
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
    if (generated.isNotEmpty) return generated;
    return textBuilder.cgmDefaults();
  }
}
