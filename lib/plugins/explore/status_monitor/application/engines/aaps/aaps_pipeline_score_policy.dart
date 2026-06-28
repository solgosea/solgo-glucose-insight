import '../../../domain/aaps/aaps_health_score_breakdown.dart';
import '../../../domain/aaps/aaps_pipeline_gate_result.dart';
import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/rules/status_rule_definition.dart';
import '../../../domain/scoring/status_component_score.dart';
import '../../scoring/status_rule_score_mapper.dart';
import 'aaps_score_label_mapper.dart';

class AapsPipelineScoreResult {
  final StatusComponentScore score;
  final AapsHealthScoreBreakdown breakdown;

  const AapsPipelineScoreResult({
    required this.score,
    required this.breakdown,
  });
}

class AapsPipelineScorePolicy {
  final StatusRuleScoreMapper scoreMapper;
  final AapsScoreLabelMapper labelMapper;

  const AapsPipelineScorePolicy({
    this.scoreMapper = const StatusRuleScoreMapper(),
    this.labelMapper = const AapsScoreLabelMapper(),
  });

  AapsPipelineScoreResult calculate({
    required List<StatusRuleResult> results,
    required List<StatusRuleDefinition> definitions,
    required AapsPipelineGateResult gate,
  }) {
    const scoreRuleIds = {
      'aaps.xdrip_bg_source',
      'aaps.sync_freshness',
      'aaps.loop_context',
      'aaps.nightscout_dependency',
    };
    final definitionsById = {
      for (final definition in definitions) definition.ruleId.value: definition,
    };
    final scoreSignals = results
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
    final available = scoreSignals.where((signal) => signal.available).toList();
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
      totalSignals: scoreSignals.length,
    );
    return AapsPipelineScoreResult(
      score: score,
      breakdown: AapsHealthScoreBreakdown(
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
