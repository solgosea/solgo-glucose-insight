import '../../domain/analysis/status_rule_result.dart';
import '../../domain/scoring/status_signal_score.dart';
import '../../domain/status_level.dart';

class StatusRuleScoreMapper {
  const StatusRuleScoreMapper();

  StatusSignalScore map(
    StatusRuleResult result, {
    required double weight,
  }) {
    final available = result.metric.available && result.affectsComponentLevel;
    return StatusSignalScore(
      ruleId: result.ruleId.value,
      score: available ? _levelScore(result.level) : 0,
      weight: weight,
      available: available,
    );
  }

  int _levelScore(StatusLevel level) {
    return switch (level) {
      StatusLevel.healthy => 100,
      StatusLevel.watch => 65,
      StatusLevel.issue => 25,
      StatusLevel.unknown => 0,
    };
  }
}
