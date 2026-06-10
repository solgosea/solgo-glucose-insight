import '../contracts/plugin_capability.dart';
import '../contracts/plugin_entry.dart';
import '../contracts/plugin_placement.dart';
import '../contracts/plugin_runtime_state.dart';
import '../registry/plugin_registry.dart';
import '../runtime/plugin_runtime_state_resolver.dart';

class ResolvedExplorePluginEntry {
  final ExplorePluginEntry entry;
  final PluginRuntimeState state;

  const ResolvedExplorePluginEntry({required this.entry, required this.state});
}

class ExplorePluginSection {
  final String title;
  final List<ResolvedExplorePluginEntry> resolvedEntries;

  const ExplorePluginSection({
    required this.title,
    required this.resolvedEntries,
  });

  List<ExplorePluginEntry> get entries =>
      resolvedEntries.map((resolved) => resolved.entry).toList(growable: false);
}

class ExplorePluginResolver {
  final PluginRegistry registry;

  const ExplorePluginResolver(this.registry);

  List<ExplorePluginSection> resolve({
    PluginCapabilityContext context = const PluginCapabilityContext(),
  }) {
    final entries =
        registry
            .visibleFor(PluginPlacement.exploreCard, context: context)
            .map((plugin) {
              final entry = plugin.exploreEntry;
              if (entry == null) return null;
              return ResolvedExplorePluginEntry(
                entry: entry,
                state: const PluginRuntimeStateResolver().resolve(
                  plugin,
                  context: context,
                ),
              );
            })
            .whereType<ResolvedExplorePluginEntry>()
            .toList()
          ..sort((a, b) => a.entry.order.compareTo(b.entry.order));

    final sections = <String, List<ResolvedExplorePluginEntry>>{};
    for (final resolved in entries) {
      sections.putIfAbsent(resolved.entry.section, () => []).add(resolved);
    }
    return sections.entries
        .map(
          (entry) => ExplorePluginSection(
            title: entry.key,
            resolvedEntries: entry.value,
          ),
        )
        .toList(growable: false);
  }
}
