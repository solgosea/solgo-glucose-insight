import '../../domain/analysis/status_rule_result.dart';
import '../../domain/rules/status_rule_definition.dart';
import '../../domain/scoring/status_component_score.dart';
import '../scoring/status_rule_score_mapper.dart';

typedef StatusScoreLabelFor = String Function(int? score);

class StatusRuleScorePolicy {
  final StatusRuleScoreMapper scoreMapper;

  const StatusRuleScorePolicy({
    this.scoreMapper = const StatusRuleScoreMapper(),
  });

  StatusComponentScore calculate({
    required List<StatusRuleResult> results,
    required List<StatusRuleDefinition> definitions,
    required StatusScoreLabelFor labelFor,
  }) {
    final definitionsById = {
      for (final definition in definitions) definition.ruleId.value: definition,
    };
    final signals = results
        .map(
          (result) => scoreMapper.map(
            result,
            weight: definitionsById[result.ruleId.value]?.weight ?? 0,
          ),
        )
        .toList(growable: false);
    final totalWeight = signals.fold<double>(
      0,
      (sum, signal) => sum + signal.weight,
    );
    final available = signals.where((signal) => signal.available).toList();
    final availableWeight = available.fold<double>(
      0,
      (sum, signal) => sum + signal.weight,
    );
    final value = availableWeight == 0
        ? null
        : (available.fold<double>(
                  0,
                  (sum, signal) => sum + signal.score * signal.weight,
                ) /
                availableWeight)
            .round()
            .clamp(0, 100);
    return StatusComponentScore(
      value: value ?? 0,
      label: labelFor(value),
      confidence: totalWeight == 0 ? 0 : availableWeight / totalWeight,
      availableSignals: available.length,
      totalSignals: signals.length,
    );
  }
}
