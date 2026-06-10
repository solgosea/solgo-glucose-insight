import '../../plugin_platform/contracts/plugin_data_requirement.dart';
import '../../plugin_platform/contracts/plugin_entry.dart';
import '../../plugin_platform/contracts/plugin_id.dart';
import '../../plugin_platform/contracts/plugin_placement.dart';
import '../../plugin_platform/contracts/plugin_release_stage.dart';
import '../../plugin_platform/contracts/plugin_route.dart';
import '../../plugin_platform/contracts/smart_feature_plugin.dart';

class HomeTirWidgetPlugin extends SmartFeaturePlugin {
  const HomeTirWidgetPlugin();

  @override
  PluginId get id => const PluginId('home.tir');

  @override
  String get title => 'Time In Range';

  @override
  String get description => 'Time-in-range summary for the current view.';

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
    widgetKey: 'home.tir',
    title: 'Time In Range',
    description: 'TIR section',
    order: 50,
  );

  @override
  List<PluginRoute> get routes => const [];
}
