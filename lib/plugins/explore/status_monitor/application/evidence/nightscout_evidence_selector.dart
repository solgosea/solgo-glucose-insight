import '../../domain/analysis/status_analysis_context.dart';
import '../../domain/evidence/nightscout_evidence.dart';
import '../../domain/evidence/status_evidence_source_kind.dart';
import '../../domain/evidence/status_live_reading_evidence.dart';
import 'status_evidence_selector.dart';

class NightscoutEvidenceSelector extends StatusEvidenceSelector {
  const NightscoutEvidenceSelector();

  @override
  StatusLiveReadingEvidence readings(StatusAnalysisContext context) {
    final evidence = context.evidence.nightscoutEvidence;
    if (evidence.hasReadings) {
      return StatusLiveReadingEvidence(
        sourceKind: StatusEvidenceSourceKind.nightscout,
        sourceLabel: '${evidence.sourceLabel} readings',
        readings: evidence.readings,
        generatedAt: evidence.generatedAt,
      );
    }
    return const StatusLiveReadingEvidence.none(
      failureLabel: 'Nightscout readings are not available.',
    );
  }

  NightscoutEvidence nightscout(StatusAnalysisContext context) {
    return context.evidence.nightscoutEvidence;
  }
}
