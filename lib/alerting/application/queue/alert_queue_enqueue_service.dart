import '../../domain/queue/alert_queue_message.dart';
import '../../domain/repository/alert_queue_repository.dart';
import '../dedupe/alert_dedupe_policy.dart';
import '../dedupe/alert_dedupe_resolution.dart';
import 'alert_queue_consumer.dart';

class AlertQueueEnqueueService {
  final AlertQueueRepository repository;
  final AlertQueueConsumer consumer;
  final AlertDedupePolicy dedupePolicy;

  const AlertQueueEnqueueService({
    required this.repository,
    required this.consumer,
    this.dedupePolicy = const AlertDedupePolicy(),
  });

  Future<AlertDedupeResolution> enqueue(AlertQueueMessage message) async {
    final existing = await repository.findByDedupeKey(message.dedupeKey);
    final resolution = dedupePolicy.resolve(
      incoming: message,
      existing: existing,
    );
    switch (resolution.type) {
      case AlertDedupeResolutionType.enqueue:
        await repository.enqueue(message);
        consumer.scheduleDrain();
      case AlertDedupeResolutionType.replaceExisting:
        await repository.replaceByDedupeKey(message);
        consumer.scheduleDrain();
      case AlertDedupeResolutionType.suppress:
        break;
    }
    return resolution;
  }
}
