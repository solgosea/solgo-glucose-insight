import '../../domain/channel/alert_delivery_plan.dart';
import '../../domain/channel/alert_delivery_result.dart';
import '../../domain/config/in_app_alert_config.dart';
import '../../domain/config/local_notification_alert_config.dart';
import '../../domain/config/sound_alert_config.dart';
import '../../domain/config/vibration_alert_config.dart';
import '../../domain/repository/alert_delivery_log_repository.dart';
import '../../domain/repository/alert_strategy_config_repository.dart';
import '../../strategies/alert_strategy.dart';
import 'alert_strategy_registry.dart';

class AlertDeliveryPipeline {
  final AlertStrategyRegistry registry;
  final AlertDeliveryLogRepository logRepository;

  const AlertDeliveryPipeline({
    required this.registry,
    required this.logRepository,
  });

  Future<List<AlertDeliveryResult>> deliver(
    AlertDeliveryPlan plan,
    AlertStrategyConfigSet config,
  ) async {
    await logRepository.insertPlan(plan);
    final results = <AlertDeliveryResult>[];
    for (final channel in plan.channels) {
      final strategy = registry.byChannel(channel);
      if (strategy == null) {
        await logRepository.insertSkipped(
          alertEventId: plan.event.id,
          planId: plan.id,
          strategyKey: channel.code,
          channel: channel,
          message: 'No alert strategy registered.',
        );
        continue;
      }
      final result = await _deliverWithConfig(strategy, plan, config);
      results.add(result);
      await logRepository.insertResult(
        alertEventId: plan.event.id,
        planId: plan.id,
        strategyKey: strategy.strategyKey,
        result: result,
      );
    }
    return results;
  }

  Future<AlertDeliveryResult> _deliverWithConfig(
    AlertStrategy strategy,
    AlertDeliveryPlan plan,
    AlertStrategyConfigSet config,
  ) async {
    if (!strategy.supports(plan.event)) {
      return AlertDeliveryResult.skipped(
        channel: strategy.channel,
        message: 'Strategy does not support this event.',
      );
    }
    switch (strategy.strategyKey) {
      case InAppAlertConfig.key:
        return (strategy as AlertStrategy<InAppAlertConfig>).deliver(
          plan.event,
          config.inApp,
        );
      case LocalNotificationAlertConfig.key:
        return (strategy as AlertStrategy<LocalNotificationAlertConfig>)
            .deliver(plan.event, config.localNotification);
      case SoundAlertConfig.key:
        return (strategy as AlertStrategy<SoundAlertConfig>).deliver(
          plan.event,
          config.sound,
        );
      case VibrationAlertConfig.key:
        return (strategy as AlertStrategy<VibrationAlertConfig>).deliver(
          plan.event,
          config.vibration,
        );
      default:
        return AlertDeliveryResult.skipped(
          channel: strategy.channel,
          message: 'Unknown strategy config.',
        );
    }
  }
}
