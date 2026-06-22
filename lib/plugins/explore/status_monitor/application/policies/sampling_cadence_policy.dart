class SamplingCadencePolicy {
  final Duration expectedCadence;
  final Duration window;

  const SamplingCadencePolicy({
    this.expectedCadence = const Duration(minutes: 5),
    this.window = const Duration(hours: 24),
  });

  int get expectedReadings {
    return (window.inMinutes / expectedCadence.inMinutes).round();
  }

  double completenessRatio(int readingCount) {
    if (expectedReadings <= 0) return 0;
    return (readingCount / expectedReadings).clamp(0.0, 1.0);
  }
}
