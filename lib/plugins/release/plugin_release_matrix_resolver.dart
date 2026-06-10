import '../../plugin_platform/contracts/plugin_release_stage.dart';
import '../../plugin_platform/contracts/smart_feature_plugin.dart';
import '../../plugin_platform/registry/plugin_release_overrides.dart';
import 'plugin_bundle_catalog.dart';
import 'plugin_release_matrix.dart';

class PluginReleaseMatrixResolver {
  final PluginBundleCatalog bundleCatalog;

  const PluginReleaseMatrixResolver({
    this.bundleCatalog = defaultPluginBundleCatalog,
  });

  PluginReleaseOverrides resolve({
    required List<SmartFeaturePlugin> plugins,
    required PluginReleaseMatrix matrix,
  }) {
    final enabledPluginIds = bundleCatalog.pluginIdsFor(matrix.enabledBundles);
    final stages = <String, PluginReleaseStage>{};

    for (final plugin in plugins) {
      if (!enabledPluginIds.contains(plugin.id.value)) {
        stages[plugin.id.value] = PluginReleaseStage.hidden;
      }
    }
    stages.addAll(matrix.pluginOverrides);
    return PluginReleaseOverrides(stages: stages);
  }
}
