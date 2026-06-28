import '../../../domain/probe/status_probe_result.dart';
import '../../../domain/probe/status_probe_state.dart';

class StatusProbeHistoryWritePolicy {
  const StatusProbeHistoryWritePolicy();

  bool shouldWrite(StatusProbeResult result) {
    if (result.definition.requiredForCorePath) return true;
    return switch (result.state) {
      StatusProbeState.healthy ||
      StatusProbeState.watch ||
      StatusProbeState.issue ||
      StatusProbeState.notConfigured ||
      StatusProbeState.unknown =>
        true,
      StatusProbeState.notObserved || StatusProbeState.waiting => false,
    };
  }
}
