import '../../../../domain/status_level.dart';
import '../../../../domain/trace/status_evidence_trace.dart';

class WatchPathFact {
  final String id;
  final String title;
  final String body;
  final String valueLabel;
  final StatusLevel level;
  final DateTime? observedAt;
  final double confidence;
  final String sourceLabel;
  final StatusEvidenceTrace trace;

  const WatchPathFact({
    required this.id,
    required this.title,
    required this.body,
    required this.valueLabel,
    required this.level,
    this.observedAt,
    required this.confidence,
    required this.sourceLabel,
    required this.trace,
  });
}
