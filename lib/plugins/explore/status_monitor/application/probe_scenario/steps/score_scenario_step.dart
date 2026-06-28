import '../engine/status_probe_scenario_execution_state.dart';
import '../engine/status_probe_scenario_step.dart';
import '../scoring/status_probe_scenario_score_engine.dart';

class ScoreScenarioStep implements StatusProbeScenarioStep {
  final StatusProbeScenarioScoreEngine scoreEngine;

  const ScoreScenarioStep({
    this.scoreEngine = const StatusProbeScenarioScoreEngine(),
  });

  @override
  String get id => 'scoreScenario';

  @override
  Future<StatusProbeScenarioExecutionState> execute(
    StatusProbeScenarioExecutionState state,
  ) async {
    final plan = state.plan;
    if (plan == null) {
      throw StateError('Scenario plan must be available before scoring.');
    }
    return state.copyWith(
      breakdown: scoreEngine.score(
        plan: plan,
        suites: state.suiteResults,
      ),
    );
  }
}
