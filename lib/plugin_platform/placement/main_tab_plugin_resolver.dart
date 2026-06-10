import '../contracts/plugin_capability.dart';
import '../contracts/plugin_entry.dart';
import '../contracts/plugin_placement.dart';
import '../registry/plugin_registry.dart';

class MainTabPluginResolver {
  final PluginRegistry registry;

  const MainTabPluginResolver(this.registry);

  List<MainTabPluginEntry> resolve({
    PluginCapabilityContext context = const PluginCapabilityContext(),
  }) {
    final entries =
        registry
            .enabledFor(PluginPlacement.mainTab, context: context)
            .map((plugin) => plugin.mainTabEntry)
            .whereType<MainTabPluginEntry>()
            .toList()
          ..sort((a, b) => a.order.compareTo(b.order));
    return entries;
  }
}
