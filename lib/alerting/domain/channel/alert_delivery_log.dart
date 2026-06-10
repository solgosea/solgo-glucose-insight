import 'alert_channel.dart';
import 'alert_delivery_state.dart';

class AlertDeliveryLog {
  final String id;
  final String alertEventId;
  final String? planId;
  final AlertChannel channel;
  final String strategyKey;
  final AlertDeliveryState status;
  final String? message;
  final Map<String, Object?> result;
  final DateTime attemptedAt;
  final DateTime? completedAt;

  const AlertDeliveryLog({
    required this.id,
    required this.alertEventId,
    required this.planId,
    required this.channel,
    required this.strategyKey,
    required this.status,
    required this.result,
    required this.attemptedAt,
    this.message,
    this.completedAt,
  });
}
