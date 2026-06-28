import '../../../domain/probe/status_probe_state.dart';

class StatusProbeFreshnessPolicy {
  final Duration freshAfter;
  final Duration staleAfter;

  const StatusProbeFreshnessPolicy({
    this.freshAfter = const Duration(minutes: 6),
    this.staleAfter = const Duration(minutes: 15),
  });

  StatusProbeState state(DateTime? observedAt, DateTime now) {
    if (observedAt == null) return StatusProbeState.notObserved;
    final age = now.difference(observedAt);
    if (age <= freshAfter) return StatusProbeState.healthy;
    if (age <= staleAfter) return StatusProbeState.watch;
    return StatusProbeState.issue;
  }

  double confidence(DateTime? observedAt, DateTime now) {
    if (observedAt == null) return 0;
    final age = now.difference(observedAt);
    if (age <= freshAfter) return 1;
    if (age <= staleAfter) return 0.6;
    return 0.25;
  }
}
