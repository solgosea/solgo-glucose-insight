import '../../domain/handler/alert_message_handler.dart';
import '../../domain/queue/alert_queue_message.dart';
import '../../domain/queue/alert_queue_processing_result.dart';
import '../ingress/alerting_center.dart';
import 'alert_event_payload_codec.dart';
import 'alert_event_queue_message_types.dart';

class AlertEventQueueMessageHandler implements AlertMessageHandler {
  final AlertingCenter center;
  final AlertEventPayloadCodec codec;

  const AlertEventQueueMessageHandler({
    required this.center,
    this.codec = const AlertEventPayloadCodec(),
  });

  @override
  String get id => 'alerting.direct_event';

  @override
  bool supports(AlertQueueMessage message) {
    return message.messageType == AlertEventQueueMessageTypes.directEvent;
  }

  @override
  Future<AlertQueueProcessingResult> handle(AlertQueueMessage message) async {
    final event = codec.decode(message.payload);
    await center.ingest(event);
    return const AlertQueueProcessingResult.processed();
  }
}
