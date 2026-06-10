import '../../plugin_platform/contracts/plugin_data_requirement.dart';
import '../../plugin_platform/contracts/plugin_entry.dart';
import '../../plugin_platform/contracts/plugin_id.dart';
import '../../plugin_platform/contracts/plugin_placement.dart';
import '../../plugin_platform/contracts/plugin_release_stage.dart';
import '../../plugin_platform/contracts/plugin_route.dart';
import '../../plugin_platform/contracts/smart_feature_plugin.dart';

class HomeHeaderWidgetPlugin extends SmartFeaturePlugin {
  const HomeHeaderWidgetPlugin();

  @override
  PluginId get id => const PluginId('home.header');

  @override
  String get title => 'Home Header';

  @override
  String get description => 'Home title and active sync status.';

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  Set<PluginPlacement> get placements => const {PluginPlacement.homeWidget};

  @override
  Set<PluginDataRequirement> get dataRequirements => const {
    PluginDataRequirement.syncStatus,
  };

  @override
  HomeWidgetPluginEntry get homeWidgetEntry => const HomeWidgetPluginEntry(
    widgetKey: 'home.header',
    title: 'Home Header',
    description: 'Title and sync status chip',
    order: 10,
  );

  @override
  List<PluginRoute> get routes => const [];
}
