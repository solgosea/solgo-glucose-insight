class AlertRuntimeCapability {
  final bool supportsForegroundAlerts;
  final bool supportsBackgroundEvaluation;
  final bool supportsGuaranteedRealtime;
  final bool supportsLocalNotifications;
  final bool supportsRemotePush;
  final String limitationText;

  const AlertRuntimeCapability({
    required this.supportsForegroundAlerts,
    required this.supportsBackgroundEvaluation,
    required this.supportsGuaranteedRealtime,
    required this.supportsLocalNotifications,
    required this.supportsRemotePush,
    required this.limitationText,
  });

  const AlertRuntimeCapability.android()
      : supportsForegroundAlerts = true,
        supportsBackgroundEvaluation = true,
        supportsGuaranteedRealtime = false,
        supportsLocalNotifications = true,
        supportsRemotePush = true,
        limitationText =
            'Android alerts can run through the foreground service, but '
                'SolgoInsight still treats them as helper alerts.';

  const AlertRuntimeCapability.iosPreview()
      : supportsForegroundAlerts = true,
        supportsBackgroundEvaluation = true,
        supportsGuaranteedRealtime = false,
        supportsLocalNotifications = true,
        supportsRemotePush = false,
        limitationText =
            'iOS can evaluate helper alerts during best-effort background '
                'refresh when the system allows it. It is not real-time.';

  const AlertRuntimeCapability.other()
      : supportsForegroundAlerts = true,
        supportsBackgroundEvaluation = false,
        supportsGuaranteedRealtime = false,
        supportsLocalNotifications = false,
        supportsRemotePush = false,
        limitationText =
            'This platform does not provide reliable background alerts.';
}
