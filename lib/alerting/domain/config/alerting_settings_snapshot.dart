class AlertingSettingsSnapshot {
  final bool globalEnabled;
  final bool criticalOnly;
  final bool inAppEnabled;
  final bool localNotificationEnabled;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final bool fullScreenForCritical;
  final bool repeatCriticalSound;
  final bool repeatCriticalVibration;
  final int soundMaxDurationSeconds;
  final String soundLabel;
  final String criticalVibrationLabel;
  final String warningVibrationLabel;

  const AlertingSettingsSnapshot({
    required this.globalEnabled,
    required this.criticalOnly,
    required this.inAppEnabled,
    required this.localNotificationEnabled,
    required this.soundEnabled,
    required this.vibrationEnabled,
    required this.fullScreenForCritical,
    required this.repeatCriticalSound,
    required this.repeatCriticalVibration,
    required this.soundMaxDurationSeconds,
    required this.soundLabel,
    required this.criticalVibrationLabel,
    required this.warningVibrationLabel,
  });
}
