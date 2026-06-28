import '../status_component_kind.dart';
import '../trace/status_evidence_trace_chain.dart';
import 'status_component_evidence_fact.dart';
import 'status_component_evidence_state.dart';

class StatusComponentEvidenceSnapshot {
  final StatusComponentKind kind;
  final StatusComponentEvidenceState state;
  final DateTime? latestObservedAt;
  final double confidence;
  final List<StatusComponentEvidenceFact> facts;
  final StatusEvidenceTraceChain traceChain;

  const StatusComponentEvidenceSnapshot({
    required this.kind,
    required this.state,
    this.latestObservedAt,
    required this.confidence,
    required this.facts,
    this.traceChain = StatusEvidenceTraceChain.empty,
  });

  StatusComponentEvidenceFact? fact(String id) {
    for (final fact in facts) {
      if (fact.id == id) return fact;
    }
    return null;
  }
}
