import '../../plugin_platform/contracts/plugin_data_requirement.dart';
import '../../plugin_platform/contracts/plugin_entry.dart';
import '../../plugin_platform/contracts/plugin_id.dart';
import '../../plugin_platform/contracts/plugin_placement.dart';
import '../../plugin_platform/contracts/plugin_release_stage.dart';
import '../../plugin_platform/contracts/plugin_route.dart';
import '../../plugin_platform/contracts/smart_feature_plugin.dart';

class GlucoseSyncTaskPlugin extends SmartFeaturePlugin {
  const GlucoseSyncTaskPlugin();

  @override
  PluginId get id => const PluginId('background.glucose_sync');

  @override
  String get title => 'Glucose Sync';

  @override
  String get description => 'Synchronizes glucose readings from active source.';

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  Set<PluginPlacement> get placements => const {PluginPlacement.backgroundTask};

  @override
  Set<PluginDataRequirement> get dataRequirements => const {
    PluginDataRequirement.sourceConnection,
    PluginDataRequirement.syncStatus,
  };

  @override
  BackgroundTaskPluginEntry get backgroundTaskEntry =>
      const BackgroundTaskPluginEntry(
        taskKey: 'glucose.sync',
        title: 'Glucose Sync',
        description: 'Fetch, normalize, and persist source glucose readings.',
        interval: Duration(minutes: 5),
        foregroundService: true,
        order: 20,
      );

  @override
  List<PluginRoute> get routes => const [];
}
