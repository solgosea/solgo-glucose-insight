import 'alert_channel.dart';

class AlertDeliveryResult {
  final AlertChannel channel;
  final bool success;
  final bool skipped;
  final String message;
  final Map<String, Object?> result;

  const AlertDeliveryResult({
    required this.channel,
    required this.success,
    required this.skipped,
    required this.message,
    this.result = const {},
  });

  const AlertDeliveryResult.delivered({
    required this.channel,
    this.message = 'Delivered.',
    this.result = const {},
  }) : success = true,
       skipped = false;

  const AlertDeliveryResult.skipped({
    required this.channel,
    this.message = 'Skipped.',
    this.result = const {},
  }) : success = false,
       skipped = true;

  const AlertDeliveryResult.failed({
    required this.channel,
    required this.message,
    this.result = const {},
  }) : success = false,
       skipped = false;
}
