import '../../domain/trace/status_evidence_trace.dart';
import '../../domain/trace/status_evidence_trace_chain.dart';
import '../../domain/trace/status_evidence_trace_source.dart';

class StatusTracePrivacyFilter {
  static final _sensitive = RegExp(
    r'(https?://|token|secret|api[_-]?key|subject|password)',
    caseSensitive: false,
  );

  const StatusTracePrivacyFilter();

  StatusEvidenceTraceChain filter(StatusEvidenceTraceChain chain) {
    return StatusEvidenceTraceChain(
      traces: chain.traces.map(_filterTrace).toList(growable: false),
    );
  }

  StatusEvidenceTrace _filterTrace(StatusEvidenceTrace trace) {
    if (!_sensitive.hasMatch(trace.source.sourceId) &&
        (trace.source.sourcePath == null ||
            !_sensitive.hasMatch(trace.source.sourcePath!))) {
      return trace;
    }
    return trace.copyWith(
      source: StatusEvidenceTraceSource(
        sourceKind: trace.source.sourceKind,
        sourceId: 'Configured source',
        sourcePath: trace.source.sourcePath == null ? null : 'redacted',
      ),
    );
  }
}
