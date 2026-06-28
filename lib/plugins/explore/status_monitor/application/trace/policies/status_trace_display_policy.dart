import '../../../domain/trace/status_evidence_trace.dart';
import 'status_trace_redaction_policy.dart';

class StatusTraceDisplayPolicy {
  final StatusTraceRedactionPolicy redactionPolicy;

  const StatusTraceDisplayPolicy({
    this.redactionPolicy = const StatusTraceRedactionPolicy(),
  });

  String sourceLabel(StatusEvidenceTrace trace) {
    final source = trace.source.sourcePath == null
        ? trace.source.sourceId
        : '${trace.source.sourceId} · ${trace.source.sourcePath}';
    return redactionPolicy.redact(source);
  }
}
