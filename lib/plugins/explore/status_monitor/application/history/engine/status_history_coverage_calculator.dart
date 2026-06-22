import '../../../domain/history/status_history_bucket.dart';
import '../../../domain/history/status_history_bucket_reason.dart';

class StatusHistoryCoverageCalculator {
  const StatusHistoryCoverageCalculator();

  double calculate(List<List<StatusHistoryBucket>> hourlyBuckets) {
    final buckets = hourlyBuckets.expand((row) => row).where(
          (bucket) => bucket.reason != StatusHistoryBucketReason.future,
        );
    final total = buckets.length;
    if (total == 0) return 0;
    final recorded = buckets.where(
      (bucket) => bucket.reason == StatusHistoryBucketReason.recordedSample,
    );
    return recorded.length / total;
  }
}
