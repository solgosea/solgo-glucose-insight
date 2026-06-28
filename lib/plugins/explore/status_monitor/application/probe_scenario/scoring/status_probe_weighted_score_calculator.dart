import '../../../domain/probe/status_probe_result.dart';
import '../../../domain/probe/status_probe_score_scope.dart';
import '../../../domain/probe/status_probe_state.dart';
import '../../../domain/probe_scenario/status_probe_scenario_plan.dart';
import '../../../domain/probe_scenario/status_probe_scenario_score_breakdown.dart';
import 'status_probe_gate_rule_evaluator.dart';
import 'status_probe_score_cap_evaluator.dart';
import 'status_probe_score_value_mapper.dart';

class StatusProbeWeightedScoreCalculator {
  final StatusProbeScoreValueMapper valueMapper;
  final StatusProbeGateRuleEvaluator gateEvaluator;
  final StatusProbeScoreCapEvaluator capEvaluator;

  const StatusProbeWeightedScoreCalculator({
    this.valueMapper = const StatusProbeScoreValueMapper(),
    this.gateEvaluator = const StatusProbeGateRuleEvaluator(),
    this.capEvaluator = const StatusProbeScoreCapEvaluator(),
  });

  StatusProbeScenarioScoreBreakdown calculate({
    required StatusProbeScenarioPlan plan,
    required Iterable<StatusProbeResult> results,
  }) {
    final byId = {
      for (final result in results) result.probeId: result,
    };
    var totalWeight = 0.0;
    var totalScore = 0.0;
    var passing = 0;
    var total = 0;
    var optionalActive = 0;
    var optionalTotal = 0;
    final gateFailures = <String>[];
    final caps = <int>[];
    for (final item in plan.items) {
      final result = byId[item.probe.probeId];
      if (item.scoreScope == StatusProbeScoreScope.excluded) {
        optionalTotal++;
        if (result?.state.hasUsefulEvidence ?? false) optionalActive++;
        continue;
      }
      if (item.scoreScope != StatusProbeScoreScope.included) continue;
      total++;
      if (result?.state == StatusProbeState.healthy) passing++;
      final weight = item.weight <= 0 ? 1.0 : item.weight;
      totalWeight += weight;
      totalScore += valueMapper.map(
            result?.state ?? StatusProbeState.unknown,
            result?.confidence ?? 0,
          ) *
          weight;
      if (gateEvaluator.failed(item, result)) {
        gateFailures.add(item.probe.probeId);
      }
      if (item.scoreCap != null &&
          result != null &&
          result.state != StatusProbeState.healthy) {
        caps.add(item.scoreCap!);
      }
    }
    var score = totalWeight == 0
        ? 0
        : ((totalScore / totalWeight) * 100).round().clamp(0, 100);
    if (gateFailures.isNotEmpty) caps.add(45);
    score = capEvaluator.apply(score, caps);
    return StatusProbeScenarioScoreBreakdown(
      coreScore: score,
      corePassing: passing,
      coreTotal: total,
      coreNeedsAction: total - passing,
      optionalActive: optionalActive,
      optionalTotal: optionalTotal,
      appliedGateProbeIds: gateFailures,
      appliedCapProbeIds: [
        for (final item in plan.items)
          if (item.scoreCap != null &&
              byId[item.probe.probeId] != null &&
              byId[item.probe.probeId]!.state != StatusProbeState.healthy)
            item.probe.probeId,
      ],
    );
  }
}
