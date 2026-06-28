enum StatusObservationState {
  yes,
  watch,
  no,
  notObserved,
  notConfigured,
  waiting,
  unknown;

  bool get usefulEvidence => switch (this) {
        StatusObservationState.yes || StatusObservationState.watch => true,
        _ => false,
      };
}
