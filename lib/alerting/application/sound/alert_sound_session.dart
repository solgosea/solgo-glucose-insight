import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../domain/resource/alert_sound_ref.dart';
import '../../domain/sound/alert_sound_loop_mode.dart';
import '../../domain/sound/alert_sound_playback_policy.dart';
import '../../domain/sound/alert_sound_playback_stop_reason.dart';
import '../../infrastructure/audio/alert_audio_gateway.dart';

class AlertSoundSession {
  final String key;
  final String alertEventId;
  final AlertSoundRef sound;
  final AlertSoundPlaybackPolicy policy;
  final AlertAudioGateway audioGateway;

  bool _running = false;
  bool _stopped = false;

  AlertSoundSession({
    required this.key,
    required this.alertEventId,
    required this.sound,
    required this.policy,
    required this.audioGateway,
  });

  bool get running => _running;

  void start({VoidCallback? onDone}) {
    if (_running) return;
    _running = true;
    unawaited(_run(onDone: onDone));
  }

  void stop(AlertSoundPlaybackStopReason reason) {
    _stopped = true;
    _running = false;
    unawaited(audioGateway.stopActivePlayback());
  }

  Future<void> _run({VoidCallback? onDone}) async {
    try {
      switch (policy.mode) {
        case AlertSoundLoopMode.silent:
          return;
        case AlertSoundLoopMode.single:
          await _playOnce();
        case AlertSoundLoopMode.burst:
          await _runBurst();
        case AlertSoundLoopMode.continuous:
          await _runContinuous();
      }
    } finally {
      _running = false;
      onDone?.call();
    }
  }

  Future<void> _runBurst() async {
    final repeatCount = policy.repeatCount <= 0 ? 1 : policy.repeatCount;
    for (var i = 0; i < repeatCount && !_stopped; i++) {
      await _playOnce();
      if (i != repeatCount - 1) {
        await _delayInterval();
      }
    }
  }

  Future<void> _runContinuous() async {
    final startedAt = DateTime.now();
    while (!_stopped) {
      await _playOnce();
      final maxDuration = policy.maxDurationSeconds;
      if (maxDuration != null &&
          DateTime.now().difference(startedAt).inSeconds >= maxDuration) {
        break;
      }
      await _delayInterval();
    }
  }

  Future<void> _playOnce() async {
    if (_stopped) return;
    try {
      await audioGateway.play(sound);
    } catch (error, stackTrace) {
      debugPrint('Alert sound session failed: $error');
      debugPrint('$stackTrace');
    }
  }

  Future<void> _delayInterval() async {
    final seconds = policy.intervalSeconds <= 0 ? 1 : policy.intervalSeconds;
    final end = DateTime.now().add(Duration(seconds: seconds));
    while (!_stopped && DateTime.now().isBefore(end)) {
      await Future<void>.delayed(const Duration(milliseconds: 250));
    }
  }
}
