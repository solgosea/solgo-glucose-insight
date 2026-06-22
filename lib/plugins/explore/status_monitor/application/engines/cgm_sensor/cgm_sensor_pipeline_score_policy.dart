import '../../../domain/analysis/status_rule_result.dart';
import '../../../domain/cgm_sensor/cgm_sensor_health_score_breakdown.dart';
import '../../../domain/cgm_sensor/cgm_sensor_pipeline_gate_result.dart';
import '../../../domain/rules/status_rule_definition.dart';
import '../../../domain/scoring/status_component_score.dart';
import '../../scoring/status_rule_score_mapper.dart';
import '../../scoring/status_score_label_mapper.dart';

class CgmSensorPipelineScoreResult {
  final StatusComponentScore score;
  final CgmSensorHealthScoreBreakdown breakdown;

  const CgmSensorPipelineScoreResult({
    required this.score,
    required this.breakdown,
  });
}

class CgmSensorPipelineScorePolicy {
  final StatusRuleScoreMapper scoreMapper;
  final StatusScoreLabelMapper labelMapper;

  const CgmSensorPipelineScorePolicy({
    this.scoreMapper = const StatusRuleScoreMapper(),
    this.labelMapper = const StatusScoreLabelMapper(),
  });

  CgmSensorPipelineScoreResult calculate({
    required List<StatusRuleResult> results,
    required List<StatusRuleDefinition> definitions,
    required CgmSensorPipelineGateResult gate,
    required String liveSourceLabel,
    required String historySourceLabel,
  }) {
    const coreRuleIds = {'cgm.sensor_freshness', 'cgm.signal_continuity'};
    final definitionsById = {
      for (final definition in definitions) definition.ruleId.value: definition,
    };
    final coreSignals = results
        .where((result) => coreRuleIds.contains(result.ruleId.value))
        .map(
          (result) => scoreMapper.map(
            result,
            weight: definitionsById[result.ruleId.value]?.weight ?? 0,
          ),
        )
        .where((signal) => signal.weight > 0)
        .toList(growable: false);
    final totalWeight = definitions
        .where((definition) => coreRuleIds.contains(definition.ruleId.value))
        .fold<double>(0, (sum, definition) => sum + definition.weight);
    final available = coreSignals.where((signal) => signal.available).toList();
    final availableWeight =
        available.fold<double>(0, (sum, signal) => sum + signal.weight);
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
      totalSignals: coreSignals.length,
    );
    return CgmSensorPipelineScoreResult(
      score: score,
      breakdown: CgmSensorHealthScoreBreakdown(
        rawScore: rawScore,
        finalScore: finalScore,
        confidence: score.confidence,
        availableWeight: availableWeight,
        totalWeight: totalWeight,
        liveSourceLabel: liveSourceLabel,
        historySourceLabel: historySourceLabel,
        gate: gate,
      ),
    );
  }
}
