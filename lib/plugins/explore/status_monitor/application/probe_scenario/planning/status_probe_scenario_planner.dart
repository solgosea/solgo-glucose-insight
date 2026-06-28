import '../../../domain/probe/status_probe_catalog.dart';
import '../../../domain/probe/status_probe_score_scope.dart';
import '../../../domain/probe_scenario/status_probe_scenario_definition.dart';
import '../../../domain/probe_scenario/status_probe_scenario_plan.dart';
import '../../../domain/probe_scenario/status_probe_scenario_plan_item.dart';

class StatusProbeScenarioPlanner {
  const StatusProbeScenarioPlanner();

  StatusProbeScenarioPlan build({
    required StatusProbeCatalog catalog,
    required StatusProbeScenarioDefinition scenario,
  }) {
    final items = <StatusProbeScenarioPlanItem>[];
    for (final scenarioItem
        in scenario.items.where((item) => item.enabled).toList()
          ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex))) {
      final probes = _probesForItem(catalog, scenarioItem);
      for (final probe in probes) {
        final suite = _suite(catalog, probe.suiteId);
        final scope = scenarioItem.scoreScope ??
            _defaultScope(
              probe: probe,
              suite: suite,
            );
        items.add(
          StatusProbeScenarioPlanItem(
            probe: probe,
            sectionId: scenarioItem.sectionId ?? scenarioItem.suiteId,
            weight: scenarioItem.weight,
            scoreScope: scope,
            hardGate: scenarioItem.hardGate,
            activationProbe:
                scenarioItem.activationProbe || probe.activationProbe,
            scoreCap: scenarioItem.scoreCap,
            orderIndex: scenarioItem.orderIndex,
          ),
        );
      }
    }
    return StatusProbeScenarioPlan(
      scenario: scenario,
      catalog: catalog,
      items: items,
    );
  }

  StatusProbeScoreScope _defaultScope({
    required StatusProbeCatalogEntry probe,
    required StatusProbeSuiteCatalogEntry? suite,
  }) {
    if (probe.scoreScope == StatusProbeScoreScope.included && suite != null) {
      return suite.scoreScope;
    }
    return probe.scoreScope;
  }

  List<StatusProbeCatalogEntry> _probesForItem(
    StatusProbeCatalog catalog,
    StatusProbeScenarioItem item,
  ) {
    if (item.probeId != null) {
      return catalog.probes
          .where((probe) =>
              probe.enabled &&
              probe.suiteId == item.suiteId &&
              probe.probeId == item.probeId)
          .toList(growable: false);
    }
    return catalog.probes
        .where((probe) => probe.enabled && probe.suiteId == item.suiteId)
        .toList(growable: false)
      ..sort((a, b) => a.priority.compareTo(b.priority));
  }

  StatusProbeSuiteCatalogEntry? _suite(
    StatusProbeCatalog catalog,
    String suiteId,
  ) {
    for (final suite in catalog.suites) {
      if (suite.suiteId == suiteId) return suite;
    }
    return null;
  }
}
