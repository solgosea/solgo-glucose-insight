import '../../domain/trace/status_evidence_trace.dart';
import '../../domain/trace/status_evidence_trace_confidence.dart';
import '../../domain/trace/status_evidence_trace_id.dart';
import '../../domain/trace/status_evidence_trace_kind.dart';
import '../../domain/trace/status_evidence_trace_scope.dart';
import '../../domain/trace/status_evidence_trace_source.dart';
import '../../domain/trace/status_evidence_trace_state.dart';
import '../../domain/trace/status_evidence_trace_step.dart';

class StatusEvidenceTraceBuilder {
  const StatusEvidenceTraceBuilder();

  StatusEvidenceTrace build({
    required String id,
    required StatusEvidenceTraceKind kind,
    required StatusEvidenceTraceScope scope,
    required String label,
    String? probeId,
    String? suiteId,
    String? scenarioId,
    String? componentKind,
    required StatusEvidenceTraceSource source,
    required StatusEvidenceTraceState state,
    required double confidence,
    DateTime? observedAt,
    List<StatusEvidenceTraceStep> steps = const [],
  }) {
    return StatusEvidenceTrace(
      id: StatusEvidenceTraceId(id),
      kind: kind,
      scope: scope,
      label: label,
      probeId: probeId,
      suiteId: suiteId,
      scenarioId: scenarioId,
      componentKind: componentKind,
      source: source,
      state: state,
      confidence: StatusEvidenceTraceConfidence.fromValue(confidence),
      observedAt: observedAt,
      steps: steps,
    );
  }
}
