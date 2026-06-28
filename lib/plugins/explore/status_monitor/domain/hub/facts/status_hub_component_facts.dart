import '../../status_component_kind.dart';
import '../../trace/status_evidence_trace_chain.dart';
import '../status_hub_enums.dart';
import '../status_hub_models.dart';

class StatusHubComponentFacts {
  final StatusHubNodeId nodeId;
  final StatusComponentKind kind;
  final String label;
  final StatusHubNodeRole role;
  final StatusHubState state;
  final DateTime? latestObservedAt;
  final Duration? age;
  final double confidence;
  final int availableEvidence;
  final int expectedEvidence;
  final List<StatusHubEvidenceRef> evidence;
  final String? detailRoute;
  final Map<String, Object?> detail;
  final StatusEvidenceTraceChain traceChain;

  const StatusHubComponentFacts({
    required this.nodeId,
    required this.kind,
    required this.label,
    required this.role,
    required this.state,
    this.latestObservedAt,
    this.age,
    required this.confidence,
    required this.availableEvidence,
    required this.expectedEvidence,
    required this.evidence,
    this.detailRoute,
    this.detail = const {},
    this.traceChain = StatusEvidenceTraceChain.empty,
  });
}
