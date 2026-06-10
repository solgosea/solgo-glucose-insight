import '../../data/local/settings_store.dart';
import '../../domain/entities/app_settings.dart';
import 'app_settings_change.dart';
import 'app_settings_change_policy.dart';
import 'app_settings_update_result.dart';

typedef AppSettingsPublisher = void Function(AppSettings settings);
typedef AppSettingsAsyncHandler = Future<void> Function(AppSettings settings);
typedef AppSettingsSyncHandler = void Function(AppSettings settings);

class AppSettingsUpdateCoordinator {
  final SettingsStore store;
  final AppSettingsChangePolicy policy;
  final AppSettingsPublisher publishSettings;
  final AppSettingsAsyncHandler applyRepositorySettings;
  final Future<void> Function() refreshAnalysis;
  final AppSettingsAsyncHandler syncBackgroundService;
  final AppSettingsSyncHandler updateForegroundPolling;
  final AppSettingsAsyncHandler updateRuntimeSettings;

  const AppSettingsUpdateCoordinator({
    required this.store,
    required this.publishSettings,
    required this.applyRepositorySettings,
    required this.refreshAnalysis,
    required this.syncBackgroundService,
    required this.updateForegroundPolling,
    required this.updateRuntimeSettings,
    this.policy = const AppSettingsChangePolicy(),
  });

  Future<AppSettingsUpdateResult> update({
    required AppSettings previous,
    required AppSettings next,
  }) async {
    final change = AppSettingsChange(previous: previous, next: next);
    final impact = policy.evaluate(change);
    if (!impact.persist) {
      return AppSettingsUpdateResult(impact: impact, applied: false);
    }

    // Publish first so display-only settings, especially glucose unit, become
    // visible immediately. Slower persistence/runtime work follows.
    publishSettings(next);

    await store.save(next);

    if (impact.applyRepositorySettings) {
      await applyRepositorySettings(next);
    }
    if (impact.refreshAnalysis) {
      await refreshAnalysis();
    }
    if (impact.syncBackgroundService) {
      await syncBackgroundService(next);
    }
    if (impact.updateForegroundPolling) {
      updateForegroundPolling(next);
    }
    if (impact.updateRuntime) {
      await updateRuntimeSettings(next);
    }

    return AppSettingsUpdateResult(impact: impact, applied: true);
  }
}
