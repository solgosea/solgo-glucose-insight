enum StatusHistoryBucketReason {
  recordedSample,
  carriedForward,
  noSample,
  future;

  String get label {
    return switch (this) {
      StatusHistoryBucketReason.recordedSample => 'Recorded sample',
      StatusHistoryBucketReason.carriedForward => 'Carried forward',
      StatusHistoryBucketReason.noSample => 'No sample',
      StatusHistoryBucketReason.future => 'Future hour',
    };
  }
}
