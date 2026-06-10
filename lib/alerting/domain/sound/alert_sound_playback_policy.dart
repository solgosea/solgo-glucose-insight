import 'alert_sound_loop_mode.dart';

class AlertSoundPlaybackPolicy {
  final AlertSoundLoopMode mode;
  final int repeatCount;
  final int intervalSeconds;
  final int? maxDurationSeconds;

  const AlertSoundPlaybackPolicy({
    required this.mode,
    this.repeatCount = 1,
    this.intervalSeconds = 1,
    this.maxDurationSeconds,
  });

  const AlertSoundPlaybackPolicy.single()
    : mode = AlertSoundLoopMode.single,
      repeatCount = 1,
      intervalSeconds = 1,
      maxDurationSeconds = null;

  Map<String, Object?> toJson() => {
    'mode': mode.code,
    'repeatCount': repeatCount,
    'intervalSeconds': intervalSeconds,
    'maxDurationSeconds': maxDurationSeconds,
  };

  static AlertSoundPlaybackPolicy fromJson(Map<String, Object?> json) {
    return AlertSoundPlaybackPolicy(
      mode: AlertSoundLoopMode.fromCode(json['mode'] as String? ?? ''),
      repeatCount: (json['repeatCount'] as num?)?.round() ?? 1,
      intervalSeconds: (json['intervalSeconds'] as num?)?.round() ?? 1,
      maxDurationSeconds: (json['maxDurationSeconds'] as num?)?.round(),
    );
  }
}
