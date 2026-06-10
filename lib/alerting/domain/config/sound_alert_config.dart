import '../resource/alert_builtin_sounds.dart';
import '../resource/alert_sound_ref.dart';
import 'alert_strategy_config.dart';

class SoundAlertConfig implements AlertStrategyConfig {
  static const key = 'sound';
  @override
  final bool enabled;
  final AlertSoundRef sound;
  final bool repeatCritical;
  final int maxDurationSeconds;

  const SoundAlertConfig({
    this.enabled = true,
    this.sound = AlertBuiltinSounds.defaultSound,
    this.repeatCritical = true,
    this.maxDurationSeconds = 60,
  });

  @override
  String get strategyKey => key;

  @override
  Map<String, Object?> toJson() => {
    'enabled': enabled,
    'sound': sound.toJson(),
    'repeatCritical': repeatCritical,
    'maxDurationSeconds': maxDurationSeconds,
  };

  static SoundAlertConfig fromJson(Map<String, Object?> json) {
    final rawSound = (json['sound'] as Map?)?.cast<String, Object?>();
    return SoundAlertConfig(
      enabled: json['enabled'] as bool? ?? true,
      sound:
          rawSound == null ? AlertBuiltinSounds.defaultSound : _sound(rawSound),
      repeatCritical: json['repeatCritical'] as bool? ?? true,
      maxDurationSeconds: (json['maxDurationSeconds'] as num?)?.round() ?? 60,
    );
  }

  static AlertSoundRef _sound(Map<String, Object?> json) {
    final sound = AlertSoundRef.fromJson(json);
    if (sound.source == AlertSoundSource.asset &&
        (sound.uri == null || sound.uri!.isEmpty)) {
      return AlertBuiltinSounds.defaultSound;
    }
    return sound;
  }
}
