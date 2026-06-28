import 'status_evidence_trace_kind.dart';
import 'status_evidence_trace_scope.dart';

class StatusEvidenceTraceStep {
  final StatusEvidenceTraceKind kind;
  final StatusEvidenceTraceScope scope;
  final String title;
  final String body;
  final DateTime? at;

  const StatusEvidenceTraceStep({
    required this.kind,
    required this.scope,
    required this.title,
    required this.body,
    this.at,
  });

  Map<String, Object?> toJson() => {
        'kind': kind.name,
        'scope': scope.name,
        'title': title,
        'body': body,
        'at': at?.millisecondsSinceEpoch,
      };
}
