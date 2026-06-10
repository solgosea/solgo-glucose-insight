class AlertQueueRetryPolicy {
  final int maxAttempts;
  final Duration baseDelay;
  final Duration maxDelay;

  const AlertQueueRetryPolicy({
    this.maxAttempts = 4,
    this.baseDelay = const Duration(seconds: 2),
    this.maxDelay = const Duration(minutes: 2),
  });

  bool shouldRetry(int nextAttemptCount) => nextAttemptCount < maxAttempts;

  Duration delayFor(int nextAttemptCount) {
    final multiplier = 1 << (nextAttemptCount - 1).clamp(0, 10);
    final delay = baseDelay * multiplier;
    return delay > maxDelay ? maxDelay : delay;
  }
}
