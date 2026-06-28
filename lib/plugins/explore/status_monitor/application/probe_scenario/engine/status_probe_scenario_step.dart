import 'status_probe_scenario_execution_state.dart';

abstract class StatusProbeScenarioStep {
  String get id;

  Future<StatusProbeScenarioExecutionState> execute(
    StatusProbeScenarioExecutionState state,
  );
}
