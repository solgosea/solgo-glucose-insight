import '../../plugin_platform/contracts/plugin_data_requirement.dart';
import '../../plugin_platform/contracts/plugin_entry.dart';
import '../../plugin_platform/contracts/plugin_id.dart';
import '../../plugin_platform/contracts/plugin_placement.dart';
import '../../plugin_platform/contracts/plugin_release_stage.dart';
import '../../plugin_platform/contracts/plugin_route.dart';
import '../../plugin_platform/contracts/smart_feature_plugin.dart';

class HomeHeroWidgetPlugin extends SmartFeaturePlugin {
  const HomeHeroWidgetPlugin();

  @override
  PluginId get id => const PluginId('home.hero_glucose');

  @override
  String get title => 'Current Glucose';

  @override
  String get description => 'Latest glucose value and trend summary.';

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
    widgetKey: 'home.hero_glucose',
    title: 'Current Glucose',
    description: 'Latest glucose value',
    order: 20,
  );

  @override
  List<PluginRoute> get routes => const [];
}
