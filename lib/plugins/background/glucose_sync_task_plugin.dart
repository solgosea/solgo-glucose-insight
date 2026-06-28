import '../../plugin_platform/graph/plugin_slot_key.dart';
import '../../plugin_platform/composition/plugin_placement_spec.dart';
import '../../plugin_platform/contracts/plugin_data_requirement.dart';
import '../../plugin_platform/contracts/plugin_entry.dart';
import '../../plugin_platform/contracts/plugin_id.dart';
import '../../plugin_platform/contracts/plugin_placement.dart';
import '../../plugin_platform/contracts/plugin_release_stage.dart';
import '../../plugin_platform/contracts/plugin_route.dart';
import '../../plugin_platform/contracts/smart_feature_plugin.dart';
import 'application/i18n/background_l10n_resolver.dart';

class GlucoseSyncTaskPlugin extends SmartFeaturePlugin {
  const GlucoseSyncTaskPlugin();

  static final _strings = BackgroundL10nResolver.fallback;

  @override
  PluginId get id => const PluginId('background.glucose_sync');

  @override
  String get title => _strings.glucoseSyncTitle;

  @override
  String get description => _strings.glucoseSyncDescription;

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  Set<PluginPlacement> get placements => const {
        PluginPlacement.backgroundTask,
      };

  @override
  Set<PluginDataRequirement> get dataRequirements => const {
        PluginDataRequirement.sourceConnection,
        PluginDataRequirement.syncStatus,
      };
  @override
  List<PluginPlacementSpec> get placementSpecs => [
        PluginPlacementSpec(
          pluginId: id,
          slot: const PluginSlotKey('app.backgroundTask'),
          renderKey: 'glucose.sync',
          title: _strings.glucoseSyncTitle,
          order: 20,
          dataRequirements: dataRequirements,
        ),
      ];

  @override
  BackgroundTaskPluginEntry get backgroundTaskEntry =>
      BackgroundTaskPluginEntry(
        taskKey: 'glucose.sync',
        title: _strings.glucoseSyncTitle,
        description: _strings.glucoseSyncSubtitle,
        interval: Duration(minutes: 5),
        foregroundService: true,
        order: 20,
      );

  @override
  List<PluginRoute> get routes => const [];
}
