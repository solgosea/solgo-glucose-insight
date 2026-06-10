import '../contracts/plugin_capability.dart';
import '../contracts/plugin_data_requirement.dart';
import '../contracts/plugin_entry.dart';
import '../contracts/plugin_id.dart';
import '../contracts/plugin_placement.dart';
import '../contracts/plugin_release_stage.dart';
import '../contracts/plugin_route.dart';
import '../contracts/smart_feature_plugin.dart';

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
  MainTabPluginEntry? get mainTabEntry => delegate.mainTabEntry;

  @override
  ExplorePluginEntry? get exploreEntry => delegate.exploreEntry;

  @override
  SectionPluginEntry? get profileEntry => delegate.profileEntry;

  @override
  SectionPluginEntry? get settingsEntry => delegate.settingsEntry;

  @override
  HomeWidgetPluginEntry? get homeWidgetEntry => delegate.homeWidgetEntry;

  @override
  BackgroundTaskPluginEntry? get backgroundTaskEntry =>
      delegate.backgroundTaskEntry;

  @override
  PluginCapability capability(PluginCapabilityContext context) {
    return PluginCapability.fromReleaseStage(releaseStage);
  }
}
