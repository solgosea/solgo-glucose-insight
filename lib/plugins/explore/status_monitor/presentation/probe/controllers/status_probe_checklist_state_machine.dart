import '../../../application/probe_scenario/scenarios/status_probe_scenario_ids.dart';
import '../../../domain/probe/status_probe_catalog.dart';
import '../../../domain/probe/status_probe_run_result_snapshot.dart';
import '../../../domain/probe/status_probe_run_snapshot.dart';
import '../../../domain/probe/status_probe_run_suite_snapshot.dart';
import '../../../domain/probe/status_probe_state.dart';
import '../../../domain/probe/status_probe_suite_activation_state.dart';

class StatusProbeChecklistStateMachine {
  final DateTime Function() now;

  StatusProbeChecklistStateMachine({DateTime Function()? now})
      : now = now ?? DateTime.now;

  StatusProbeRunSnapshot initialSnapshot(
    StatusProbeCatalog catalog, {
    String scenarioId = StatusProbeScenarioIds.overview,
  }) {
    final effectiveNow = now();
    final scenario = catalog.scenarios.firstWhere(
      (item) => item.id == scenarioId,
      orElse: () => catalog.scenarios.isNotEmpty
          ? catalog.scenarios.first
          : throw StateError('No probe scenario configured.'),
    );
    final suiteOrder = <String>[];
    final requestedProbeIds = <String, Set<String>>{};
    for (final item in scenario.items.where((item) => item.enabled)) {
      if (!suiteOrder.contains(item.suiteId)) suiteOrder.add(item.suiteId);
      if (item.probeId != null) {
        requestedProbeIds
            .putIfAbsent(item.suiteId, () => <String>{})
            .add(item.probeId!);
      }
    }

    final suites = <StatusProbeRunSuiteSnapshot>[];
    for (final suiteId in suiteOrder) {
      final suiteEntry = _suiteEntry(catalog, suiteId);
      final requested = requestedProbeIds[suiteId] ?? const <String>{};
      final probes = catalog.probes
          .where((probe) => probe.suiteId == suiteId && probe.enabled)
          .where(
              (probe) => requested.isEmpty || requested.contains(probe.probeId))
          .toList(growable: false)
        ..sort((a, b) => a.priority.compareTo(b.priority));
      suites.add(
        StatusProbeRunSuiteSnapshot(
          suiteId: suiteId,
          catalogEntry: suiteEntry,
          state: StatusProbeState.unknown,
          activationState: suiteEntry?.scoreScope.name == 'excluded'
              ? StatusProbeSuiteActivationState.checking
              : StatusProbeSuiteActivationState.active,
          running: false,
          results: [
            for (final probe in probes)
              StatusProbeRunResultSnapshot(
                probeId: probe.probeId,
                suiteId: suiteId,
                catalogEntry: probe,
                phase: StatusProbeRunResultPhase.pending,
              ),
          ],
        ),
      );
    }

    return StatusProbeRunSnapshot(
      scenarioId: scenario.id,
      catalog: catalog,
      startedAt: effectiveNow,
      generatedAt: effectiveNow,
      running: false,
      completed: false,
      suites: suites,
    );
  }

  StatusProbeSuiteCatalogEntry? _suiteEntry(
    StatusProbeCatalog catalog,
    String suiteId,
  ) {
    for (final suite in catalog.suites) {
      if (suite.suiteId == suiteId) return suite;
    }
    return null;
  }
}
