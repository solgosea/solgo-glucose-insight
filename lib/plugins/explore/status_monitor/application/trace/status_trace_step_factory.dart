import '../../domain/trace/status_evidence_trace_kind.dart';
import '../../domain/trace/status_evidence_trace_scope.dart';
import '../../domain/trace/status_evidence_trace_step.dart';

class StatusTraceStepFactory {
  const StatusTraceStepFactory();

  StatusEvidenceTraceStep step({
    required StatusEvidenceTraceKind kind,
    required StatusEvidenceTraceScope scope,
    required String title,
    required String body,
    DateTime? at,
  }) {
    return StatusEvidenceTraceStep(
      kind: kind,
      scope: scope,
      title: title,
      body: body,
      at: at,
    );
  }
}
