import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/alerting/application/policy/alert_policy_engine.dart';
import 'package:smart_xdrip/alerting/domain/channel/alert_channel.dart';
import 'package:smart_xdrip/alerting/domain/config/sound_alert_config.dart';
import 'package:smart_xdrip/alerting/domain/event/alert_category.dart';
import 'package:smart_xdrip/alerting/domain/event/alert_event.dart';
import 'package:smart_xdrip/alerting/domain/event/alert_event_source.dart';
import 'package:smart_xdrip/alerting/domain/event/alert_event_state.dart';
import 'package:smart_xdrip/alerting/domain/event/alert_level.dart';
import 'package:smart_xdrip/alerting/domain/repository/alert_strategy_config_repository.dart';

void main() {
  group('AlertPolicyEngine', () {
    test('critical events fan out to all enabled first-version strategies', () {
      final event = _event(AlertLevel.critical);

      final channels = const AlertPolicyEngine().resolveChannels(
        event,
        const AlertStrategyConfigSet(),
      );

      expect(channels, [
        AlertChannel.inApp,
        AlertChannel.localNotification,
        AlertChannel.sound,
        AlertChannel.vibration,
      ]);
    });

    test(
      'warning events skip sound but keep visible and vibration strategies',
      () {
        final event = _event(AlertLevel.warning);

        final channels = const AlertPolicyEngine().resolveChannels(
          event,
          const AlertStrategyConfigSet(),
        );

        expect(channels, [
          AlertChannel.inApp,
          AlertChannel.localNotification,
          AlertChannel.vibration,
        ]);
      },
    );

    test('explicit requested channels override level defaults', () {
      final event = _event(
        AlertLevel.warning,
        requestedChannels: const ['in_app', 'sound'],
      );

      final channels = const AlertPolicyEngine().resolveChannels(
        event,
        const AlertStrategyConfigSet(),
      );

      expect(channels, [AlertChannel.inApp, AlertChannel.sound]);
    });

    test(
      'explicit requested channels are filtered by global strategy config',
      () {
        final event = _event(
          AlertLevel.warning,
          requestedChannels: const ['in_app', 'sound'],
        );

        final channels = const AlertPolicyEngine().resolveChannels(
          event,
          const AlertStrategyConfigSet(sound: SoundAlertConfig(enabled: false)),
        );

        expect(channels, [AlertChannel.inApp]);
      },
    );
  });
}

AlertEvent _event(
  AlertLevel level, {
  List<String> requestedChannels = const [],
}) {
  final now = DateTime(2026, 6, 5, 9);
  return AlertEvent(
    id: 'event-1',
    source: const AlertEventSource('remote.source'),
    sourceEventId: 'remote-1',
    category: AlertCategory.glucoseUrgentLow,
    level: level,
    state: AlertEventState.received,
    title: 'Urgent low',
    body: 'Glucose is low.',
    payload: {
      if (requestedChannels.isNotEmpty) 'requestedChannels': requestedChannels,
    },
    occurredAt: now,
    receivedAt: now,
    updatedAt: now,
  );
}
