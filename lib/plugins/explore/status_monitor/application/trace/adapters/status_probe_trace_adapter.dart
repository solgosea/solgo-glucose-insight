import '../../../domain/probe/status_probe_result.dart';
import '../../../domain/trace/status_evidence_trace.dart';
import '../../../domain/trace/status_evidence_trace_kind.dart';
import '../../../domain/trace/status_evidence_trace_scope.dart';
import '../../../domain/trace/status_evidence_trace_source.dart';
import '../../../domain/trace/status_evidence_trace_state.dart';
import '../../state_mapping/status_observation_mapping_policy.dart';
import '../status_evidence_trace_builder.dart';
import '../status_trace_id_factory.dart';
import '../status_trace_step_factory.dart';

class StatusProbeTraceAdapter {
  final StatusObservationMappingPolicy mappingPolicy;
  final StatusEvidenceTraceBuilder builder;
  final StatusTraceIdFactory idFactory;
  final StatusTraceStepFactory stepFactory;

  const StatusProbeTraceAdapter({
    this.mappingPolicy = const StatusObservationMappingPolicy(),
    this.builder = const StatusEvidenceTraceBuilder(),
    this.idFactory = const StatusTraceIdFactory(),
    this.stepFactory = const StatusTraceStepFactory(),
  });

  StatusEvidenceTrace fromProbe(StatusProbeResult result) {
    final mapped = mappingPolicy.fromProbeState(result.state);
    final sourceRef =
        result.sourceRefs.isEmpty ? null : result.sourceRefs.first;
    return builder.build(
      id: idFactory.probe(result.probeId, result.observedAt),
      kind: StatusEvidenceTraceKind.probe,
      scope: StatusEvidenceTraceScope.probe,
      label: result.definition.label,
      probeId: result.probeId,
      suiteId: result.definition.suiteId,
      source: StatusEvidenceTraceSource(
        sourceKind: sourceRef?.source ?? result.definition.kind.name,
        sourceId: sourceRef?.detail ?? result.probeId,
        sourcePath: sourceRef?.path,
      ),
      state: StatusEvidenceTraceState(
        rawState: result.state.name,
        mappedState: mapped.state.name,
        label: mapped.label.shortLabel,
      ),
      confidence: result.confidence,
      observedAt: result.observedAt,
      steps: [
        stepFactory.step(
          kind: StatusEvidenceTraceKind.probe,
          scope: StatusEvidenceTraceScope.probe,
          title: 'Probe result',
          body:
              '${result.probeId} returned ${result.state.name}: ${result.summary}',
          at: result.observedAt,
        ),
      ],
    );
  }
}
