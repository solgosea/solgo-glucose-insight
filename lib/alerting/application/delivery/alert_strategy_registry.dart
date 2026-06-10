import '../../domain/channel/alert_channel.dart';
import '../../strategies/alert_strategy.dart';

class AlertStrategyRegistry {
  final Map<AlertChannel, AlertStrategy> _strategies;

  AlertStrategyRegistry(List<AlertStrategy> strategies)
    : _strategies = {
        for (final strategy in strategies) strategy.channel: strategy,
      };

  AlertStrategy? byChannel(AlertChannel channel) => _strategies[channel];
}
