import '../../domain/handler/alert_message_handler.dart';
import '../../domain/queue/alert_queue_message.dart';

class AlertMessageHandlerRegistry {
  final List<AlertMessageHandler> _handlers = [];

  List<AlertMessageHandler> get handlers => List.unmodifiable(_handlers);

  void register(AlertMessageHandler handler) {
    final index = _handlers.indexWhere((item) => item.id == handler.id);
    if (index >= 0) {
      _handlers[index] = handler;
      return;
    }
    _handlers.add(handler);
  }

  AlertMessageHandler? resolve(AlertQueueMessage message) {
    for (final handler in _handlers) {
      if (handler.supports(message)) return handler;
    }
    return null;
  }
}
