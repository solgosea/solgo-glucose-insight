import '../../../domain/hub/status_hub_models.dart';

class StatusHubConfidencePolicy {
  const StatusHubConfidencePolicy();

  double nodeConfidence({
    required int availableEvidence,
    required int expectedEvidence,
  }) {
    if (expectedEvidence <= 0) return 0;
    return (availableEvidence / expectedEvidence).clamp(0, 1);
  }

  StatusHubEvidenceQuality quality({
    required int availableEvidence,
    required int expectedEvidence,
  }) {
    final confidence = nodeConfidence(
      availableEvidence: availableEvidence,
      expectedEvidence: expectedEvidence,
    );
    final label = switch (confidence) {
      >= .78 => 'Strong evidence',
      >= .45 => 'Partial evidence',
      _ => 'Limited evidence',
    };
    return StatusHubEvidenceQuality(
      availableEvidenceCount: availableEvidence,
      expectedEvidenceCount: expectedEvidence,
      confidence: confidence,
      label: label,
    );
  }
}
