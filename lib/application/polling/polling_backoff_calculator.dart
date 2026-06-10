class PollingBackoffCalculator {
  final Duration baseDelay;

  const PollingBackoffCalculator({
    this.baseDelay = const Duration(seconds: 30),
  });

  Duration delay({
    required int consecutiveFailures,
    required Duration maxDelay,
  }) {
    if (consecutiveFailures <= 0) return Duration.zero;
    final multiplier = 1 << (consecutiveFailures - 1).clamp(0, 6);
    final seconds = baseDelay.inSeconds * multiplier;
    return Duration(seconds: seconds).compareTo(maxDelay) > 0
        ? maxDelay
        : Duration(seconds: seconds);
  }
}
