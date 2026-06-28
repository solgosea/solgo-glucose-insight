import '../../domain/hub/status_hub_enums.dart';
import '../../domain/probe/status_probe_state.dart';

class StatusHubStateMapper {
  const StatusHubStateMapper();

  StatusHubState fromProbeState(StatusProbeState? state) {
    return switch (state) {
      StatusProbeState.healthy => StatusHubState.fresh,
      StatusProbeState.watch => StatusHubState.delayed,
      StatusProbeState.issue => StatusHubState.stale,
      StatusProbeState.notConfigured => StatusHubState.unavailable,
      StatusProbeState.waiting ||
      StatusProbeState.notObserved =>
        StatusHubState.notChecked,
      StatusProbeState.unknown || null => StatusHubState.unknown,
    };
  }
}
