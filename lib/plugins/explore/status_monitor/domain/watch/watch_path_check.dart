import '../status_level.dart';
import '../trace/status_evidence_trace.dart';

class WatchPathCheck {
  final String id;
  final String title;
  final String body;
  final String valueLabel;
  final StatusLevel level;
  final DateTime? observedAt;
  final double confidence;
  final String sourceLabel;
  final StatusEvidenceTrace trace;

  const WatchPathCheck({
    required this.id,
    required this.title,
    required this.body,
    required this.valueLabel,
    required this.level,
    required this.observedAt,
    required this.confidence,
    required this.sourceLabel,
    this.trace = StatusEvidenceTrace.empty,
  });

  bool get available => level == StatusLevel.healthy;

  Map<String, Object?> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'valueLabel': valueLabel,
        'level': level.name,
        'observedAt': observedAt?.millisecondsSinceEpoch,
        'confidence': confidence,
        'sourceLabel': sourceLabel,
        'trace': trace.toJson(),
      };
}
