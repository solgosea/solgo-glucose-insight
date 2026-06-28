import '../../domain/component_evidence/status_component_evidence_state.dart';
import '../../domain/status_level.dart';

class StatusComponentStateMapper {
  const StatusComponentStateMapper();

  StatusLevel levelForEvidence(StatusComponentEvidenceState state) {
    return switch (state) {
      StatusComponentEvidenceState.healthy => StatusLevel.healthy,
      StatusComponentEvidenceState.watch => StatusLevel.watch,
      StatusComponentEvidenceState.issue => StatusLevel.issue,
      StatusComponentEvidenceState.notObserved ||
      StatusComponentEvidenceState.notConfigured ||
      StatusComponentEvidenceState.unknown =>
        StatusLevel.unknown,
    };
  }
}
