import '../../../domain/analysis/status_data_quality.dart';
import '../../../domain/analysis/status_rule_id.dart';
import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/status_level.dart';
import '../../../domain/status_metric.dart';
import '../../../domain/status_metric_source.dart';
import '../../text/status_aaps_text_builder.dart';

class AapsRuleHelpers {
  final StatusAapsTextBuilder textBuilder;

  const AapsRuleHelpers({
    this.textBuilder = const StatusAapsTextBuilder(),
  });

  StatusRuleResult unknown({
    required StatusRuleId ruleId,
    required String metricId,
    required String label,
    required String reason,
    required String templateKey,
    String? note,
    Map<String, Object?> facts = const {},
  }) {
    final metric = StatusMetric.unknown(
      id: metricId,
      label: label,
      source: StatusMetricSource.deviceStatus,
      reason: reason,
      note: note,
    );
    return StatusRuleResult(
      ruleId: ruleId,
      metric: metric,
      level: StatusLevel.unknown,
      dataQuality: StatusDataQuality.insufficientData,
      explanation: textBuilder.ruleExplanation(
        templateKey,
        {
          'reason': reason,
          if (note != null) 'note': note,
          ...facts,
        },
        fallbackSummary: reason,
        fallbackDetail: note ?? reason,
      ),
    );
  }

  String ageLabel(Duration age) {
    if (age.inSeconds < 45) return '0s';
    if (age.inMinutes < 60) return '${age.inMinutes}m';
    if (age.inHours < 24) return '${age.inHours}h';
    return '${age.inDays}d';
  }

  StatusLevel freshnessLevel(Duration age) {
    if (age < const Duration(minutes: 7)) return StatusLevel.healthy;
    if (age <= const Duration(minutes: 15)) return StatusLevel.watch;
    return StatusLevel.issue;
  }
}
