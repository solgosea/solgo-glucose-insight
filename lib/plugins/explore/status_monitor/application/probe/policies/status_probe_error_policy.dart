import '../../../domain/probe/status_probe_state.dart';

class StatusProbeErrorPolicy {
  const StatusProbeErrorPolicy();

  StatusProbeState stateFor(Object? error) {
    if (error == null) return StatusProbeState.unknown;
    return StatusProbeState.issue;
  }
}
