import 'package:retry/retry.dart';

import 'glucose_sync_error_classifier.dart';

class GlucoseSyncRetryPolicy {
  final GlucoseSyncErrorClassifier classifier;
  final RetryOptions options;

  const GlucoseSyncRetryPolicy({
    this.classifier = const GlucoseSyncErrorClassifier(),
    this.options = const RetryOptions(
      maxAttempts: 3,
      delayFactor: Duration(milliseconds: 800),
      maxDelay: Duration(seconds: 4),
    ),
  });

  Future<T> run<T>(Future<T> Function() operation) {
    return options.retry(operation, retryIf: classifier.isRetryable);
  }
}
