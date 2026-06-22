import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/nightscout/nightscout_health_score_breakdown.dart';
import '../../../domain/nightscout/nightscout_pipeline_gate_result.dart';
import '../../../domain/rules/status_rule_definition.dart';
import '../../../domain/scoring/status_component_score.dart';
import '../../scoring/status_rule_score_mapper.dart';
import 'nightscout_score_label_mapper.dart';

class NightscoutPipelineScoreResult {
  final StatusComponentScore score;
  final NightscoutHealthScoreBreakdown breakdown;

  const NightscoutPipelineScoreResult({
    required this.score,
    required this.breakdown,
  });
}

class NightscoutPipelineScorePolicy {
  final StatusRuleScoreMapper scoreMapper;
  final NightscoutScoreLabelMapper labelMapper;

  const NightscoutPipelineScorePolicy({
    this.scoreMapper = const StatusRuleScoreMapper(),
    this.labelMapper = const NightscoutScoreLabelMapper(),
  });

  NightscoutPipelineScoreResult calculate({
    required List<StatusRuleResult> results,
    required List<StatusRuleDefinition> definitions,
    required NightscoutPipelineGateResult gate,
  }) {
    const scoreRuleIds = {
      'nightscout.api_reachable',
      'nightscout.entries_endpoint',
      'nightscout.server_data_freshness',
      'nightscout.response_time',
    };
    final definitionsById = {
      for (final definition in definitions) definition.ruleId.value: definition,
    };
    final signals = results
        .where((result) => scoreRuleIds.contains(result.ruleId.value))
        .map(
          (result) => scoreMapper.map(
            result,
            weight: definitionsById[result.ruleId.value]?.weight ?? 0,
          ),
        )
        .where((signal) => signal.weight > 0)
        .toList(growable: false);
    final totalWeight = definitions
        .where((definition) => scoreRuleIds.contains(definition.ruleId.value))
        .fold<double>(0, (sum, definition) => sum + definition.weight);
    final confidenceSignals = results
        .map(
          (result) => scoreMapper.map(
            result,
            weight: definitionsById[result.ruleId.value]?.weight ?? 0,
          ),
        )
        .where((signal) => signal.weight > 0)
        .toList(growable: false);
    final available = signals.where((signal) => signal.available).toList();
    final availableConfidence = confidenceSignals
        .where((signal) => signal.available)
        .fold<double>(0, (sum, signal) => sum + signal.weight);
    final confidenceTotal = definitions.fold<double>(
        0, (sum, definition) => sum + definition.weight);
    final rawScore = totalWeight == 0
        ? 0
        : (available.fold<double>(
                  0,
                  (sum, signal) => sum + signal.score * signal.weight,
                ) /
                totalWeight)
            .round()
            .clamp(0, 100);
    final finalScore = gate.applyScoreCap(rawScore);
    final score = StatusComponentScore(
      value: finalScore,
      label: gate.labelFor(finalScore, labelMapper.labelFor),
      confidence:
          confidenceTotal == 0 ? 0 : availableConfidence / confidenceTotal,
      availableSignals: available.length,
      totalSignals: signals.length,
    );
    return NightscoutPipelineScoreResult(
      score: score,
      breakdown: NightscoutHealthScoreBreakdown(
        rawScore: rawScore,
        finalScore: finalScore,
        confidence: score.confidence,
        availableWeight: availableConfidence,
        totalWeight: confidenceTotal,
        gate: gate,
      ),
    );
  }
}
