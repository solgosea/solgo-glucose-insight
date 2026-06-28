import '../../../domain/hub/status_hub_enums.dart';

class StatusHubDelayPolicy {
  final Duration delayedBy;
  final Duration staleBy;

  const StatusHubDelayPolicy({
    this.delayedBy = const Duration(minutes: 10),
    this.staleBy = const Duration(minutes: 25),
  });

  Duration? delayVsSource({
    required Duration? sourceAge,
    required Duration? targetAge,
  }) {
    if (sourceAge == null || targetAge == null) return null;
    return targetAge - sourceAge;
  }

  StatusHubState evaluate({
    required StatusHubState sourceState,
    required StatusHubState targetState,
    required Duration? delayVsSource,
  }) {
    if (sourceState == StatusHubState.unavailable ||
        sourceState == StatusHubState.stale) {
      return StatusHubState.limited;
    }
    if (targetState == StatusHubState.unavailable ||
        targetState == StatusHubState.notChecked) {
      return targetState;
    }
    if (targetState == StatusHubState.unknown) {
      return StatusHubState.limited;
    }
    final delay = delayVsSource;
    if (sourceState == StatusHubState.fresh && delay != null) {
      if (delay >= staleBy) return StatusHubState.stale;
      if (delay >= delayedBy) return StatusHubState.delayed;
    }
    return targetState;
  }
}
