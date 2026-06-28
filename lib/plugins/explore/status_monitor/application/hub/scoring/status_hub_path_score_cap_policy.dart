import '../../../domain/hub/path/status_hub_path_score_cap.dart';
import '../../../domain/hub/path/status_hub_path_score_reason.dart';
import '../../../domain/hub/status_hub_enums.dart';
import '../../../domain/hub/status_hub_models.dart';

class StatusHubPathScoreCapPolicy {
  const StatusHubPathScoreCapPolicy();

  StatusHubPathScoreCap capFor({
    required StatusHubConnection connection,
    required StatusHubPathDiagnosisReason diagnosis,
  }) {
    if (diagnosis == StatusHubPathDiagnosisReason.compatiblePathMissing) {
      return const StatusHubPathScoreCap(
        maxScore: 64,
        reason: StatusHubPathScoreReason.compatiblePathMissing,
        label: 'Handoff not confirmed',
        explanation:
            'Juggluco evidence is visible, but the xDrip-compatible handoff is not confirmed.',
      );
    }
    if (diagnosis == StatusHubPathDiagnosisReason.bgSourceMissing) {
      return const StatusHubPathScoreCap(
        maxScore: 55,
        reason: StatusHubPathScoreReason.bgSourceMissing,
        label: 'BG source not confirmed',
        explanation:
            'AAPS evidence does not confirm xDrip+ as the BG source path.',
      );
    }
    if (diagnosis == StatusHubPathDiagnosisReason.uploadDelayed) {
      return const StatusHubPathScoreCap(
        maxScore: 74,
        reason: StatusHubPathScoreReason.uploadDelayed,
        label: 'Cloud delayed',
        explanation:
            'Nightscout is behind local xDrip+ evidence, so the cloud path is capped.',
      );
    }
    if (diagnosis == StatusHubPathDiagnosisReason.cloudUnavailable) {
      return const StatusHubPathScoreCap(
        maxScore: 39,
        reason: StatusHubPathScoreReason.cloudUnavailable,
        label: 'Cloud unavailable',
        explanation: 'Nightscout cloud evidence is unavailable.',
      );
    }
    if (diagnosis == StatusHubPathDiagnosisReason.insufficientEvidence) {
      return const StatusHubPathScoreCap(
        maxScore: 45,
        reason: StatusHubPathScoreReason.insufficientEvidence,
        label: 'Insufficient evidence',
        explanation:
            'The path does not have enough observable evidence for a strong score.',
      );
    }

    return switch (connection.state) {
      StatusHubState.fresh => const StatusHubPathScoreCap(
          maxScore: 100,
          reason: StatusHubPathScoreReason.healthy,
          label: 'Healthy path',
          explanation: 'No score cap is applied to this fresh path.',
        ),
      StatusHubState.delayed => const StatusHubPathScoreCap(
          maxScore: 84,
          reason: StatusHubPathScoreReason.delayed,
          label: 'Delayed path',
          explanation:
              'The path has a delay signal and cannot score as fully healthy.',
        ),
      StatusHubState.limited => const StatusHubPathScoreCap(
          maxScore: 64,
          reason: StatusHubPathScoreReason.limited,
          label: 'Limited evidence',
          explanation: 'The path is only partially observable.',
        ),
      StatusHubState.stale => const StatusHubPathScoreCap(
          maxScore: 39,
          reason: StatusHubPathScoreReason.stale,
          label: 'Stale path',
          explanation: 'The target side is stale.',
        ),
      StatusHubState.unavailable => const StatusHubPathScoreCap(
          maxScore: 20,
          reason: StatusHubPathScoreReason.unavailable,
          label: 'Unavailable path',
          explanation: 'One side of the path is unavailable.',
        ),
      StatusHubState.notChecked ||
      StatusHubState.unknown =>
        const StatusHubPathScoreCap(
          maxScore: 45,
          reason: StatusHubPathScoreReason.insufficientEvidence,
          label: 'Not checked',
          explanation: 'The path has not been checked enough to score higher.',
        ),
    };
  }
}
