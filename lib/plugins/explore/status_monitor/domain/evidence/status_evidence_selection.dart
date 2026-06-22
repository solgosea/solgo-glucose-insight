import 'status_cached_reading_evidence.dart';
import 'status_live_reading_evidence.dart';

class StatusEvidenceSelection {
  final StatusLiveReadingEvidence cgmLiveReadings;
  final StatusCachedReadingEvidence cgmHistoryReadings;
  final StatusLiveReadingEvidence xdripLiveReadings;

  const StatusEvidenceSelection({
    required this.cgmLiveReadings,
    required this.cgmHistoryReadings,
    required this.xdripLiveReadings,
  });
}
