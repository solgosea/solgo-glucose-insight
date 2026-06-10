import 'dart:async';

import '../../domain/queue/alert_queue_message.dart';
import '../../domain/queue/alert_queue_processing_result.dart';
import '../../domain/repository/alert_queue_repository.dart';
import '../center/alert_message_handler_registry.dart';
import 'alert_queue_retry_policy.dart';

class AlertQueueConsumer {
  final AlertQueueRepository repository;
  final AlertMessageHandlerRegistry registry;
  final AlertQueueRetryPolicy retryPolicy;
  final int batchSize;
  final DateTime Function() clock;

  bool _draining = false;
  Future<void>? _currentDrain;

  AlertQueueConsumer({
    required this.repository,
    required this.registry,
    this.retryPolicy = const AlertQueueRetryPolicy(),
    this.batchSize = 24,
    DateTime Function()? clock,
  }) : clock = clock ?? DateTime.now;

  Future<void> drain() async {
    if (_draining) return;
    _draining = true;
    try {
      while (true) {
        final batch = await repository.lockNextBatch(
          limit: batchSize,
          now: clock(),
        );
        if (batch.isEmpty) return;
        for (final message in batch) {
          await _processOne(message);
        }
      }
    } finally {
      _draining = false;
    }
  }

  void scheduleDrain() {
    _currentDrain = drain();
    unawaited(_currentDrain);
  }

  Future<void> waitForIdle() async {
    await _currentDrain;
  }

  Future<void> _processOne(AlertQueueMessage message) async {
    final handler = registry.resolve(message);
    if (handler == null) {
      await repository.markFailed(
        id: message.id,
        reason: 'No alert message handler for ${message.messageType}.',
        failedAt: clock(),
      );
      return;
    }
    AlertQueueProcessingResult result;
    try {
      result = await handler.handle(message);
    } catch (error) {
      result = AlertQueueProcessingResult.retry(message: error.toString());
    }
    final now = clock();
    if (result.processed) {
      await repository.markProcessed(message.id, now);
      return;
    }
    if (!result.retryable) {
      await repository.markFailed(
        id: message.id,
        reason: result.message,
        failedAt: now,
      );
      return;
    }
    final nextAttempt = message.attemptCount + 1;
    if (!retryPolicy.shouldRetry(nextAttempt)) {
      await repository.markFailed(
        id: message.id,
        reason: result.message,
        failedAt: now,
      );
      return;
    }
    await repository.releaseForRetry(
      id: message.id,
      reason: result.message,
      attemptCount: nextAttempt,
      availableAt: now.add(retryPolicy.delayFor(nextAttempt)),
      updatedAt: now,
    );
  }
}
