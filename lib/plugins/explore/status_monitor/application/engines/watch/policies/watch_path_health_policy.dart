import '../../../../domain/component_evidence/status_component_evidence_state.dart';
import '../../../../domain/status_level.dart';
import '../facts/watch_evidence_bundle.dart';

class WatchPathHealthPolicy {
  const WatchPathHealthPolicy();

  StatusLevel level(WatchEvidenceBundle bundle) {
    if (bundle.evidenceFacts.isEmpty) return StatusLevel.unknown;
    return _level(bundle.snapshot?.state);
  }

  StatusLevel _level(StatusComponentEvidenceState? state) {
    return switch (state) {
      StatusComponentEvidenceState.healthy => StatusLevel.healthy,
      StatusComponentEvidenceState.watch => StatusLevel.watch,
      StatusComponentEvidenceState.issue => StatusLevel.issue,
      StatusComponentEvidenceState.notObserved ||
      StatusComponentEvidenceState.notConfigured =>
        StatusLevel.unknown,
      StatusComponentEvidenceState.unknown || null => StatusLevel.unknown,
    };
  }
}
