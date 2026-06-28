import '../engine/status_probe_scenario_execution_state.dart';
import '../engine/status_probe_scenario_step.dart';
import '../planning/status_probe_scenario_planner.dart';

class BuildScenarioPlanStep implements StatusProbeScenarioStep {
  final StatusProbeScenarioPlanner planner;

  const BuildScenarioPlanStep({
    this.planner = const StatusProbeScenarioPlanner(),
  });

  @override
  String get id => 'buildPlan';

  @override
  Future<StatusProbeScenarioExecutionState> execute(
    StatusProbeScenarioExecutionState state,
  ) async {
    final catalog = state.catalog;
    final scenario = state.scenario;
    if (catalog == null || scenario == null) {
      throw StateError('Catalog and scenario must be available to build plan.');
    }
    return state.copyWith(
      plan: planner.build(catalog: catalog, scenario: scenario),
    );
  }
}
