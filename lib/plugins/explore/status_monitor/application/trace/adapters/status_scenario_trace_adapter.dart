import '../../../domain/probe_scenario/status_probe_scenario_id.dart';
import '../../../domain/trace/status_evidence_trace_chain.dart';
import '../../../domain/trace/status_evidence_trace_kind.dart';
import '../../../domain/trace/status_evidence_trace_scope.dart';
import '../status_trace_step_factory.dart';

class StatusScenarioTraceAdapter {
  final StatusTraceStepFactory stepFactory;

  const StatusScenarioTraceAdapter({
    this.stepFactory = const StatusTraceStepFactory(),
  });

  StatusEvidenceTraceChain attachScenario({
    required StatusEvidenceTraceChain chain,
    required StatusProbeScenarioId scenarioId,
    required int score,
  }) {
    return StatusEvidenceTraceChain(
      traces: chain.traces
          .map(
            (trace) => trace.copyWith(
              kind: StatusEvidenceTraceKind.scenario,
              scope: StatusEvidenceTraceScope.scenario,
              scenarioId: scenarioId.value,
              steps: [
                ...trace.steps,
                stepFactory.step(
                  kind: StatusEvidenceTraceKind.scenario,
                  scope: StatusEvidenceTraceScope.scenario,
                  title: 'Scenario scoring',
                  body:
                      'Scenario ${scenarioId.value} included this evidence. Current scenario score: $score.',
                ),
              ],
            ),
          )
          .toList(growable: false),
    );
  }
}
