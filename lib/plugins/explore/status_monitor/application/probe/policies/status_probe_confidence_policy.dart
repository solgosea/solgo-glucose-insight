import '../../../domain/probe/status_probe_state.dart';

class StatusProbeConfidencePolicy {
  const StatusProbeConfidencePolicy();

  double forState(StatusProbeState state) {
    return switch (state) {
      StatusProbeState.healthy => 1,
      StatusProbeState.watch => 0.65,
      StatusProbeState.issue => 0.25,
      StatusProbeState.waiting => 0.2,
      StatusProbeState.notObserved => 0,
      StatusProbeState.notConfigured => 0,
      StatusProbeState.unknown => 0,
    };
  }
}
