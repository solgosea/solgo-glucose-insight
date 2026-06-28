import '../../../domain/hub/status_hub_enums.dart';
import '../../../domain/status_level.dart';

class StatusHubFreshnessPolicy {
  const StatusHubFreshnessPolicy();

  StatusHubState fromStatusLevel(StatusLevel level) {
    return switch (level) {
      StatusLevel.healthy => StatusHubState.fresh,
      StatusLevel.watch => StatusHubState.delayed,
      StatusLevel.issue => StatusHubState.stale,
      StatusLevel.unknown => StatusHubState.unknown,
    };
  }

  StatusHubState fromAge(
    Duration? age, {
    Duration freshBy = const Duration(minutes: 6),
    Duration staleAfter = const Duration(minutes: 20),
  }) {
    if (age == null) return StatusHubState.unknown;
    if (age <= freshBy) return StatusHubState.fresh;
    if (age <= staleAfter) return StatusHubState.delayed;
    return StatusHubState.stale;
  }
}
