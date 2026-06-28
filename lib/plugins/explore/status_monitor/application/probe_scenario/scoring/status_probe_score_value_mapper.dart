import '../../../domain/probe/status_probe_state.dart';

class StatusProbeScoreValueMapper {
  const StatusProbeScoreValueMapper();

  double map(StatusProbeState state, double confidence) {
    final base = switch (state) {
      StatusProbeState.healthy => 1.0,
      StatusProbeState.watch => 0.62,
      StatusProbeState.waiting => 0.38,
      StatusProbeState.notObserved => 0.28,
      StatusProbeState.notConfigured => 0.18,
      StatusProbeState.unknown => 0.18,
      StatusProbeState.issue => 0.0,
    };
    return base * confidence.clamp(0.25, 1);
  }
}
