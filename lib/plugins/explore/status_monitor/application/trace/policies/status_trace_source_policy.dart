import '../../../domain/trace/status_evidence_trace.dart';

class StatusTraceSourcePolicy {
  const StatusTraceSourcePolicy();

  bool hasConcreteSource(StatusEvidenceTrace trace) {
    return trace.source.sourceKind != 'unavailable' &&
        trace.source.sourceId != 'unavailable';
  }
}
