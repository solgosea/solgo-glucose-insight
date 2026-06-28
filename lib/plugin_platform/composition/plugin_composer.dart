import '../contracts/plugin_capability.dart';
import '../graph/plugin_slot_key.dart';
import '../registry/plugin_registry.dart';
import '../registry/plugin_catalog_composer.dart';
import 'plugin_composition_registry.dart';
import 'plugin_composition_result.dart';

class PluginComposer {
  final PluginRegistry registry;
  final PluginCompositionRegistry compositionRegistry;
  final PluginCatalogComposer catalogComposer;

  const PluginComposer({
    required this.registry,
    required this.compositionRegistry,
    this.catalogComposer = const PluginCatalogComposer(),
  });

  PluginCompositionResult composeSlot(
    PluginSlotKey slot, {
    PluginCapabilityContext context = const PluginCapabilityContext(),
  }) {
    final visibleIds =
        registry.visible(context: context).map((plugin) => plugin.id).toSet();
    final renderables = compositionRegistry
        .renderablesFor(slot)
        .where((renderable) => visibleIds.contains(renderable.pluginId))
        .toList(growable: false);
    return PluginCompositionResult(renderables: renderables);
  }

  PluginCompositionResult composePlacementSlot(
    PluginSlotKey slot, {
    PluginCapabilityContext context = const PluginCapabilityContext(),
  }) {
    final visibleIds =
        registry.visible(context: context).map((plugin) => plugin.id).toSet();
    final placements = catalogComposer
        .placementsFor(registry.all)
        .where((placement) => placement.slot == slot)
        .where((placement) => placement.enabled)
        .where((placement) => visibleIds.contains(placement.pluginId))
        .toList(growable: false);
    placements.sort((a, b) => a.order.compareTo(b.order));
    return PluginCompositionResult(placements: placements);
  }
}
