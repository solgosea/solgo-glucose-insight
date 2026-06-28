import '../../../domain/probe_scenario/status_probe_scenario_result.dart';
import '../../../domain/probe_scenario/status_probe_scenario_id.dart';
import '../../trace/status_evidence_trace_engine.dart';
import '../engine/status_probe_scenario_execution_state.dart';
import '../engine/status_probe_scenario_step.dart';

class BuildScenarioResultStep implements StatusProbeScenarioStep {
  final StatusEvidenceTraceEngine traceEngine;

  const BuildScenarioResultStep({
    this.traceEngine = const StatusEvidenceTraceEngine(),
  });

  @override
  String get id => 'buildResult';

  @override
  Future<StatusProbeScenarioExecutionState> execute(
    StatusProbeScenarioExecutionState state,
  ) async {
    final scenario = state.scenario;
    final bundle = state.bundle;
    final breakdown = state.breakdown;
    if (scenario == null || bundle == null || breakdown == null) {
      throw StateError(
        'Scenario, bundle, and score breakdown are required to build result.',
      );
    }
    final traceChain = traceEngine.fromProbeBundle(
      bundle,
      scenarioId: StatusProbeScenarioId(scenario.id),
      scenarioScore: breakdown.coreScore,
    );
    return state.copyWith(
      result: StatusProbeScenarioResult(
        definition: scenario,
        bundle: bundle,
        score: breakdown.coreScore,
        breakdown: breakdown,
        traceChain: traceChain,
      ),
    );
  }
}
