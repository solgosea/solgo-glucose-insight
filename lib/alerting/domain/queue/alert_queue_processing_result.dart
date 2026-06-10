class AlertQueueProcessingResult {
  final bool processed;
  final bool retryable;
  final String message;

  const AlertQueueProcessingResult({
    required this.processed,
    this.retryable = false,
    required this.message,
  });

  const AlertQueueProcessingResult.processed({this.message = 'Processed.'})
    : processed = true,
      retryable = false;

  const AlertQueueProcessingResult.ignored({this.message = 'Ignored.'})
    : processed = true,
      retryable = false;

  const AlertQueueProcessingResult.retry({required this.message})
    : processed = false,
      retryable = true;

  const AlertQueueProcessingResult.failed({required this.message})
    : processed = false,
      retryable = false;
}
