import 'app_settings_change.dart';

class AppSettingsChangeImpact {
  final bool persist;
  final bool refreshAnalysis;
  final bool applyRepositorySettings;
  final bool syncBackgroundService;
  final bool updateForegroundPolling;
  final bool updateRuntime;

  const AppSettingsChangeImpact({
    required this.persist,
    required this.refreshAnalysis,
    required this.applyRepositorySettings,
    required this.syncBackgroundService,
    required this.updateForegroundPolling,
    required this.updateRuntime,
  });

  bool get hasDeferredWork =>
      refreshAnalysis ||
      applyRepositorySettings ||
      syncBackgroundService ||
      updateForegroundPolling ||
      updateRuntime;
}

class AppSettingsChangePolicy {
  const AppSettingsChangePolicy();

  AppSettingsChangeImpact evaluate(AppSettingsChange change) {
    if (!change.anyChanged) {
      return const AppSettingsChangeImpact(
        persist: false,
        refreshAnalysis: false,
        applyRepositorySettings: false,
        syncBackgroundService: false,
        updateForegroundPolling: false,
        updateRuntime: false,
      );
    }

    final sourceOrSyncChanged =
        change.dataSourceConfigChanged || change.syncPolicyChanged;

    return AppSettingsChangeImpact(
      persist: true,
      refreshAnalysis:
          change.thresholdChanged || change.insightPreferenceChanged,
      applyRepositorySettings: sourceOrSyncChanged,
      syncBackgroundService: sourceOrSyncChanged,
      updateForegroundPolling: change.dataSourceConfigChanged,
      updateRuntime: change.dataSourceConfigChanged,
    );
  }
}
