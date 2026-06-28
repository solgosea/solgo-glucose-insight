import '../../probe/catalog/status_probe_catalog_service.dart';
import '../engine/status_probe_scenario_execution_state.dart';
import '../engine/status_probe_scenario_step.dart';

class LoadProbeCatalogStep implements StatusProbeScenarioStep {
  final StatusProbeCatalogService catalogService;

  const LoadProbeCatalogStep({required this.catalogService});

  @override
  String get id => 'loadCatalog';

  @override
  Future<StatusProbeScenarioExecutionState> execute(
    StatusProbeScenarioExecutionState state,
  ) async {
    return state.copyWith(catalog: await catalogService.load());
  }
}
