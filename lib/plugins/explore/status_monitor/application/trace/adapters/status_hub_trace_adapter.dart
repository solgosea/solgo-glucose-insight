import '../../../domain/hub/status_hub_models.dart';
import '../../../domain/trace/status_evidence_trace.dart';
import '../../../domain/trace/status_evidence_trace_kind.dart';
import '../../../domain/trace/status_evidence_trace_scope.dart';
import '../status_trace_step_factory.dart';

class StatusHubTraceAdapter {
  final StatusTraceStepFactory stepFactory;

  const StatusHubTraceAdapter({
    this.stepFactory = const StatusTraceStepFactory(),
  });

  StatusEvidenceTrace attachHubEvidence({
    required StatusEvidenceTrace trace,
    required String evidenceId,
  }) {
    return trace.copyWith(
      kind: StatusEvidenceTraceKind.hubFact,
      scope: StatusEvidenceTraceScope.hub,
      steps: [
        ...trace.steps,
        stepFactory.step(
          kind: StatusEvidenceTraceKind.hubFact,
          scope: StatusEvidenceTraceScope.hub,
          title: 'Hub fact',
          body: 'Mapped evidence into Hub evidence $evidenceId.',
        ),
      ],
    );
  }

  StatusEvidenceTrace attachHubMetric({
    required StatusEvidenceTrace trace,
    required StatusHubMetricFact metric,
  }) {
    return trace.copyWith(
      kind: StatusEvidenceTraceKind.hubMetric,
      scope: StatusEvidenceTraceScope.hub,
      steps: [
        ...trace.steps,
        stepFactory.step(
          kind: StatusEvidenceTraceKind.hubMetric,
          scope: StatusEvidenceTraceScope.hub,
          title: 'Hub metric',
          body: 'Mapped evidence into Hub metric ${metric.id}.',
        ),
      ],
    );
  }
}
