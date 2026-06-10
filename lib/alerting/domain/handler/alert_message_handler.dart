import '../queue/alert_queue_message.dart';
import '../queue/alert_queue_processing_result.dart';

abstract interface class AlertMessageHandler {
  String get id;

  bool supports(AlertQueueMessage message);

  Future<AlertQueueProcessingResult> handle(AlertQueueMessage message);
}
