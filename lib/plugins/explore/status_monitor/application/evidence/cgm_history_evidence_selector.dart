import '../../domain/analysis/status_analysis_context.dart';
import '../../domain/evidence/status_cached_reading_evidence.dart';

class CgmHistoryEvidenceSelector {
  const CgmHistoryEvidenceSelector();

  StatusCachedReadingEvidence readings(StatusAnalysisContext context) {
    return context.evidence.selection.cgmHistoryReadings;
  }
}
