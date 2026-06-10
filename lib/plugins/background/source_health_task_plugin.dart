import '../../plugin_platform/contracts/plugin_data_requirement.dart';
import '../../plugin_platform/contracts/plugin_entry.dart';
import '../../plugin_platform/contracts/plugin_id.dart';
import '../../plugin_platform/contracts/plugin_placement.dart';
import '../../plugin_platform/contracts/plugin_release_stage.dart';
import '../../plugin_platform/contracts/plugin_route.dart';
import '../../plugin_platform/contracts/smart_feature_plugin.dart';

class SourceHealthTaskPlugin extends SmartFeaturePlugin {
  const SourceHealthTaskPlugin();

  @override
  PluginId get id => const PluginId('background.source_health');

  @override
  String get title => 'Source Health Check';

  @override
  String get description =>
      'Checks the active xDrip or Nightscout source reachability.';

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  Set<PluginPlacement> get placements => const {PluginPlacement.backgroundTask};

  @override
  Set<PluginDataRequirement> get dataRequirements => const {
    PluginDataRequirement.sourceConnection,
  };

  @override
  BackgroundTaskPluginEntry get backgroundTaskEntry =>
      const BackgroundTaskPluginEntry(
        taskKey: 'source.health_check',
        title: 'Source Health Check',
        description: 'Validate active data source availability.',
        interval: Duration(minutes: 2),
        foregroundService: true,
        order: 10,
      );

  @override
  List<PluginRoute> get routes => const [];
}
