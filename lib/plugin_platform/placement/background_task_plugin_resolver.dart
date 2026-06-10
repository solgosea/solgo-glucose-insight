import '../contracts/plugin_capability.dart';
import '../contracts/plugin_entry.dart';
import '../contracts/plugin_placement.dart';
import '../registry/plugin_registry.dart';

class BackgroundTaskPluginResolver {
  final PluginRegistry registry;

  const BackgroundTaskPluginResolver(this.registry);

  List<BackgroundTaskPluginEntry> resolve({
    PluginCapabilityContext context = const PluginCapabilityContext(),
  }) {
    final entries =
        registry
            .visibleFor(PluginPlacement.backgroundTask, context: context)
            .map((plugin) => plugin.backgroundTaskEntry)
            .whereType<BackgroundTaskPluginEntry>()
            .toList()
          ..sort((a, b) => a.order.compareTo(b.order));
    return entries;
  }
}
