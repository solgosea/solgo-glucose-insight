import 'status_component_evidence_source_ref.dart';
import 'status_component_evidence_state.dart';
import '../trace/status_evidence_trace.dart';

class StatusComponentEvidenceFact {
  final String id;
  final String label;
  final String valueLabel;
  final StatusComponentEvidenceState state;
  final DateTime? observedAt;
  final double confidence;
  final StatusComponentEvidenceSourceRef source;
  final StatusEvidenceTrace trace;

  const StatusComponentEvidenceFact({
    required this.id,
    required this.label,
    required this.valueLabel,
    required this.state,
    this.observedAt,
    required this.confidence,
    required this.source,
    this.trace = StatusEvidenceTrace.empty,
  });
}
