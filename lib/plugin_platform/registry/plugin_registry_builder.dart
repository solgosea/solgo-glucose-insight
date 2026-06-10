import '../contracts/smart_feature_plugin.dart';
import 'configured_feature_plugin.dart';
import 'plugin_registry.dart';
import 'plugin_registry_validation.dart';
import 'plugin_release_overrides.dart';

class PluginRegistryBuilder {
  final PluginRegistryValidator validator;

  const PluginRegistryBuilder({
    this.validator = const PluginRegistryValidator(),
  });

  PluginRegistry build({
    required List<SmartFeaturePlugin> plugins,
    PluginReleaseOverrides releaseOverrides = const PluginReleaseOverrides(),
  }) {
    final configured = plugins
        .map(
          (plugin) => ConfiguredFeaturePlugin(
            delegate: plugin,
            releaseStage: releaseOverrides.stageFor(
              plugin.id,
              plugin.releaseStage,
            ),
          ),
        )
        .toList(growable: false);
    final validation = validator.validate(configured);
    if (!validation.isValid) {
      throw StateError(
        'Invalid plugin registry: ${validation.issues.join('; ')}',
      );
    }
    return PluginRegistry(configured);
  }
}
