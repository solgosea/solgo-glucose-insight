import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/scoring/status_component_score.dart';
import '../../../domain/status_level.dart';

class JugglucoHealthScoreCalculator {
  const JugglucoHealthScoreCalculator();

  StatusComponentScore calculate(List<StatusRuleResult> results) {
    final available = results
        .where(
            (result) => result.metric.available && result.affectsComponentLevel)
        .toList(growable: false);
    if (available.isEmpty) {
      return const StatusComponentScore(
        value: 0,
        label: 'Unknown',
        confidence: 0,
        availableSignals: 0,
        totalSignals: 5,
      );
    }
    final score = available
            .map((result) => _levelScore(result.level))
            .reduce((a, b) => a + b) ~/
        available.length;
    return StatusComponentScore(
      value: score,
      label: _label(score),
      confidence: available.length / results.length,
      availableSignals: available
          .where((result) => result.level != StatusLevel.unknown)
          .length,
      totalSignals: results.length,
    );
  }

  int _levelScore(StatusLevel level) {
    return switch (level) {
      StatusLevel.healthy => 100,
      StatusLevel.watch => 68,
      StatusLevel.issue => 25,
      StatusLevel.unknown => 0,
    };
  }

  String _label(int score) {
    if (score >= 85) return 'Fresh';
    if (score >= 60) return 'Watch';
    if (score > 0) return 'Issue';
    return 'Unknown';
  }
}
