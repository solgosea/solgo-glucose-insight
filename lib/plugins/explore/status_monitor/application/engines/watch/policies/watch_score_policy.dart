import '../../../../domain/scoring/status_component_score.dart';
import '../../../../domain/status_level.dart';
import '../facts/watch_evidence_bundle.dart';

class WatchScorePolicy {
  const WatchScorePolicy();

  StatusComponentScore score({
    required WatchEvidenceBundle bundle,
    required StatusLevel level,
  }) {
    final total = bundle.expectedCount;
    final available = bundle.availableCount;
    return StatusComponentScore(
      value: total == 0 ? 0 : ((available / total) * 100).round(),
      label: available == total ? 'Ready' : 'Limited',
      confidence: bundle.snapshot?.confidence ?? 0,
      availableSignals: available,
      totalSignals: total,
    );
  }
}
