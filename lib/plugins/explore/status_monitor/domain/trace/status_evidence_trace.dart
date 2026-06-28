import 'status_evidence_trace_confidence.dart';
import 'status_evidence_trace_id.dart';
import 'status_evidence_trace_kind.dart';
import 'status_evidence_trace_scope.dart';
import 'status_evidence_trace_source.dart';
import 'status_evidence_trace_state.dart';
import 'status_evidence_trace_step.dart';
import 'status_evidence_trace_summary.dart';

class StatusEvidenceTrace {
  final StatusEvidenceTraceId id;
  final StatusEvidenceTraceKind kind;
  final StatusEvidenceTraceScope scope;
  final String label;
  final String? probeId;
  final String? suiteId;
  final String? scenarioId;
  final String? componentKind;
  final StatusEvidenceTraceSource source;
  final StatusEvidenceTraceState state;
  final StatusEvidenceTraceConfidence confidence;
  final DateTime? observedAt;
  final List<StatusEvidenceTraceStep> steps;

  const StatusEvidenceTrace({
    required this.id,
    required this.kind,
    required this.scope,
    required this.label,
    this.probeId,
    this.suiteId,
    this.scenarioId,
    this.componentKind,
    required this.source,
    required this.state,
    required this.confidence,
    this.observedAt,
    this.steps = const [],
  });

  static const empty = StatusEvidenceTrace(
    id: StatusEvidenceTraceId('empty'),
    kind: StatusEvidenceTraceKind.derivedPolicy,
    scope: StatusEvidenceTraceScope.detail,
    label: 'Evidence unavailable',
    source: StatusEvidenceTraceSource.unavailable,
    state: StatusEvidenceTraceState.unknown,
    confidence: StatusEvidenceTraceConfidence.unknown,
  );

  StatusEvidenceTraceSummary get summary => StatusEvidenceTraceSummary(
        label: label,
        sourceLabel: source.sourcePath == null
            ? source.sourceId
            : '${source.sourceId} · ${source.sourcePath}',
        stateLabel: state.label,
        confidenceLabel: confidence.label,
        observedAt: observedAt,
      );

  StatusEvidenceTrace copyWith({
    StatusEvidenceTraceKind? kind,
    StatusEvidenceTraceScope? scope,
    String? label,
    String? scenarioId,
    String? componentKind,
    StatusEvidenceTraceSource? source,
    StatusEvidenceTraceState? state,
    StatusEvidenceTraceConfidence? confidence,
    List<StatusEvidenceTraceStep>? steps,
  }) {
    return StatusEvidenceTrace(
      id: id,
      kind: kind ?? this.kind,
      scope: scope ?? this.scope,
      label: label ?? this.label,
      probeId: probeId,
      suiteId: suiteId,
      scenarioId: scenarioId ?? this.scenarioId,
      componentKind: componentKind ?? this.componentKind,
      source: source ?? this.source,
      state: state ?? this.state,
      confidence: confidence ?? this.confidence,
      observedAt: observedAt,
      steps: steps ?? this.steps,
    );
  }

  Map<String, Object?> toJson() => {
        'id': id.value,
        'kind': kind.name,
        'scope': scope.name,
        'label': label,
        'probeId': probeId,
        'suiteId': suiteId,
        'scenarioId': scenarioId,
        'componentKind': componentKind,
        'source': source.toJson(),
        'state': state.toJson(),
        'confidence': confidence.toJson(),
        'observedAt': observedAt?.millisecondsSinceEpoch,
        'steps': steps.map((step) => step.toJson()).toList(),
      };
}
