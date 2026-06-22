import '../status_level.dart';
import '../status_metric.dart';
import 'status_data_quality.dart';
import 'status_rule_explanation.dart';
import 'status_rule_id.dart';

class StatusRuleResult {
  final StatusRuleId ruleId;
  final StatusMetric metric;
  final StatusLevel level;
  final StatusDataQuality dataQuality;
  final StatusRuleExplanation explanation;
  final bool affectsComponentLevel;

  const StatusRuleResult({
    required this.ruleId,
    required this.metric,
    required this.level,
    required this.dataQuality,
    required this.explanation,
    this.affectsComponentLevel = true,
  });

  StatusRuleResult copyWith({
    StatusRuleId? ruleId,
    StatusMetric? metric,
    StatusLevel? level,
    StatusDataQuality? dataQuality,
    StatusRuleExplanation? explanation,
    bool? affectsComponentLevel,
  }) {
    return StatusRuleResult(
      ruleId: ruleId ?? this.ruleId,
      metric: metric ?? this.metric,
      level: level ?? this.level,
      dataQuality: dataQuality ?? this.dataQuality,
      explanation: explanation ?? this.explanation,
      affectsComponentLevel:
          affectsComponentLevel ?? this.affectsComponentLevel,
    );
  }
}
