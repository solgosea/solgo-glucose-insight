import '../../../../domain/component_evidence/status_component_evidence_fact.dart';
import '../../../../domain/status_level.dart';
import '../../../../domain/trace/status_evidence_trace.dart';

class WatchSignalFact {
  final String id;
  final String label;
  final String valueLabel;
  final StatusLevel level;
  final DateTime? observedAt;
  final double confidence;
  final String sourceLabel;
  final StatusEvidenceTrace trace;

  const WatchSignalFact({
    required this.id,
    required this.label,
    required this.valueLabel,
    required this.level,
    this.observedAt,
    required this.confidence,
    required this.sourceLabel,
    required this.trace,
  });

  factory WatchSignalFact.fromEvidence({
    required StatusComponentEvidenceFact fact,
    required StatusLevel level,
    required String valueLabel,
    required String sourceLabel,
  }) {
    return WatchSignalFact(
      id: fact.id,
      label: fact.label,
      valueLabel: valueLabel,
      level: level,
      observedAt: fact.observedAt,
      confidence: fact.confidence,
      sourceLabel: sourceLabel,
      trace: fact.trace,
    );
  }
}
