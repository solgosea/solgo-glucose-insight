import '../contracts/plugin_capability.dart';
import '../contracts/plugin_entry.dart';
import '../contracts/plugin_placement.dart';
import '../contracts/plugin_runtime_state.dart';
import '../registry/plugin_registry.dart';
import '../runtime/plugin_runtime_state_resolver.dart';

class ResolvedSectionPluginEntry {
  final SectionPluginEntry entry;
  final PluginRuntimeState state;

  const ResolvedSectionPluginEntry({required this.entry, required this.state});
}

class SectionPluginResolver {
  final PluginRegistry registry;
  final PluginPlacement placement;

  const SectionPluginResolver({
    required this.registry,
    required this.placement,
  });

  List<SectionPluginEntry> resolve({
    PluginCapabilityContext context = const PluginCapabilityContext(),
  }) {
    return resolveWithState(
      context: context,
    ).map((resolved) => resolved.entry).toList(growable: false);
  }

  List<ResolvedSectionPluginEntry> resolveWithState({
    PluginCapabilityContext context = const PluginCapabilityContext(),
  }) {
    final entries =
        registry
            .visibleFor(placement, context: context)
            .map((plugin) {
              final entry = switch (placement) {
                PluginPlacement.profileSection => plugin.profileEntry,
                PluginPlacement.settingsSection => plugin.settingsEntry,
                _ => null,
              };
              if (entry == null) return null;
              return ResolvedSectionPluginEntry(
                entry: entry,
                state: const PluginRuntimeStateResolver().resolve(
                  plugin,
                  context: context,
                ),
              );
            })
            .whereType<ResolvedSectionPluginEntry>()
            .toList()
          ..sort((a, b) => a.entry.order.compareTo(b.entry.order));
    return entries;
  }
}
