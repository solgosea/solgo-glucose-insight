import '../../domain/component_evidence/status_component_evidence_bundle.dart'
    as component;
import '../../domain/evidence/status_evidence_bundle.dart';
import '../../domain/probe/status_probe_evidence_bundle.dart';
import 'status_component_probe_mapping.dart';

class StatusComponentEvidenceAdapter {
  final StatusComponentProbeMapping probeMapping;

  const StatusComponentEvidenceAdapter({
    this.probeMapping = const StatusComponentProbeMapping(),
  });

  component.StatusComponentEvidenceBundle build({
    required String subjectId,
    required DateTime generatedAt,
    required StatusEvidenceBundle statusEvidence,
    StatusProbeEvidenceBundle? probeEvidence,
  }) {
    return component.StatusComponentEvidenceBundle(
      subjectId: subjectId,
      generatedAt: generatedAt,
      statusEvidence: statusEvidence,
      probeEvidence: probeEvidence,
      snapshots: probeMapping.map(probeEvidence),
    );
  }
}
