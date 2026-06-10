import '../channel/alert_channel.dart';
import '../channel/alert_delivery_plan.dart';
import '../channel/alert_delivery_result.dart';

abstract class AlertDeliveryLogRepository {
  Future<void> insertPlan(AlertDeliveryPlan plan);
  Future<void> insertResult({
    required String alertEventId,
    required String? planId,
    required String strategyKey,
    required AlertDeliveryResult result,
  });
  Future<List<Map<String, Object?>>> latestForEvent(String alertEventId);
  Future<void> insertSkipped({
    required String alertEventId,
    required String? planId,
    required String strategyKey,
    required AlertChannel channel,
    required String message,
  });
}
