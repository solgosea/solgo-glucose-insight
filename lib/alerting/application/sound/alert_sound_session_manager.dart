import '../../domain/event/alert_event.dart';
import '../../domain/resource/alert_sound_ref.dart';
import '../../domain/sound/alert_sound_playback_policy.dart';
import '../../domain/sound/alert_sound_playback_stop_reason.dart';
import '../../infrastructure/audio/alert_audio_gateway.dart';
import 'alert_sound_session.dart';
import 'alert_sound_session_key.dart';

class AlertSoundSessionManager {
  static final AlertSoundSessionManager shared = AlertSoundSessionManager();

  final AlertAudioGateway audioGateway;
  final AlertSoundSessionKey sessionKey;
  final Map<String, AlertSoundSession> _sessions = {};

  AlertSoundSessionManager({
    this.audioGateway = const AlertAudioGateway(),
    this.sessionKey = const AlertSoundSessionKey(),
  });

  List<String> get runningKeys => _sessions.keys.toList(growable: false);

  void start({
    required AlertEvent event,
    required AlertSoundRef sound,
    required AlertSoundPlaybackPolicy policy,
  }) {
    final key = sessionKey.fromEvent(event);
    _sessions.remove(key)?.stop(AlertSoundPlaybackStopReason.replaced);
    final session = AlertSoundSession(
      key: key,
      alertEventId: event.id,
      sound: sound,
      policy: policy,
      audioGateway: audioGateway,
    );
    _sessions[key] = session;
    session.start(
      onDone: () {
        if (_sessions[key] == session) {
          _sessions.remove(key);
        }
      },
    );
  }

  void stopEvent(String alertEventId) {
    final matches = _sessions.entries
        .where((entry) => entry.value.alertEventId == alertEventId)
        .map((entry) => entry.key)
        .toList(growable: false);
    for (final key in matches) {
      _sessions.remove(key)?.stop(AlertSoundPlaybackStopReason.stopped);
    }
  }

  void stopKey(String key) {
    _sessions.remove(key)?.stop(AlertSoundPlaybackStopReason.stopped);
  }

  void stopTargetType({required String targetId, required String type}) {
    for (final key in sessionKey.targetTypeKeys(
      targetId: targetId,
      type: type,
    )) {
      stopKey(key);
    }
  }

  void stopAll() {
    final current = _sessions.values.toList(growable: false);
    _sessions.clear();
    for (final session in current) {
      session.stop(AlertSoundPlaybackStopReason.disposed);
    }
  }
}
