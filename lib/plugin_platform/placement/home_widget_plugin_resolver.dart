import '../contracts/plugin_capability.dart';
import '../contracts/plugin_entry.dart';
import '../contracts/plugin_placement.dart';
import '../contracts/plugin_runtime_state.dart';
import '../registry/plugin_registry.dart';
import '../runtime/plugin_runtime_state_resolver.dart';

class ResolvedHomeWidgetPluginEntry {
  final HomeWidgetPluginEntry entry;
  final PluginRuntimeState state;

  const ResolvedHomeWidgetPluginEntry({
    required this.entry,
    required this.state,
  });
}

class HomeWidgetPluginResolver {
  final PluginRegistry registry;

  const HomeWidgetPluginResolver(this.registry);

  List<ResolvedHomeWidgetPluginEntry> resolve({
    PluginCapabilityContext context = const PluginCapabilityContext(),
  }) {
    final entries =
        registry
            .visibleFor(PluginPlacement.homeWidget, context: context)
            .map((plugin) {
              final entry = plugin.homeWidgetEntry;
              if (entry == null) return null;
              return ResolvedHomeWidgetPluginEntry(
                entry: entry,
                state: const PluginRuntimeStateResolver().resolve(
                  plugin,
                  context: context,
                ),
              );
            })
            .whereType<ResolvedHomeWidgetPluginEntry>()
            .toList()
          ..sort((a, b) => a.entry.order.compareTo(b.entry.order));
    return entries;
  }
}
