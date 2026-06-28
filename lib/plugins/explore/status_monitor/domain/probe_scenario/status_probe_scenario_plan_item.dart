import '../probe/status_probe_catalog.dart';
import '../probe/status_probe_score_scope.dart';

class StatusProbeScenarioPlanItem {
  final StatusProbeCatalogEntry probe;
  final String sectionId;
  final double weight;
  final StatusProbeScoreScope scoreScope;
  final bool hardGate;
  final bool activationProbe;
  final int? scoreCap;
  final int orderIndex;

  const StatusProbeScenarioPlanItem({
    required this.probe,
    required this.sectionId,
    required this.weight,
    required this.scoreScope,
    required this.hardGate,
    required this.activationProbe,
    required this.orderIndex,
    this.scoreCap,
  });
}
