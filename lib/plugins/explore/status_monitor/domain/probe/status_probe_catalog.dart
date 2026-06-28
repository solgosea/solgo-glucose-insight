import 'status_probe_display_definition.dart';
import 'status_probe_kind.dart';
import 'status_probe_path_role.dart';
import 'status_probe_score_scope.dart';
import '../probe_scenario/status_probe_scenario_definition.dart';

class StatusProbeCatalog {
  final List<StatusProbeSuiteCatalogEntry> suites;
  final List<StatusProbeCatalogEntry> probes;
  final List<StatusProbeScenarioDefinition> scenarios;

  const StatusProbeCatalog({
    required this.suites,
    required this.probes,
    required this.scenarios,
  });

  const StatusProbeCatalog.empty()
      : suites = const [],
        probes = const [],
        scenarios = const [];
}

class StatusProbeSuiteCatalogEntry {
  final String suiteId;
  final StatusProbeKind kind;
  final StatusProbeDisplayDefinition display;
  final StatusProbePathRole role;
  final StatusProbeScoreScope scoreScope;
  final int priority;
  final bool enabled;

  const StatusProbeSuiteCatalogEntry({
    required this.suiteId,
    required this.kind,
    required this.display,
    this.role = StatusProbePathRole.core,
    this.scoreScope = StatusProbeScoreScope.included,
    this.priority = 100,
    this.enabled = true,
  });
}

class StatusProbeCatalogEntry {
  final String probeId;
  final String suiteId;
  final String driverId;
  final StatusProbeDisplayDefinition display;
  final StatusProbePathRole role;
  final StatusProbeScoreScope scoreScope;
  final bool required;
  final bool activationProbe;
  final int priority;
  final bool enabled;

  const StatusProbeCatalogEntry({
    required this.probeId,
    required this.suiteId,
    required this.driverId,
    required this.display,
    this.role = StatusProbePathRole.core,
    this.scoreScope = StatusProbeScoreScope.included,
    this.required = false,
    this.activationProbe = false,
    this.priority = 100,
    this.enabled = true,
  });
}
