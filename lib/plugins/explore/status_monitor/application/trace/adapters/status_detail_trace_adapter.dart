import '../../../domain/trace/status_evidence_trace.dart';
import '../../../domain/trace/status_evidence_trace_kind.dart';
import '../../../domain/trace/status_evidence_trace_scope.dart';
import '../status_trace_step_factory.dart';

class StatusDetailTraceAdapter {
  final StatusTraceStepFactory stepFactory;

  const StatusDetailTraceAdapter({
    this.stepFactory = const StatusTraceStepFactory(),
  });

  StatusEvidenceTrace attachDetail({
    required StatusEvidenceTrace trace,
    required String detailSection,
  }) {
    return trace.copyWith(
      kind: StatusEvidenceTraceKind.componentDetail,
      scope: StatusEvidenceTraceScope.detail,
      steps: [
        ...trace.steps,
        stepFactory.step(
          kind: StatusEvidenceTraceKind.componentDetail,
          scope: StatusEvidenceTraceScope.detail,
          title: 'Detail display',
          body: 'Displayed in detail section $detailSection.',
        ),
      ],
    );
  }
}
