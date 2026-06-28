import '../probe/status_probe_score_scope.dart';

class StatusProbeScenarioDefinition {
  final String id;
  final String titleKey;
  final String descriptionKey;
  final List<StatusProbeScenarioItem> items;

  const StatusProbeScenarioDefinition({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.items,
  });
}

class StatusProbeScenarioItem {
  final String suiteId;
  final String? probeId;
  final String? sectionId;
  final int orderIndex;
  final bool enabled;
  final double weight;
  final StatusProbeScoreScope? scoreScope;
  final bool hardGate;
  final bool activationProbe;
  final int? scoreCap;

  const StatusProbeScenarioItem({
    required this.suiteId,
    this.probeId,
    this.sectionId,
    required this.orderIndex,
    this.enabled = true,
    this.weight = 1,
    this.scoreScope,
    this.hardGate = false,
    this.activationProbe = false,
    this.scoreCap,
  });
}
