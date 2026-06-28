enum StatusComponentEvidenceState {
  healthy,
  watch,
  issue,
  unknown,
  notObserved,
  notConfigured,
}

extension StatusComponentEvidenceStateX on StatusComponentEvidenceState {
  bool get available => switch (this) {
        StatusComponentEvidenceState.healthy ||
        StatusComponentEvidenceState.watch ||
        StatusComponentEvidenceState.issue =>
          true,
        _ => false,
      };
}
