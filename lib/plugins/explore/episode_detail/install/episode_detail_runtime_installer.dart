import '../../../../application/analysis/analysis_facade.dart';
import '../../../../plugin_platform/install/plugin_install_context.dart';
import '../../../../plugin_platform/runtime/manager/plugin_runtime_start_policy.dart';
import '../application/episode_detail_snapshot_preheater.dart';
import '../runtime/episode_detail_plugin_runtime.dart';
import '../runtime/episode_detail_runtime_cache.dart';

class EpisodeDetailRuntimeInstaller {
  const EpisodeDetailRuntimeInstaller._();

  static void install(PluginInstallContext context) {
    final existingCache = context.services.maybe<EpisodeDetailRuntimeCache>();
    final existingRuntime =
        context.services.maybe<EpisodeDetailPluginRuntime>();
    if (existingCache != null && existingRuntime != null) return;

    final cache = existingCache ?? EpisodeDetailRuntimeCache();
    final runtime =
        existingRuntime ??
        EpisodeDetailPluginRuntime(
          cache: cache,
          preheater: EpisodeDetailSnapshotPreheater(
            facadeProvider: AnalysisFacade.current,
          ),
        );

    if (existingCache == null) {
      context.services.register<EpisodeDetailRuntimeCache>(cache);
    }
    if (existingRuntime == null) {
      context.services.register<EpisodeDetailPluginRuntime>(runtime);
      context.registerRuntime(
        runtime,
        startPolicy: PluginRuntimeStartPolicy.onEnter,
      );
    }
  }
}
