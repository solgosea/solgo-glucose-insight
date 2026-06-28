import '../../../domain/trace/status_evidence_trace.dart';
import '../../../domain/trace/status_evidence_trace_kind.dart';
import '../../../domain/trace/status_evidence_trace_scope.dart';
import '../status_trace_step_factory.dart';

class StatusReportTraceAdapter {
  final StatusTraceStepFactory stepFactory;

  const StatusReportTraceAdapter({
    this.stepFactory = const StatusTraceStepFactory(),
  });

  StatusEvidenceTrace attachReport({
    required StatusEvidenceTrace trace,
    required String reportSection,
  }) {
    return trace.copyWith(
      kind: StatusEvidenceTraceKind.report,
      scope: StatusEvidenceTraceScope.report,
      steps: [
        ...trace.steps,
        stepFactory.step(
          kind: StatusEvidenceTraceKind.report,
          scope: StatusEvidenceTraceScope.report,
          title: 'Report payload',
          body: 'Included in report section $reportSection.',
        ),
      ],
    );
  }
}
