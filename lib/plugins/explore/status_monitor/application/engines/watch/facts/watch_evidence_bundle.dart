import '../../../../domain/component_evidence/status_component_evidence_fact.dart';
import '../../../../domain/component_evidence/status_component_evidence_snapshot.dart';
import '../../../../domain/component_evidence/status_component_evidence_state.dart';
import 'watch_path_fact.dart';
import 'watch_signal_fact.dart';

class WatchEvidenceBundle {
  final StatusComponentEvidenceSnapshot? snapshot;
  final List<StatusComponentEvidenceFact> evidenceFacts;
  final List<WatchPathFact> pathFacts;
  final List<WatchSignalFact> signalFacts;

  const WatchEvidenceBundle({
    required this.snapshot,
    required this.evidenceFacts,
    required this.pathFacts,
    required this.signalFacts,
  });

  int get expectedCount => pathFacts.isEmpty ? 4 : pathFacts.length;

  int get availableCount =>
      evidenceFacts.where((fact) => fact.state.available).length;

  WatchPathFact? pathFact(String id) {
    for (final fact in pathFacts) {
      if (fact.id == id) return fact;
    }
    return null;
  }
}
