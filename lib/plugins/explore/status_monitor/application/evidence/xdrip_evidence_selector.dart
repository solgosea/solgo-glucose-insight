import '../../domain/analysis/status_analysis_context.dart';
import '../../domain/evidence/status_live_reading_evidence.dart';
import '../../domain/evidence/xdrip_local_evidence.dart';
import 'status_evidence_selector.dart';

class XdripEvidenceSelector extends StatusEvidenceSelector {
  const XdripEvidenceSelector();

  @override
  StatusLiveReadingEvidence readings(StatusAnalysisContext context) {
    return context.evidence.selection.xdripLiveReadings;
  }

  XdripLocalEvidence local(StatusAnalysisContext context) {
    return context.evidence.xdripLocalEvidence;
  }
}
