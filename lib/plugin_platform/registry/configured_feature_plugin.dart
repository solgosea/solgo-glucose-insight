import '../contracts/plugin_capability.dart';
import '../contracts/plugin_data_requirement.dart';
import '../contracts/plugin_entry.dart';
import '../contracts/plugin_id.dart';
import '../contracts/plugin_placement.dart';
import '../contracts/plugin_release_stage.dart';
import '../contracts/plugin_route.dart';
import '../contracts/smart_feature_plugin.dart';
import '../composition/plugin_placement_spec.dart';
import '../graph/plugin_node.dart';
import '../graph/plugin_node_kind.dart';
import '../graph/plugin_slot.dart';

class ConfiguredFeaturePlugin extends SmartFeaturePlugin {
  final SmartFeaturePlugin delegate;
  final PluginReleaseStage _releaseStage;

  const ConfiguredFeaturePlugin({
    required this.delegate,
    required PluginReleaseStage releaseStage,
  }) : _releaseStage = releaseStage;

  @override
  PluginId get id => delegate.id;

  @override
  String get title => delegate.title;

  @override
  String get description => delegate.description;

  @override
  PluginReleaseStage get releaseStage => _releaseStage;

  @override
  Set<PluginPlacement> get placements => delegate.placements;

  @override
  Set<PluginDataRequirement> get dataRequirements => delegate.dataRequirements;

  @override
  List<PluginRoute> get routes => delegate.routes;

  @override
  PluginNodeKind get nodeKind => delegate.nodeKind;

  @override
  List<PluginSlot> get slots => delegate.slots;

  @override
  List<PluginPlacementSpec> get placementSpecs => delegate.placementSpecs;

  @override
  PluginNode get node => delegate.node;

  @override
  MainTabPluginEntry? get mainTabEntry =>
      delegate.mainTabEntry?.copyWith(pluginId: id.value);

  @override
  ExplorePluginEntry? get exploreEntry =>
      delegate.exploreEntry?.copyWith(pluginId: id.value);

  @override
  SectionPluginEntry? get profileEntry =>
      delegate.profileEntry?.copyWith(pluginId: id.value);

  @override
  SectionPluginEntry? get settingsEntry =>
      delegate.settingsEntry?.copyWith(pluginId: id.value);

  @override
  HomeWidgetPluginEntry? get homeWidgetEntry =>
      delegate.homeWidgetEntry?.copyWith(pluginId: id.value);

  @override
  BackgroundTaskPluginEntry? get backgroundTaskEntry =>
      delegate.backgroundTaskEntry?.copyWith(pluginId: id.value);

  @override
  PluginCapability capability(PluginCapabilityContext context) {
    return PluginCapability.fromReleaseStage(releaseStage);
  }
}
