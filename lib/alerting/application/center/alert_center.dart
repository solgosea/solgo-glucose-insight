import '../../domain/queue/alert_queue_message.dart';
import '../../domain/queue/alert_queue_processing_result.dart';
import 'alert_message_handler_registry.dart';

class AlertCenter {
  final AlertMessageHandlerRegistry handlers;

  const AlertCenter({required this.handlers});

  Future<AlertQueueProcessingResult> process(AlertQueueMessage message) async {
    final handler = handlers.resolve(message);
    if (handler == null) {
      return AlertQueueProcessingResult.failed(
        message:
            'No alert message handler registered for ${message.messageType}.',
      );
    }
    return handler.handle(message);
  }
}
