import '../../../plugin_platform/contracts/plugin_data_requirement.dart';
import '../../../plugin_platform/contracts/plugin_entry.dart';
import '../../../plugin_platform/contracts/plugin_id.dart';
import '../../../plugin_platform/contracts/plugin_placement.dart';
import '../../../plugin_platform/contracts/plugin_release_stage.dart';
import '../../../plugin_platform/contracts/plugin_route.dart';
import '../../../plugin_platform/contracts/smart_feature_plugin.dart';

class SettingsSyncPlugin extends SmartFeaturePlugin {
  const SettingsSyncPlugin();

  @override
  PluginId get id => const PluginId('settings.sync');

  @override
  String get title => 'Sync Settings';

  @override
  String get description => 'Initial sync window and source sync preferences.';

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  Set<PluginPlacement> get placements => const {
    PluginPlacement.settingsSection,
  };

  @override
  Set<PluginDataRequirement> get dataRequirements => const {
    PluginDataRequirement.appSettings,
    PluginDataRequirement.syncStatus,
  };

  @override
  SectionPluginEntry get settingsEntry => const SectionPluginEntry(
    section: 'Sync Settings',
    title: 'Sync Settings',
    subtitle: 'Source sync behavior',
    order: 20,
  );

  @override
  List<PluginRoute> get routes => const [];
}
