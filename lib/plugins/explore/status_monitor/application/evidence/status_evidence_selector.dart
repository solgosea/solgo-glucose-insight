import '../../domain/analysis/status_analysis_context.dart';
import '../../domain/evidence/status_live_reading_evidence.dart';

abstract class StatusEvidenceSelector {
  const StatusEvidenceSelector();

  StatusLiveReadingEvidence readings(StatusAnalysisContext context);
}
