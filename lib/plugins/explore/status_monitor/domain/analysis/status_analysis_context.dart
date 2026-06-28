import '../component_evidence/status_component_evidence_bundle.dart'
    as component;
import '../evidence/status_evidence_bundle.dart';

class StatusAnalysisContext {
  final DateTime now;
  final StatusEvidenceBundle evidence;
  final component.StatusComponentEvidenceBundle? componentEvidence;

  const StatusAnalysisContext({
    required this.now,
    required this.evidence,
    this.componentEvidence,
  });
}
