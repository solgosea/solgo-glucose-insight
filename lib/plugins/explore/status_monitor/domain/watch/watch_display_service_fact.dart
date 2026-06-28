import '../status_level.dart';
import '../trace/status_evidence_trace.dart';

class WatchDisplayServiceFact {
  final String id;
  final String label;
  final String value;
  final String body;
  final StatusLevel level;
  final double score;
  final StatusEvidenceTrace trace;

  const WatchDisplayServiceFact({
    required this.id,
    required this.label,
    required this.value,
    required this.body,
    required this.level,
    required this.score,
    this.trace = StatusEvidenceTrace.empty,
  });

  Map<String, Object?> toJson() => {
        'id': id,
        'label': label,
        'value': value,
        'body': body,
        'level': level.name,
        'score': score,
        'trace': trace.toJson(),
      };
}
