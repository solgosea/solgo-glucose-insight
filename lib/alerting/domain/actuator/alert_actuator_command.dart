import '../config/local_notification_alert_config.dart';
import '../event/alert_event.dart';
import '../resource/alert_sound_ref.dart';
import '../resource/alert_vibration_pattern.dart';
import '../sound/alert_sound_playback_policy.dart';
import 'alert_actuator_command_type.dart';
import 'alert_actuator_target.dart';

class AlertActuatorCommand {
  final String id;
  final AlertActuatorCommandType type;
  final AlertActuatorTarget target;
  final AlertEvent? event;
  final AlertSoundRef? sound;
  final AlertSoundPlaybackPolicy? soundPolicy;
  final AlertVibrationPattern? vibrationPattern;
  final LocalNotificationAlertConfig? notificationConfig;
  final DateTime createdAt;

  const AlertActuatorCommand({
    required this.id,
    required this.type,
    required this.target,
    this.event,
    this.sound,
    this.soundPolicy,
    this.vibrationPattern,
    this.notificationConfig,
    required this.createdAt,
  });

  factory AlertActuatorCommand.playSound({
    required String id,
    required AlertEvent event,
    required AlertSoundRef sound,
    required AlertSoundPlaybackPolicy policy,
    required DateTime createdAt,
  }) {
    return AlertActuatorCommand(
      id: id,
      type: AlertActuatorCommandType.playSound,
      target: AlertActuatorTarget.fromEvent(event),
      event: event,
      sound: sound,
      soundPolicy: policy,
      createdAt: createdAt,
    );
  }

  factory AlertActuatorCommand.vibrate({
    required String id,
    required AlertEvent event,
    required AlertVibrationPattern pattern,
    required DateTime createdAt,
  }) {
    return AlertActuatorCommand(
      id: id,
      type: AlertActuatorCommandType.vibrate,
      target: AlertActuatorTarget.fromEvent(event),
      event: event,
      vibrationPattern: pattern,
      createdAt: createdAt,
    );
  }

  factory AlertActuatorCommand.showNotification({
    required String id,
    required AlertEvent event,
    required LocalNotificationAlertConfig config,
    required DateTime createdAt,
  }) {
    return AlertActuatorCommand(
      id: id,
      type: AlertActuatorCommandType.showNotification,
      target: AlertActuatorTarget.fromEvent(event),
      event: event,
      notificationConfig: config,
      createdAt: createdAt,
    );
  }

  factory AlertActuatorCommand.stopEvent({
    required String id,
    required String eventId,
    required DateTime createdAt,
  }) {
    return AlertActuatorCommand(
      id: id,
      type: AlertActuatorCommandType.stopEvent,
      target: AlertActuatorTarget(eventId: eventId),
      createdAt: createdAt,
    );
  }

  factory AlertActuatorCommand.stopTarget({
    required String id,
    required String targetId,
    required String type,
    required DateTime createdAt,
  }) {
    return AlertActuatorCommand(
      id: id,
      type: AlertActuatorCommandType.stopTarget,
      target: AlertActuatorTarget(targetId: targetId, type: type),
      createdAt: createdAt,
    );
  }

  factory AlertActuatorCommand.stopAll({
    required String id,
    required DateTime createdAt,
  }) {
    return AlertActuatorCommand(
      id: id,
      type: AlertActuatorCommandType.stopAll,
      target: const AlertActuatorTarget(),
      createdAt: createdAt,
    );
  }
}
