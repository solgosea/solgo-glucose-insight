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

class SourceHealthTaskPlugin extends SmartFeaturePlugin {
  const SourceHealthTaskPlugin();

  static final _strings = BackgroundL10nResolver.fallback;

  @override
  PluginId get id => const PluginId('background.source_health');

  @override
  String get title => _strings.sourceHealthTitle;

  @override
  String get description => _strings.sourceHealthDescription;

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  Set<PluginPlacement> get placements => const {
        PluginPlacement.backgroundTask,
      };

  @override
  Set<PluginDataRequirement> get dataRequirements => const {
        PluginDataRequirement.sourceConnection,
      };
  @override
  List<PluginPlacementSpec> get placementSpecs => [
        PluginPlacementSpec(
          pluginId: id,
          slot: const PluginSlotKey('app.backgroundTask'),
          renderKey: 'source.health_check',
          title: _strings.sourceHealthTitle,
          order: 10,
          dataRequirements: dataRequirements,
        ),
      ];

  @override
  BackgroundTaskPluginEntry get backgroundTaskEntry =>
      BackgroundTaskPluginEntry(
        taskKey: 'source.health_check',
        title: _strings.sourceHealthTitle,
        description: _strings.sourceHealthSubtitle,
        interval: Duration(minutes: 2),
        foregroundService: true,
        order: 10,
      );

  @override
  List<PluginRoute> get routes => const [];
}
