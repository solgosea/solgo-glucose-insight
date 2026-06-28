import 'status_evidence_trace_ref.dart';

class StatusEvidenceTraceSource {
  final String sourceKind;
  final String sourceId;
  final String? sourcePath;
  final List<StatusEvidenceTraceRef> refs;

  const StatusEvidenceTraceSource({
    required this.sourceKind,
    required this.sourceId,
    this.sourcePath,
    this.refs = const [],
  });

  static const unavailable = StatusEvidenceTraceSource(
    sourceKind: 'unavailable',
    sourceId: 'unavailable',
  );

  Map<String, Object?> toJson() => {
        'sourceKind': sourceKind,
        'sourceId': sourceId,
        'sourcePath': sourcePath,
        'refs': refs.map((ref) => ref.toJson()).toList(),
      };
}
