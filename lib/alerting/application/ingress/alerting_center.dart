import '../../domain/channel/alert_delivery_plan.dart';
import '../../domain/channel/alert_delivery_result.dart';
import '../../domain/channel/alert_delivery_state.dart';
import '../../domain/channel/alert_channel.dart';
import '../../domain/event/alert_event.dart';
import '../../domain/event/alert_event_state.dart';
import '../../domain/repository/alert_event_repository.dart';
import '../../domain/repository/alert_strategy_config_repository.dart';
import '../../shared/alert_id_generator.dart';
import '../delivery/alert_delivery_gate.dart';
import '../delivery/alert_delivery_pipeline.dart';
import '../policy/alert_policy_engine.dart';

class AlertingCenter {
  final AlertEventRepository eventRepository;
  final AlertStrategyConfigRepository configRepository;
  final AlertPolicyEngine policyEngine;
  final AlertDeliveryPipeline deliveryPipeline;
  final AlertDeliveryGate? deliveryGate;
  final AlertIdGenerator idGenerator;

  const AlertingCenter({
    required this.eventRepository,
    required this.configRepository,
    required this.policyEngine,
    required this.deliveryPipeline,
    this.deliveryGate,
    this.idGenerator = const AlertIdGenerator(),
  });

  Future<List<AlertDeliveryResult>> ingest(AlertEvent event) async {
    await eventRepository.upsert(event);
    final suppression = await deliveryGate?.evaluate(event);
    if (suppression != null && suppression.suppressed) {
      await eventRepository.updateState(event.id, AlertEventState.suppressed);
      return [
        AlertDeliveryResult.skipped(
          channel: AlertChannel.inApp,
          message: 'Alert suppressed: ${suppression.reason ?? 'suppressed'}',
        ),
      ];
    }
    final config = await configRepository.load();
    final channels = policyEngine.resolveChannels(event, config);
    if (channels.isEmpty) return const [];
    final now = DateTime.now();
    final plan = AlertDeliveryPlan(
      id: idGenerator.newId('plan'),
      event: event,
      channels: channels,
      state: AlertDeliveryState.planned,
      createdAt: now,
      updatedAt: now,
    );
    final results = await deliveryPipeline.deliver(plan, config);
    await eventRepository.updateState(event.id, AlertEventState.shown);
    return results;
  }
}
