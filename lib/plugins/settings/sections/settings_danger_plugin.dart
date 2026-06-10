import '../../../plugin_platform/contracts/plugin_data_requirement.dart';
import '../../../plugin_platform/contracts/plugin_entry.dart';
import '../../../plugin_platform/contracts/plugin_id.dart';
import '../../../plugin_platform/contracts/plugin_placement.dart';
import '../../../plugin_platform/contracts/plugin_release_stage.dart';
import '../../../plugin_platform/contracts/plugin_route.dart';
import '../../../plugin_platform/contracts/smart_feature_plugin.dart';

class SettingsDangerPlugin extends SmartFeaturePlugin {
  const SettingsDangerPlugin();

  @override
  PluginId get id => const PluginId('settings.danger');

  @override
  String get title => 'Danger Zone';

  @override
  String get description => 'Destructive local data actions.';

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  Set<PluginPlacement> get placements => const {
    PluginPlacement.settingsSection,
  };

  @override
  Set<PluginDataRequirement> get dataRequirements => const {
    PluginDataRequirement.glucoseReadings,
  };

  @override
  SectionPluginEntry get settingsEntry => const SectionPluginEntry(
    section: 'Danger Zone',
    title: 'Danger Zone',
    subtitle: 'Local data reset actions',
    order: 50,
  );

  @override
  List<PluginRoute> get routes => const [];
}
