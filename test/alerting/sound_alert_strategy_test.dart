import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/alerting/application/sound/alert_sound_session_manager.dart';
import 'package:smart_xdrip/alerting/domain/channel/alert_channel.dart';
import 'package:smart_xdrip/alerting/domain/config/sound_alert_config.dart';
import 'package:smart_xdrip/alerting/domain/event/alert_category.dart';
import 'package:smart_xdrip/alerting/domain/event/alert_event.dart';
import 'package:smart_xdrip/alerting/domain/event/alert_event_source.dart';
import 'package:smart_xdrip/alerting/domain/event/alert_event_state.dart';
import 'package:smart_xdrip/alerting/domain/event/alert_level.dart';
import 'package:smart_xdrip/alerting/domain/resource/alert_sound_ref.dart';
import 'package:smart_xdrip/alerting/infrastructure/audio/alert_audio_gateway.dart';
import 'package:smart_xdrip/alerting/strategies/sound/sound_alert_strategy.dart';

void main() {
  test('SoundAlertStrategy starts a managed continuous session', () async {
    final gateway = _FakeAudioGateway();
    final manager = AlertSoundSessionManager(audioGateway: gateway);
    final strategy = SoundAlertStrategy(
      sessionManager: manager,
      gateway: gateway,
    );

    final result = await strategy.deliver(
      _event(
        payload: const {
          'personId': 'child-1',
          'type': 'urgentLow',
          'soundPolicy': {
            'mode': 'continuous',
            'intervalSeconds': 1,
            'maxDurationSeconds': 20,
          },
        },
      ),
      const SoundAlertConfig(
        sound: AlertSoundRef.asset(
          uri: 'audio/alerts/urgent_pulse.wav',
          displayName: 'Urgent pulse',
        ),
      ),
    );

    expect(result.channel, AlertChannel.sound);
    expect(result.success, isTrue);
    expect(result.message, 'Sound alert session started.');
    expect(manager.runningKeys, ['child-1:urgentLow']);

    manager.stopAll();
  });
}

AlertEvent _event({Map<String, Object?> payload = const {}}) {
  final now = DateTime(2026, 6, 8, 10);
  return AlertEvent(
    id: 'a1',
    source: const AlertEventSource('local.datasource'),
    sourceEventId: 'f1',
    category: AlertCategory.glucoseUrgentLow,
    level: AlertLevel.critical,
    state: AlertEventState.received,
    title: 'Urgent Low',
    body: 'Urgent low glucose',
    payload: payload,
    occurredAt: now,
    receivedAt: now,
    updatedAt: now,
  );
}

class _FakeAudioGateway extends AlertAudioGateway {
  int playCount = 0;

  @override
  Future<void> play(AlertSoundRef sound) async {
    playCount++;
  }
}
