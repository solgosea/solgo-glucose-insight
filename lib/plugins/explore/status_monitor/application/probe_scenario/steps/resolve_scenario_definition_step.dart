import '../../../domain/probe_scenario/status_probe_scenario_definition.dart';
import '../engine/status_probe_scenario_execution_state.dart';
import '../engine/status_probe_scenario_step.dart';

class ResolveScenarioDefinitionStep implements StatusProbeScenarioStep {
  const ResolveScenarioDefinitionStep();

  @override
  String get id => 'resolveScenario';

  @override
  Future<StatusProbeScenarioExecutionState> execute(
    StatusProbeScenarioExecutionState state,
  ) async {
    final catalog = state.catalog;
    if (catalog == null) {
      throw StateError(
          'Probe catalog must be loaded before resolving scenario.');
    }
    final scenario = catalog.scenarios.firstWhere(
      (item) => item.id == state.input.scenarioId,
      orElse: () => StatusProbeScenarioDefinition(
        id: state.input.scenarioId,
        titleKey: state.input.scenarioId,
        descriptionKey: state.input.scenarioId,
        items: const [],
      ),
    );
    return state.copyWith(scenario: scenario);
  }
}
