import '../event/alert_event.dart';
import 'alert_channel.dart';
import 'alert_delivery_state.dart';

class AlertDeliveryPlan {
  final String id;
  final AlertEvent event;
  final List<AlertChannel> channels;
  final AlertDeliveryState state;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AlertDeliveryPlan({
    required this.id,
    required this.event,
    required this.channels,
    required this.state,
    required this.createdAt,
    required this.updatedAt,
  });
}
