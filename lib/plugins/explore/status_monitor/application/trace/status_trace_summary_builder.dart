import '../../domain/trace/status_evidence_trace_chain.dart';
import '../../domain/trace/status_evidence_trace_summary.dart';

class StatusTraceSummaryBuilder {
  const StatusTraceSummaryBuilder();

  StatusEvidenceTraceSummary summarize(StatusEvidenceTraceChain chain) {
    return chain.summary;
  }
}
