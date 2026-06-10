import '../../domain/channel/alert_channel.dart';
import '../../domain/event/alert_event.dart';
import '../../domain/event/alert_level.dart';
import '../../domain/repository/alert_strategy_config_repository.dart';

class AlertPolicyEngine {
  const AlertPolicyEngine();

  List<AlertChannel> resolveChannels(
    AlertEvent event,
    AlertStrategyConfigSet config,
  ) {
    if (!config.global.enabled) return const [];
    if (config.global.criticalOnly && event.level != AlertLevel.critical) {
      return const [];
    }

    final requested = _requestedChannels(event);
    if (requested != null) {
      return requested
          .where((channel) => _channelEnabled(channel, config))
          .toList(growable: false);
    }

    final channels = <AlertChannel>[];
    if (config.inApp.enabled) channels.add(AlertChannel.inApp);
    if (config.localNotification.enabled) {
      channels.add(AlertChannel.localNotification);
    }
    if (event.level == AlertLevel.critical) {
      if (config.sound.enabled) channels.add(AlertChannel.sound);
      if (config.vibration.enabled) channels.add(AlertChannel.vibration);
    } else if (config.vibration.enabled) {
      channels.add(AlertChannel.vibration);
    }
    return channels;
  }

  List<AlertChannel>? _requestedChannels(AlertEvent event) {
    final raw = event.payload['requestedChannels'];
    if (raw is! List) return null;
    final channels = raw
        .map((value) => AlertChannel.fromCode('$value'))
        .toSet()
        .toList(growable: false);
    if (channels.isEmpty) return const [];
    return channels;
  }

  bool _channelEnabled(AlertChannel channel, AlertStrategyConfigSet config) {
    return switch (channel) {
      AlertChannel.inApp => config.inApp.enabled,
      AlertChannel.localNotification => config.localNotification.enabled,
      AlertChannel.sound => config.sound.enabled,
      AlertChannel.vibration => config.vibration.enabled,
    };
  }
}
