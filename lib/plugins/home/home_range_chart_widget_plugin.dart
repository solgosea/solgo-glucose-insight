import '../../plugin_platform/contracts/plugin_data_requirement.dart';
import '../../plugin_platform/contracts/plugin_entry.dart';
import '../../plugin_platform/contracts/plugin_id.dart';
import '../../plugin_platform/contracts/plugin_placement.dart';
import '../../plugin_platform/contracts/plugin_release_stage.dart';
import '../../plugin_platform/contracts/plugin_route.dart';
import '../../plugin_platform/contracts/smart_feature_plugin.dart';

class HomeRangeChartWidgetPlugin extends SmartFeaturePlugin {
  const HomeRangeChartWidgetPlugin();

  @override
  PluginId get id => const PluginId('home.range_chart');

  @override
  String get title => 'Range Chart';

  @override
  String get description => 'Recent glucose range chart.';

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
    widgetKey: 'home.range_chart',
    title: 'Range Chart',
    description: 'Recent glucose chart',
    order: 30,
  );

  @override
  List<PluginRoute> get routes => const [];
}
