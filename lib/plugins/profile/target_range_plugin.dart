import '../../plugin_platform/contracts/plugin_data_requirement.dart';
import '../../plugin_platform/contracts/plugin_entry.dart';
import '../../plugin_platform/contracts/plugin_id.dart';
import '../../plugin_platform/contracts/plugin_placement.dart';
import '../../plugin_platform/contracts/plugin_release_stage.dart';
import '../../plugin_platform/contracts/plugin_route.dart';
import '../../plugin_platform/contracts/smart_feature_plugin.dart';

class TargetRangePlugin extends SmartFeaturePlugin {
  const TargetRangePlugin();

  @override
  PluginId get id => const PluginId('profile.target_range');

  @override
  String get title => 'Target Range';

  @override
  String get description => 'Personal glucose target range thresholds.';

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  Set<PluginPlacement> get placements => const {PluginPlacement.profileSection};

  @override
  Set<PluginDataRequirement> get dataRequirements => const {
    PluginDataRequirement.appSettings,
  };

  @override
  SectionPluginEntry get profileEntry => const SectionPluginEntry(
    section: 'Target Range',
    title: 'Target Range',
    subtitle: 'Low, high, and very high thresholds',
    order: 30,
  );

  @override
  List<PluginRoute> get routes => const [];
}
