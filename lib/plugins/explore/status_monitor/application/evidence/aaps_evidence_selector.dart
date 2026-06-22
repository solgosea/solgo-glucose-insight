import '../../domain/analysis/status_analysis_context.dart';
import '../../domain/evidence/aaps_evidence.dart';

class AapsEvidenceSelector {
  const AapsEvidenceSelector();

  AapsEvidence evidence(StatusAnalysisContext context) {
    return context.evidence.aapsEvidence;
  }
}
