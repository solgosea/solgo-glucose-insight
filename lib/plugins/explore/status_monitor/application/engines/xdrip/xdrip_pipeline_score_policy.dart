import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/rules/status_rule_definition.dart';
import '../../../domain/scoring/status_component_score.dart';
import '../../../domain/xdrip/xdrip_health_score_breakdown.dart';
import '../../../domain/xdrip/xdrip_pipeline_gate_result.dart';
import '../../scoring/status_rule_score_mapper.dart';
import 'xdrip_score_label_mapper.dart';

class XdripPipelineScoreResult {
  final StatusComponentScore score;
  final XdripHealthScoreBreakdown breakdown;

  const XdripPipelineScoreResult({
    required this.score,
    required this.breakdown,
  });
}

class XdripPipelineScorePolicy {
  final StatusRuleScoreMapper scoreMapper;
  final XdripScoreLabelMapper labelMapper;

  const XdripPipelineScorePolicy({
    this.scoreMapper = const StatusRuleScoreMapper(),
    this.labelMapper = const XdripScoreLabelMapper(),
  });

  XdripPipelineScoreResult calculate({
    required List<StatusRuleResult> results,
    required List<StatusRuleDefinition> definitions,
    required XdripPipelineGateResult gate,
    required String readingSourceLabel,
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
        .where((signal) => signal.weight > 0)
        .toList(growable: false);
    final totalWeight = definitions
        .where((definition) => definition.weight > 0)
        .fold<double>(0, (sum, definition) => sum + definition.weight);
    final available = signals.where((signal) => signal.available).toList();
    final availableWeight = available.fold<double>(
      0,
      (sum, signal) => sum + signal.weight,
    );
    final weightedSum = available.fold<double>(
      0,
      (sum, signal) => sum + signal.score * signal.weight,
    );
    final rawScore = totalWeight == 0
        ? 0
        : (weightedSum / totalWeight).round().clamp(0, 100);
    final finalScore = gate.applyScoreCap(rawScore);
    final score = StatusComponentScore(
      value: finalScore,
      label: gate.labelFor(finalScore, labelMapper.labelFor),
      confidence: totalWeight == 0 ? 0 : availableWeight / totalWeight,
      availableSignals: available.length,
      totalSignals: signals.length,
    );
    return XdripPipelineScoreResult(
      score: score,
      breakdown: XdripHealthScoreBreakdown(
        rawScore: rawScore,
        finalScore: finalScore,
        confidence: score.confidence,
        availableWeight: availableWeight,
        totalWeight: totalWeight,
        readingSourceLabel: readingSourceLabel,
        gate: gate,
      ),
    );
  }
}
