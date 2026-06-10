import 'plugin_capability.dart';
import 'plugin_data_requirement.dart';
import 'plugin_entry.dart';
import 'plugin_id.dart';
import 'plugin_manifest.dart';
import 'plugin_placement.dart';
import 'plugin_release_stage.dart';
import 'plugin_route.dart';
import '../install/plugin_install_context.dart';
import '../../application/background_capability/background_capability_contributor.dart';

abstract class SmartFeaturePlugin {
  const SmartFeaturePlugin();

  PluginId get id;

  String get title;

  String get description;

  PluginReleaseStage get releaseStage;

  Set<PluginPlacement> get placements;

  Set<PluginDataRequirement> get dataRequirements;

  List<PluginRoute> get routes;

  PluginManifest get manifest => PluginManifest(
    id: id,
    title: title,
    description: description,
    releaseStage: releaseStage,
    placements: placements,
    dataRequirements: dataRequirements,
  );

  MainTabPluginEntry? get mainTabEntry => null;

  ExplorePluginEntry? get exploreEntry => null;

  SectionPluginEntry? get profileEntry => null;

  SectionPluginEntry? get settingsEntry => null;

  HomeWidgetPluginEntry? get homeWidgetEntry => null;

  BackgroundTaskPluginEntry? get backgroundTaskEntry => null;

  BackgroundCapabilityContributor? get backgroundCapabilityContributor => null;

  void install(PluginInstallContext context) {}

  PluginCapability capability(PluginCapabilityContext context) =>
      PluginCapability.fromReleaseStage(releaseStage);
}
