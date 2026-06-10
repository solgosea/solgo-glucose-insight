import '../../domain/channel/alert_channel.dart';
import '../../domain/channel/alert_delivery_result.dart';
import '../../domain/config/sound_alert_config.dart';
import '../../domain/event/alert_event.dart';
import '../../domain/resource/alert_sound_ref.dart';
import '../../domain/sound/alert_sound_loop_mode.dart';
import '../../domain/actuator/alert_actuator_command.dart';
import '../../application/actuator/alert_actuator_command_bus.dart';
import '../../application/sound/alert_sound_playback_policy_resolver.dart';
import '../../application/sound/alert_sound_session_manager.dart';
import '../../infrastructure/audio/alert_audio_gateway.dart';
import '../alert_strategy.dart';

class SoundAlertStrategy implements AlertStrategy<SoundAlertConfig> {
  final AlertAudioGateway gateway;
  final AlertSoundPlaybackPolicyResolver policyResolver;
  final AlertSoundSessionManager sessionManager;
  final AlertActuatorCommandBus? commandBus;

  SoundAlertStrategy({
    this.gateway = const AlertAudioGateway(),
    this.policyResolver = const AlertSoundPlaybackPolicyResolver(),
    AlertSoundSessionManager? sessionManager,
    this.commandBus,
  }) : sessionManager = sessionManager ?? AlertSoundSessionManager.shared;

  @override
  String get strategyKey => SoundAlertConfig.key;

  @override
  AlertChannel get channel => AlertChannel.sound;

  @override
  bool supports(AlertEvent event) => true;

  @override
  Future<AlertDeliveryResult> deliver(
    AlertEvent event,
    SoundAlertConfig config,
  ) async {
    if (!config.enabled) {
      return const AlertDeliveryResult.skipped(
        channel: AlertChannel.sound,
        message: 'Sound alert is disabled.',
      );
    }
    if (config.sound.source == AlertSoundSource.silent) {
      return const AlertDeliveryResult.skipped(
        channel: AlertChannel.sound,
        message: 'Sound alert is silent.',
      );
    }
    try {
      final policy = policyResolver.resolve(event);
      if (policy.mode == AlertSoundLoopMode.silent) {
        return const AlertDeliveryResult.skipped(
          channel: AlertChannel.sound,
          message: 'Sound policy is silent.',
        );
      }
      if (commandBus != null) {
        final results = await commandBus!.dispatch(
          AlertActuatorCommand.playSound(
            id: commandBus!.idGenerator.newId('act'),
            event: event,
            sound: config.sound,
            policy: policy,
            createdAt: DateTime.now(),
          ),
        );
        final failed = results.where((result) => !result.success).toList();
        if (failed.isNotEmpty) {
          return AlertDeliveryResult.failed(
            channel: AlertChannel.sound,
            message: failed.first.message,
          );
        }
        return AlertDeliveryResult.delivered(
          channel: AlertChannel.sound,
          message: 'Sound alert command dispatched.',
          result: {
            'mode': policy.mode.code,
            'repeatCount': policy.repeatCount,
            'intervalSeconds': policy.intervalSeconds,
            'maxDurationSeconds': policy.maxDurationSeconds,
          },
        );
      }
      sessionManager.start(event: event, sound: config.sound, policy: policy);
      return AlertDeliveryResult.delivered(
        channel: AlertChannel.sound,
        message: 'Sound alert session started.',
        result: {
          'mode': policy.mode.code,
          'repeatCount': policy.repeatCount,
          'intervalSeconds': policy.intervalSeconds,
          'maxDurationSeconds': policy.maxDurationSeconds,
        },
      );
    } catch (error) {
      return AlertDeliveryResult.failed(
        channel: AlertChannel.sound,
        message: 'Sound alert failed: $error',
      );
    }
  }

  @override
  Future<void> stop(String alertEventId) async {
    if (commandBus != null) {
      await commandBus!.stopEvent(alertEventId);
      return;
    }
    sessionManager.stopEvent(alertEventId);
  }
}
