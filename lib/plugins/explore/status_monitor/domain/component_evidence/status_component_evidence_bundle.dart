import '../evidence/status_evidence_bundle.dart';
import '../probe/status_probe_evidence_bundle.dart';
import '../status_component_kind.dart';
import 'status_component_evidence_snapshot.dart';

class StatusComponentEvidenceBundle {
  final String subjectId;
  final DateTime generatedAt;
  final StatusEvidenceBundle statusEvidence;
  final StatusProbeEvidenceBundle? probeEvidence;
  final List<StatusComponentEvidenceSnapshot> snapshots;

  const StatusComponentEvidenceBundle({
    required this.subjectId,
    required this.generatedAt,
    required this.statusEvidence,
    this.probeEvidence,
    required this.snapshots,
  });

  StatusComponentEvidenceSnapshot? snapshot(StatusComponentKind kind) {
    for (final snapshot in snapshots) {
      if (snapshot.kind == kind) return snapshot;
    }
    return null;
  }
}
