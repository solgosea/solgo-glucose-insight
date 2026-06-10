import '../../../plugin_platform/contracts/plugin_data_requirement.dart';
import '../../../plugin_platform/contracts/plugin_entry.dart';
import '../../../plugin_platform/contracts/plugin_id.dart';
import '../../../plugin_platform/contracts/plugin_placement.dart';
import '../../../plugin_platform/contracts/plugin_release_stage.dart';
import '../../../plugin_platform/contracts/plugin_route.dart';
import '../../../plugin_platform/contracts/smart_feature_plugin.dart';

class SettingsStoragePlugin extends SmartFeaturePlugin {
  const SettingsStoragePlugin();

  @override
  PluginId get id => const PluginId('settings.storage');

  @override
  String get title => 'Data Storage';

  @override
  String get description => 'Local glucose data storage summary.';

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  Set<PluginPlacement> get placements => const {
    PluginPlacement.settingsSection,
  };

  @override
  Set<PluginDataRequirement> get dataRequirements => const {
    PluginDataRequirement.glucoseReadings,
    PluginDataRequirement.appSettings,
  };

  @override
  SectionPluginEntry get settingsEntry => const SectionPluginEntry(
    section: 'Data Storage',
    title: 'Data Storage',
    subtitle: 'Local storage usage',
    order: 30,
  );

  @override
  List<PluginRoute> get routes => const [];
}
