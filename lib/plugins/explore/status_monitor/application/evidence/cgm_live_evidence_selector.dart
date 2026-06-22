import '../../domain/analysis/status_analysis_context.dart';
import '../../domain/evidence/status_live_reading_evidence.dart';

class CgmLiveEvidenceSelector {
  const CgmLiveEvidenceSelector();

  StatusLiveReadingEvidence readings(StatusAnalysisContext context) {
    return context.evidence.selection.cgmLiveReadings;
  }
}
