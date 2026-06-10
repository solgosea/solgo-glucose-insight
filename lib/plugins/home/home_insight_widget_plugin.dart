import '../../plugin_platform/contracts/plugin_data_requirement.dart';
import '../../plugin_platform/contracts/plugin_entry.dart';
import '../../plugin_platform/contracts/plugin_id.dart';
import '../../plugin_platform/contracts/plugin_placement.dart';
import '../../plugin_platform/contracts/plugin_release_stage.dart';
import '../../plugin_platform/contracts/plugin_route.dart';
import '../../plugin_platform/contracts/smart_feature_plugin.dart';

class HomeInsightWidgetPlugin extends SmartFeaturePlugin {
  const HomeInsightWidgetPlugin();

  @override
  PluginId get id => const PluginId('home.insight');

  @override
  String get title => 'Home Insight';

  @override
  String get description => 'Compact generated insight entry point.';

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  Set<PluginPlacement> get placements => const {PluginPlacement.homeWidget};

  @override
  Set<PluginDataRequirement> get dataRequirements => const {
    PluginDataRequirement.glucoseReadings,
    PluginDataRequirement.dailySummaries,
  };

  @override
  HomeWidgetPluginEntry get homeWidgetEntry => const HomeWidgetPluginEntry(
    widgetKey: 'home.insight',
    title: 'Home Insight',
    description: 'Insight banner',
    order: 60,
  );

  @override
  List<PluginRoute> get routes => const [];
}
