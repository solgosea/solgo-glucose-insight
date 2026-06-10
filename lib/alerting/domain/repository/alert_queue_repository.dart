import '../queue/alert_queue_message.dart';

abstract interface class AlertQueueRepository {
  Future<void> enqueue(AlertQueueMessage message);

  Future<AlertQueueMessage?> findByDedupeKey(String dedupeKey);

  Future<void> replaceByDedupeKey(AlertQueueMessage message);

  Future<List<AlertQueueMessage>> lockNextBatch({
    required int limit,
    required DateTime now,
  });

  Future<void> markProcessed(String id, DateTime processedAt);

  Future<void> markFailed({
    required String id,
    required String reason,
    required DateTime failedAt,
  });

  Future<void> releaseForRetry({
    required String id,
    required String reason,
    required int attemptCount,
    required DateTime availableAt,
    required DateTime updatedAt,
  });

  Future<int> pendingCount();
}
