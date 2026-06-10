import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_release_stage.dart';
import 'package:smart_xdrip/plugin_platform/placement/background_task_plugin_resolver.dart';
import 'package:smart_xdrip/plugin_platform/placement/explore_plugin_resolver.dart';
import 'package:smart_xdrip/plugin_platform/registry/plugin_registry_builder.dart';
import 'package:smart_xdrip/plugins/plugin_catalog.dart';
import 'package:smart_xdrip/plugins/plugin_release_config.dart';
import 'package:smart_xdrip/plugins/release/plugin_release_matrix_resolver.dart';

void main() {
  const resolver = PluginReleaseMatrixResolver();

  test('oss preview exposes first-release episodes and background tasks', () {
    final registry = const PluginRegistryBuilder().build(
      plugins: pluginCatalog,
      releaseOverrides: resolver.resolve(
        plugins: pluginCatalog,
        matrix: ossPreviewPluginReleaseMatrix,
      ),
    );

    final exploreRoutes = ExplorePluginResolver(registry)
        .resolve()
        .expand((section) => section.entries)
        .map((entry) => entry.route);
    final backgroundTasks = BackgroundTaskPluginResolver(registry).resolve();

    expect(exploreRoutes, contains('/explore/high-episode'));
    expect(exploreRoutes, contains('/explore/low-episode'));
    expect(backgroundTasks.map((task) => task.taskKey), [
      'source.health_check',
      'glucose.sync',
    ]);
  });

  test('public beta keeps alerting and episode plugins visible', () {
    final overrides = resolver.resolve(
      plugins: pluginCatalog,
      matrix: publicBetaPluginReleaseMatrix,
    );

    final highEpisode = pluginCatalog.firstWhere(
      (plugin) => plugin.id.value == 'explore.high_episode',
    );
    final alerting = pluginCatalog.firstWhere(
      (plugin) => plugin.id.value == 'core.alerting',
    );

    expect(
      overrides.stageFor(highEpisode.id, highEpisode.releaseStage).isVisible,
      isTrue,
    );
    expect(
      overrides.stageFor(alerting.id, alerting.releaseStage).isVisible,
      isTrue,
    );
  });

  test('current release matrix preserves first-release public surfaces', () {
    final registry = const PluginRegistryBuilder().build(
      plugins: pluginCatalog,
      releaseOverrides: defaultPluginReleaseOverrides,
    );

    final exploreRoutes = ExplorePluginResolver(registry)
        .resolve()
        .expand((section) => section.entries)
        .map((entry) => entry.route);
    final backgroundTasks = BackgroundTaskPluginResolver(registry).resolve();

    expect(exploreRoutes, contains('/explore/high-episode'));
    expect(exploreRoutes, contains('/explore/low-episode'));
    expect(backgroundTasks.map((task) => task.taskKey), [
      'source.health_check',
      'glucose.sync',
    ]);
  });
}
