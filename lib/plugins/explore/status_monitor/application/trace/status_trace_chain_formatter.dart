import '../../domain/trace/status_evidence_trace.dart';
import '../../domain/trace/status_evidence_trace_chain.dart';

class StatusTraceChainFormatter {
  const StatusTraceChainFormatter();

  String compact(StatusEvidenceTraceChain chain) {
    if (chain.traces.isEmpty) return 'Evidence unavailable';
    final trace = chain.traces.first;
    return compactTrace(trace);
  }

  String compactTrace(StatusEvidenceTrace trace) {
    final parts = <String>[
      trace.state.label,
      if (trace.probeId != null) trace.probeId!,
      trace.confidence.label,
    ];
    return parts.join(' · ');
  }
}
