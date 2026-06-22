class SyncRuntimeCapability {
  final bool supportsNightscoutApi;
  final bool supportsXdripLocal;
  final bool supportsForegroundSync;
  final bool supportsResumeSync;
  final bool supportsBackgroundRefresh;
  final bool supportsContinuousBackgroundSync;
  final String limitationText;

  const SyncRuntimeCapability({
    required this.supportsNightscoutApi,
    required this.supportsXdripLocal,
    required this.supportsForegroundSync,
    required this.supportsResumeSync,
    required this.supportsBackgroundRefresh,
    required this.supportsContinuousBackgroundSync,
    required this.limitationText,
  });

  const SyncRuntimeCapability.android()
      : supportsNightscoutApi = true,
        supportsXdripLocal = true,
        supportsForegroundSync = true,
        supportsResumeSync = true,
        supportsBackgroundRefresh = true,
        supportsContinuousBackgroundSync = true,
        limitationText =
            'Android can keep SolgoInsight running with a foreground service.';

  const SyncRuntimeCapability.iosPreview()
      : supportsNightscoutApi = true,
        supportsXdripLocal = false,
        supportsForegroundSync = true,
        supportsResumeSync = true,
        supportsBackgroundRefresh = true,
        supportsContinuousBackgroundSync = false,
        limitationText =
            'iOS supports Nightscout foreground/resume sync and best-effort '
                'BGAppRefresh when the system allows it. It is not real-time.';

  const SyncRuntimeCapability.other()
      : supportsNightscoutApi = true,
        supportsXdripLocal = false,
        supportsForegroundSync = true,
        supportsResumeSync = true,
        supportsBackgroundRefresh = false,
        supportsContinuousBackgroundSync = false,
        limitationText =
            'This platform supports foreground sync only in the preview.';
}
