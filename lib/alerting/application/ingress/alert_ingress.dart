import '../../domain/queue/alert_queue_message.dart';
import '../../domain/queue/alert_queue_priority.dart';
import '../../domain/queue/alert_queue_source.dart';
import '../../domain/repository/alert_queue_repository.dart';
import '../../shared/alert_id_generator.dart';
import '../queue/alert_queue_consumer.dart';
import '../queue/alert_queue_enqueue_service.dart';

class AlertIngress {
  final AlertQueueEnqueueService enqueueService;
  final AlertIdGenerator idGenerator;
  final DateTime Function() clock;

  AlertIngress({
    AlertQueueEnqueueService? enqueueService,
    AlertQueueRepository? repository,
    AlertQueueConsumer? consumer,
    this.idGenerator = const AlertIdGenerator(),
    DateTime Function()? clock,
  }) : assert(
         enqueueService != null || (repository != null && consumer != null),
         'Provide enqueueService or repository + consumer.',
       ),
       enqueueService =
           enqueueService ??
           AlertQueueEnqueueService(
             repository: repository!,
             consumer: consumer!,
           ),
       clock = clock ?? DateTime.now;

  Future<void> enqueue({
    required String messageType,
    String source = AlertQueueSource.system,
    String? targetPluginId,
    String? targetId,
    String? subjectId,
    String? alertEventId,
    String? alertType,
    AlertQueuePriority priority = AlertQueuePriority.normal,
    Map<String, Object?> payload = const {},
    String? dedupeKey,
    String? canonicalSourceKey,
    String? dedupeScope,
    int sourcePriority = 0,
    DateTime? availableAt,
  }) async {
    final now = clock();
    final message = AlertQueueMessage(
      id: idGenerator.newId('queue'),
      dedupeKey:
          dedupeKey ??
          [
            messageType,
            source,
            targetPluginId,
            targetId,
            subjectId,
            alertEventId,
            alertType,
            now.millisecondsSinceEpoch,
          ].whereType<String>().join(':'),
      messageType: messageType,
      source: source,
      targetPluginId: targetPluginId,
      targetId: targetId,
      subjectId: subjectId,
      alertEventId: alertEventId,
      alertType: alertType,
      canonicalSourceKey: canonicalSourceKey,
      dedupeScope: dedupeScope,
      sourcePriority: sourcePriority,
      priority: priority,
      payload: payload,
      availableAt: availableAt ?? now,
      createdAt: now,
      updatedAt: now,
    );
    await enqueueService.enqueue(message);
  }
}
