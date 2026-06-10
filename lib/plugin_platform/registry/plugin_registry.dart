import '../contracts/plugin_capability.dart';
import '../contracts/plugin_manifest.dart';
import '../contracts/plugin_placement.dart';
import '../contracts/plugin_runtime_state.dart';
import '../contracts/smart_feature_plugin.dart';
import '../runtime/plugin_runtime_state_resolver.dart';

class PluginRegistry {
  final List<SmartFeaturePlugin> _plugins;

  const PluginRegistry(List<SmartFeaturePlugin> plugins) : _plugins = plugins;

  List<SmartFeaturePlugin> get all => List.unmodifiable(_plugins);

  List<PluginManifest> get manifests =>
      _plugins.map((plugin) => plugin.manifest).toList(growable: false);

  List<PluginRuntimeState> runtimeStates({
    PluginCapabilityContext context = const PluginCapabilityContext(),
    PluginRuntimeStateResolver resolver = const PluginRuntimeStateResolver(),
  }) {
    return _plugins
        .map((plugin) => resolver.resolve(plugin, context: context))
        .toList(growable: false);
  }

  List<SmartFeaturePlugin> visible({
    PluginCapabilityContext context = const PluginCapabilityContext(),
  }) {
    return _plugins
        .where((plugin) => plugin.capability(context).visible)
        .toList(growable: false);
  }

  List<SmartFeaturePlugin> visibleFor(
    PluginPlacement placement, {
    PluginCapabilityContext context = const PluginCapabilityContext(),
  }) {
    return _plugins
        .where((plugin) => plugin.placements.contains(placement))
        .where((plugin) => plugin.capability(context).visible)
        .toList(growable: false);
  }

  List<SmartFeaturePlugin> enabledFor(
    PluginPlacement placement, {
    PluginCapabilityContext context = const PluginCapabilityContext(),
  }) {
    return visibleFor(placement, context: context)
        .where((plugin) => plugin.capability(context).enabled)
        .toList(growable: false);
  }
}
