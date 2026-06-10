import '../plugin_platform/registry/plugin_registry.dart';
import '../plugin_platform/registry/plugin_registry_builder.dart';
import 'plugin_catalog.dart';
import 'plugin_release_config.dart';

const builtInFeaturePlugins = pluginCatalog;

final PluginRegistry builtInPluginRegistry = const PluginRegistryBuilder()
    .build(
      plugins: builtInFeaturePlugins,
      releaseOverrides: defaultPluginReleaseOverrides,
    );
