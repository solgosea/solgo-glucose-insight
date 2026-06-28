import '../probe/status_probe_catalog.dart';
import 'status_probe_scenario_definition.dart';
import 'status_probe_scenario_plan_item.dart';

class StatusProbeScenarioPlan {
  final StatusProbeScenarioDefinition scenario;
  final StatusProbeCatalog catalog;
  final List<StatusProbeScenarioPlanItem> items;

  const StatusProbeScenarioPlan({
    required this.scenario,
    required this.catalog,
    required this.items,
  });

  List<String> get suiteIds {
    final ids = <String>[];
    for (final item in items) {
      if (!ids.contains(item.probe.suiteId)) ids.add(item.probe.suiteId);
    }
    return ids;
  }

  List<StatusProbeScenarioPlanItem> itemsForSuite(String suiteId) {
    return items
        .where((item) => item.probe.suiteId == suiteId)
        .toList(growable: false);
  }
}
