enum StatusProbeState {
  healthy,
  watch,
  issue,
  unknown,
  notConfigured,
  waiting,
  notObserved;

  bool get hasUsefulEvidence =>
      this == StatusProbeState.healthy ||
      this == StatusProbeState.watch ||
      this == StatusProbeState.issue;

  bool get isProblem =>
      this == StatusProbeState.watch || this == StatusProbeState.issue;
}
