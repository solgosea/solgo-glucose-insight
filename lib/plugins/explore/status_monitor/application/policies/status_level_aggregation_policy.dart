import '../../domain/analysis/status_rule_result.dart';
import '../../domain/status_level.dart';

class StatusLevelAggregationPolicy {
  const StatusLevelAggregationPolicy();

  StatusLevel aggregate(List<StatusRuleResult> results) {
    final candidates = results
        .where((result) => result.affectsComponentLevel)
        .map((result) => result.level)
        .where((level) => level != StatusLevel.unknown)
        .toList();
    if (candidates.isEmpty) return StatusLevel.unknown;
    return candidates.reduce((a, b) => a.severity >= b.severity ? a : b);
  }
}
