import '../status_level.dart';
import '../trace/status_evidence_trace.dart';

class WatchDisplayEvidenceFact {
  final String title;
  final String body;
  final String latestLabel;
  final String sourceLabel;
  final StatusLevel level;
  final DateTime? observedAt;
  final StatusEvidenceTrace trace;

  const WatchDisplayEvidenceFact({
    required this.title,
    required this.body,
    required this.latestLabel,
    required this.sourceLabel,
    required this.level,
    required this.observedAt,
    this.trace = StatusEvidenceTrace.empty,
  });

  Map<String, Object?> toJson() => {
        'title': title,
        'body': body,
        'latestLabel': latestLabel,
        'sourceLabel': sourceLabel,
        'level': level.name,
        'observedAt': observedAt?.millisecondsSinceEpoch,
        'trace': trace.toJson(),
      };
}
