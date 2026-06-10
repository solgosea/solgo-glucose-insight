import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

import '../../domain/resource/alert_builtin_sounds.dart';
import '../../domain/resource/alert_sound_ref.dart';

class AlertAudioGateway {
  static final Set<AudioPlayer> _activePlayers = {};

  const AlertAudioGateway();

  Future<void> play(AlertSoundRef sound) async {
    switch (sound.source) {
      case AlertSoundSource.asset:
        return _playAsset(sound.uri);
      case AlertSoundSource.file:
        return _playFile(sound.uri);
      case AlertSoundSource.silent:
        return;
    }
  }

  Future<void> preview(AlertSoundRef sound) async {
    await stopActivePlayback();
    switch (sound.source) {
      case AlertSoundSource.asset:
        return _playAsset(sound.uri, maxDuration: const Duration(seconds: 3));
      case AlertSoundSource.file:
        return _playFile(sound.uri, maxDuration: const Duration(seconds: 5));
      case AlertSoundSource.silent:
        return;
    }
  }

  Future<void> stopActivePlayback() async {
    final players = _activePlayers.toList(growable: false);
    _activePlayers.clear();
    for (final player in players) {
      try {
        await player.stop();
      } catch (_) {
        // Best-effort stop. A disposed player is already silent.
      }
    }
  }

  Future<void> _playAsset(
    String? uri, {
    Duration maxDuration = const Duration(milliseconds: 1200),
  }) async {
    if (uri == null || uri.isEmpty) {
      await _playAsset(AlertBuiltinSounds.defaultSound.uri);
      return;
    }
    final player = AudioPlayer();
    _activePlayers.add(player);
    try {
      await player.play(
        AssetSource(uri, mimeType: 'audio/wav'),
        volume: 1,
        mode: PlayerMode.lowLatency,
        ctx:
            AudioContextConfig(
              route: AudioContextConfigRoute.system,
              focus: AudioContextConfigFocus.gain,
            ).build(),
      );
      await Future<void>.delayed(maxDuration);
    } finally {
      _activePlayers.remove(player);
      await player.stop();
      await player.dispose();
    }
  }

  Future<void> _playFile(
    String? uri, {
    Duration maxDuration = const Duration(seconds: 8),
  }) async {
    if (uri == null || uri.isEmpty) {
      await _playAsset(AlertBuiltinSounds.defaultSound.uri);
      return;
    }
    final file = File(uri);
    if (!await file.exists()) {
      debugPrint('Alert sound file does not exist: $uri');
      await _playAsset(AlertBuiltinSounds.defaultSound.uri);
      return;
    }
    final player = AudioPlayer();
    _activePlayers.add(player);
    try {
      await player.setReleaseMode(ReleaseMode.stop);
      await player.setVolume(1);
      await player.setPlayerMode(PlayerMode.mediaPlayer);
      await player.setAudioContext(
        AudioContextConfig(
          route: AudioContextConfigRoute.system,
          focus: AudioContextConfigFocus.gain,
          stayAwake: true,
        ).build(),
      );
      await player.setSource(DeviceFileSource(uri));
      await player.resume();
      await _waitForCompletionOrLimit(player, maxDuration);
    } catch (error, stackTrace) {
      debugPrint('Alert sound file playback failed: $error');
      debugPrint('$stackTrace');
      await _playAsset(AlertBuiltinSounds.defaultSound.uri);
    } finally {
      _activePlayers.remove(player);
      await player.stop();
      await player.dispose();
    }
  }

  Future<void> _waitForCompletionOrLimit(
    AudioPlayer player,
    Duration maxDuration,
  ) async {
    final completed = Completer<void>();
    late final StreamSubscription<void> subscription;
    subscription = player.onPlayerComplete.listen((_) {
      if (!completed.isCompleted) {
        completed.complete();
      }
    });
    try {
      await Future.any<void>([
        completed.future,
        Future<void>.delayed(maxDuration),
      ]);
    } finally {
      await subscription.cancel();
    }
  }
}
