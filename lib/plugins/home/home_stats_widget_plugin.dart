import '../../plugin_platform/contracts/plugin_data_requirement.dart';
import '../../plugin_platform/contracts/plugin_entry.dart';
import '../../plugin_platform/contracts/plugin_id.dart';
import '../../plugin_platform/contracts/plugin_placement.dart';
import '../../plugin_platform/contracts/plugin_release_stage.dart';
import '../../plugin_platform/contracts/plugin_route.dart';
import '../../plugin_platform/contracts/smart_feature_plugin.dart';

class HomeStatsWidgetPlugin extends SmartFeaturePlugin {
  const HomeStatsWidgetPlugin();

  @override
  PluginId get id => const PluginId('home.stats');

  @override
  String get title => 'Home Stats';

  @override
  String get description => 'Compact mean, CV, and event stat row.';

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  Set<PluginPlacement> get placements => const {PluginPlacement.homeWidget};

  @override
  Set<PluginDataRequirement> get dataRequirements => const {
    PluginDataRequirement.glucoseReadings,
    PluginDataRequirement.appSettings,
  };

  @override
  HomeWidgetPluginEntry get homeWidgetEntry => const HomeWidgetPluginEntry(
    widgetKey: 'home.stats',
    title: 'Home Stats',
    description: 'Compact statistics',
    order: 40,
  );

  @override
  List<PluginRoute> get routes => const [];
}
