import '../../../domain/hub/status_hub_enums.dart';

class StatusHubMetricStarPolicy {
  const StatusHubMetricStarPolicy();

  int starsFor(double score) {
    final clamped = score.clamp(0, 100);
    if (clamped >= 90) return 5;
    if (clamped >= 75) return 4;
    if (clamped >= 55) return 3;
    if (clamped >= 35) return 2;
    if (clamped > 0) return 1;
    return 0;
  }

  StatusHubState stateFor(double score) {
    final clamped = score.clamp(0, 100);
    if (clamped >= 85) return StatusHubState.fresh;
    if (clamped >= 65) return StatusHubState.delayed;
    if (clamped >= 40) return StatusHubState.limited;
    if (clamped > 0) return StatusHubState.stale;
    return StatusHubState.unknown;
  }
}
