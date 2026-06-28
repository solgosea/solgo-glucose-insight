import 'status_evidence_trace.dart';
import 'status_evidence_trace_summary.dart';

class StatusEvidenceTraceChain {
  final List<StatusEvidenceTrace> traces;

  const StatusEvidenceTraceChain({required this.traces});

  static const empty = StatusEvidenceTraceChain(traces: []);

  StatusEvidenceTrace? traceForProbe(String probeId) {
    for (final trace in traces) {
      if (trace.probeId == probeId) return trace;
    }
    return null;
  }

  StatusEvidenceTraceSummary get summary {
    if (traces.isEmpty) return StatusEvidenceTraceSummary.unavailable;
    final latest = traces.reduce((a, b) {
      final aAt = a.observedAt;
      final bAt = b.observedAt;
      if (aAt == null) return b;
      if (bAt == null) return a;
      return bAt.isAfter(aAt) ? b : a;
    });
    return latest.summary;
  }

  StatusEvidenceTraceChain append(StatusEvidenceTrace trace) {
    return StatusEvidenceTraceChain(traces: [...traces, trace]);
  }

  StatusEvidenceTraceChain merge(StatusEvidenceTraceChain other) {
    return StatusEvidenceTraceChain(traces: [...traces, ...other.traces]);
  }

  Map<String, Object?> toJson() => {
        'traces': traces.map((trace) => trace.toJson()).toList(),
      };
}
