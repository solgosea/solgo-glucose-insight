import '../../domain/event/alert_category.dart';
import '../../domain/event/alert_event.dart';
import '../../domain/event/alert_level.dart';
import '../../domain/sound/alert_sound_loop_mode.dart';
import '../../domain/sound/alert_sound_playback_policy.dart';

class AlertSoundPlaybackPolicyResolver {
  const AlertSoundPlaybackPolicyResolver();

  AlertSoundPlaybackPolicy resolve(AlertEvent event) {
    final fromPayload = _fromPayload(event.payload['soundPolicy']);
    if (fromPayload != null) return fromPayload;
    return _defaultFor(event);
  }

  AlertSoundPlaybackPolicy? _fromPayload(Object? raw) {
    if (raw is Map) {
      return AlertSoundPlaybackPolicy.fromJson(raw.cast<String, Object?>());
    }
    return null;
  }

  AlertSoundPlaybackPolicy _defaultFor(AlertEvent event) {
    if (event.category == AlertCategory.glucoseUrgentLow ||
        event.level == AlertLevel.critical) {
      return const AlertSoundPlaybackPolicy(
        mode: AlertSoundLoopMode.continuous,
        intervalSeconds: 2,
        maxDurationSeconds: 300,
      );
    }
    if (event.category == AlertCategory.glucoseLow ||
        event.category == AlertCategory.glucoseHigh) {
      return const AlertSoundPlaybackPolicy(
        mode: AlertSoundLoopMode.burst,
        repeatCount: 3,
        intervalSeconds: 10,
      );
    }
    if (event.category == AlertCategory.noData) {
      return const AlertSoundPlaybackPolicy.single();
    }
    return const AlertSoundPlaybackPolicy.single();
  }
}
