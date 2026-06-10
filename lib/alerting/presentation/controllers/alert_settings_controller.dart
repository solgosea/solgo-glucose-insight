import 'package:flutter/foundation.dart';

import '../../application/sound/alert_sound_picker_service.dart';
import '../../application/sound/alert_sound_preview_service.dart';
import '../../application/sound/alert_sound_session_manager.dart';
import '../../domain/config/alerting_global_config.dart';
import '../../domain/config/alerting_settings_snapshot.dart';
import '../../domain/config/in_app_alert_config.dart';
import '../../domain/config/local_notification_alert_config.dart';
import '../../domain/config/sound_alert_config.dart';
import '../../domain/config/vibration_alert_config.dart';
import '../../domain/repository/alert_strategy_config_repository.dart';
import '../../domain/resource/alert_sound_ref.dart';

class AlertSettingsController extends ChangeNotifier {
  final AlertStrategyConfigRepository repository;
  final AlertSoundPickerService soundPicker;
  final AlertSoundPreviewService soundPreview;
  final AlertSoundSessionManager soundSessionManager;

  AlertStrategyConfigSet _config = const AlertStrategyConfigSet();
  bool loading = false;
  bool importingSound = false;
  AlertSoundRef? previewingSound;

  AlertSettingsController({
    required this.repository,
    this.soundPicker = const AlertSoundPickerService(),
    this.soundPreview = const AlertSoundPreviewService(),
    AlertSoundSessionManager? soundSessionManager,
  }) : soundSessionManager =
           soundSessionManager ?? AlertSoundSessionManager.shared;

  AlertSoundRef get selectedSound => _config.sound.sound;

  AlertingSettingsSnapshot get snapshot => AlertingSettingsSnapshot(
    globalEnabled: _config.global.enabled,
    criticalOnly: _config.global.criticalOnly,
    inAppEnabled: _config.inApp.enabled,
    localNotificationEnabled: _config.localNotification.enabled,
    soundEnabled: _config.sound.enabled,
    vibrationEnabled: _config.vibration.enabled,
    fullScreenForCritical: _config.inApp.fullScreenForCritical,
    repeatCriticalSound: _config.sound.repeatCritical,
    repeatCriticalVibration: _config.vibration.repeatCritical,
    soundMaxDurationSeconds: _config.sound.maxDurationSeconds,
    soundLabel: _config.sound.sound.displayName,
    criticalVibrationLabel: _config.vibration.criticalPattern.displayName,
    warningVibrationLabel: _config.vibration.warningPattern.displayName,
  );

  Future<void> load() async {
    loading = true;
    notifyListeners();
    _config = await repository.load();
    loading = false;
    notifyListeners();
  }

  Future<void> toggleGlobal(bool enabled) async {
    final next = AlertingGlobalConfig(
      enabled: enabled,
      criticalOnly: _config.global.criticalOnly,
    );
    _config = _config.copyWith(global: next);
    if (!enabled) soundSessionManager.stopAll();
    notifyListeners();
    await repository.saveGlobal(next);
  }

  Future<void> toggleCriticalOnly(bool enabled) async {
    final next = AlertingGlobalConfig(
      enabled: _config.global.enabled,
      criticalOnly: enabled,
    );
    _config = _config.copyWith(global: next);
    notifyListeners();
    await repository.saveGlobal(next);
  }

  Future<void> toggleInApp(bool enabled) async {
    final next = InAppAlertConfig(
      enabled: enabled,
      fullScreenForCritical: _config.inApp.fullScreenForCritical,
      warningAutoDismissSeconds: _config.inApp.warningAutoDismissSeconds,
    );
    _config = _config.copyWith(inApp: next);
    notifyListeners();
    await repository.save(next);
  }

  Future<void> toggleLocalNotification(bool enabled) async {
    final next = LocalNotificationAlertConfig(
      enabled: enabled,
      channel: _config.localNotification.channel,
      showCriticalOnLockScreen:
          _config.localNotification.showCriticalOnLockScreen,
    );
    _config = _config.copyWith(localNotification: next);
    notifyListeners();
    await repository.save(next);
  }

  Future<void> toggleSound(bool enabled) async {
    final next = SoundAlertConfig(
      enabled: enabled,
      sound: _config.sound.sound,
      repeatCritical: _config.sound.repeatCritical,
      maxDurationSeconds: _config.sound.maxDurationSeconds,
    );
    _config = _config.copyWith(sound: next);
    if (!enabled) soundSessionManager.stopAll();
    notifyListeners();
    await repository.save(next);
  }

  Future<void> selectSound(AlertSoundRef sound) async {
    final next = SoundAlertConfig(
      enabled: _config.sound.enabled,
      sound: sound,
      repeatCritical: _config.sound.repeatCritical,
      maxDurationSeconds: _config.sound.maxDurationSeconds,
    );
    _config = _config.copyWith(sound: next);
    soundSessionManager.stopAll();
    notifyListeners();
    await repository.save(next);
  }

  Future<AlertSoundRef?> importCustomSound() async {
    importingSound = true;
    notifyListeners();
    try {
      final sound = await soundPicker.pickCustomSound();
      if (sound != null) {
        await selectSound(sound);
      }
      return sound;
    } finally {
      importingSound = false;
      notifyListeners();
    }
  }

  Future<void> previewSound(AlertSoundRef sound) async {
    if (!sound.isPlayable) return;
    previewingSound = sound;
    notifyListeners();
    try {
      await soundPreview.preview(sound);
    } finally {
      previewingSound = null;
      notifyListeners();
    }
  }

  Future<void> toggleVibration(bool enabled) async {
    final next = VibrationAlertConfig(
      enabled: enabled,
      criticalPattern: _config.vibration.criticalPattern,
      warningPattern: _config.vibration.warningPattern,
      repeatCritical: _config.vibration.repeatCritical,
    );
    _config = _config.copyWith(vibration: next);
    notifyListeners();
    await repository.save(next);
  }
}
