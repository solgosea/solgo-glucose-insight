enum StatusObservationSeverity {
  good,
  attention,
  blocked,
  neutral;

  int get rank => switch (this) {
        StatusObservationSeverity.good => 0,
        StatusObservationSeverity.neutral => 1,
        StatusObservationSeverity.attention => 2,
        StatusObservationSeverity.blocked => 3,
      };
}
