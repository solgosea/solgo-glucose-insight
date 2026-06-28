import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/alerting/application/sound/alert_sound_session_manager.dart';
import 'package:smart_xdrip/alerting/domain/config/alert_strategy_config.dart';
import 'package:smart_xdrip/alerting/domain/config/alerting_global_config.dart';
import 'package:smart_xdrip/alerting/domain/config/sound_alert_config.dart';
import 'package:smart_xdrip/alerting/domain/config/vibration_alert_config.dart';
import 'package:smart_xdrip/alerting/domain/config/in_app_alert_config.dart';
import 'package:smart_xdrip/alerting/domain/config/local_notification_alert_config.dart';
import 'package:smart_xdrip/alerting/domain/event/alert_category.dart';
import 'package:smart_xdrip/alerting/domain/event/alert_event.dart';
import 'package:smart_xdrip/alerting/domain/event/alert_event_source.dart';
import 'package:smart_xdrip/alerting/domain/event/alert_event_state.dart';
import 'package:smart_xdrip/alerting/domain/event/alert_level.dart';
import 'package:smart_xdrip/alerting/domain/repository/alert_strategy_config_repository.dart';
import 'package:smart_xdrip/alerting/domain/resource/alert_sound_ref.dart';
import 'package:smart_xdrip/alerting/domain/sound/alert_sound_loop_mode.dart';
import 'package:smart_xdrip/alerting/domain/sound/alert_sound_playback_policy.dart';
import 'package:smart_xdrip/alerting/infrastructure/audio/alert_audio_gateway.dart';
import 'package:smart_xdrip/alerting/presentation/controllers/alert_settings_controller.dart';

void main() {
  test('turning off sound alert stops active sound sessions', () async {
    final gateway = _FakeAudioGateway();
    final manager = AlertSoundSessionManager(audioGateway: gateway);
    final controller = AlertSettingsController(
      repository: _MemoryAlertStrategyConfigRepository(),
      soundSessionManager: manager,
    );
    final event = _event();

    manager.start(
      event: event,
      sound: const AlertSoundRef.asset(
        uri: 'audio/alerts/urgent_pulse.wav',
        displayName: 'Urgent pulse',
      ),
      policy: const AlertSoundPlaybackPolicy(
        mode: AlertSoundLoopMode.continuous,
        intervalSeconds: 1,
        maxDurationSeconds: 300,
      ),
    );
    expect(manager.runningKeys, ['child-1:urgentLow']);

    await controller.toggleSound(false);
    await Future<void>.delayed(const Duration(milliseconds: 10));

    expect(manager.runningKeys, isEmpty);
    expect(gateway.stopCount, greaterThanOrEqualTo(1));
  });
}

AlertEvent _event() {
  final now = DateTime(2026, 6, 8, 10);
  return AlertEvent(
    id: 'a1',
    source: const AlertEventSource('remote.local'),
    sourceEventId: 'f1',
    category: AlertCategory.glucoseUrgentLow,
    level: AlertLevel.critical,
    state: AlertEventState.received,
    title: 'Urgent Low',
    body: 'Urgent low glucose',
    payload: const {
      'personId': 'child-1',
      'type': 'urgentLow',
    },
    occurredAt: now,
    receivedAt: now,
    updatedAt: now,
  );
}

class _FakeAudioGateway extends AlertAudioGateway {
  int stopCount = 0;

  @override
  Future<void> play(AlertSoundRef sound) async {}

  @override
  Future<void> stopActivePlayback() async {
    stopCount++;
  }
}

class _MemoryAlertStrategyConfigRepository
    implements AlertStrategyConfigRepository {
  AlertStrategyConfigSet config = const AlertStrategyConfigSet();

  @override
  Future<AlertStrategyConfigSet> load() async => config;

  @override
  Future<void> save(AlertStrategyConfig next) async {
    config = switch (next.strategyKey) {
      SoundAlertConfig.key => config.copyWith(sound: next as SoundAlertConfig),
      InAppAlertConfig.key => config.copyWith(inApp: next as InAppAlertConfig),
      LocalNotificationAlertConfig.key => config.copyWith(
          localNotification: next as LocalNotificationAlertConfig,
        ),
      VibrationAlertConfig.key =>
        config.copyWith(vibration: next as VibrationAlertConfig),
      _ => config,
    };
  }

  @override
  Future<void> saveGlobal(AlertingGlobalConfig next) async {
    config = config.copyWith(global: next);
  }
}
