import '../../../domain/status_component_kind.dart';
import '../../../domain/trace/status_evidence_trace.dart';
import '../../../domain/trace/status_evidence_trace_kind.dart';
import '../../../domain/trace/status_evidence_trace_scope.dart';
import '../status_trace_step_factory.dart';

class StatusComponentTraceAdapter {
  final StatusTraceStepFactory stepFactory;

  const StatusComponentTraceAdapter({
    this.stepFactory = const StatusTraceStepFactory(),
  });

  StatusEvidenceTrace attachComponent({
    required StatusEvidenceTrace trace,
    required StatusComponentKind componentKind,
    required String factId,
  }) {
    return trace.copyWith(
      kind: StatusEvidenceTraceKind.componentEvidence,
      scope: StatusEvidenceTraceScope.component,
      componentKind: componentKind.name,
      steps: [
        ...trace.steps,
        stepFactory.step(
          kind: StatusEvidenceTraceKind.componentEvidence,
          scope: StatusEvidenceTraceScope.component,
          title: 'Component evidence',
          body:
              'Mapped probe ${trace.probeId ?? factId} into ${componentKind.name} evidence fact $factId.',
        ),
      ],
    );
  }
}
