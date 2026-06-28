import '../../domain/trace/status_evidence_trace.dart';
import '../../domain/trace/status_evidence_trace_chain.dart';

class StatusTraceChainBuilder {
  const StatusTraceChainBuilder();

  StatusEvidenceTraceChain fromTraces(Iterable<StatusEvidenceTrace> traces) {
    return StatusEvidenceTraceChain(traces: traces.toList(growable: false));
  }
}
