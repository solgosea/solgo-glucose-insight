import '../../../plugin_platform/contracts/plugin_data_requirement.dart';
import '../../../plugin_platform/contracts/plugin_entry.dart';
import '../../../plugin_platform/contracts/plugin_id.dart';
import '../../../plugin_platform/contracts/plugin_placement.dart';
import '../../../plugin_platform/contracts/plugin_release_stage.dart';
import '../../../plugin_platform/contracts/plugin_route.dart';
import '../../../plugin_platform/contracts/smart_feature_plugin.dart';

class SettingsExportPlugin extends SmartFeaturePlugin {
  const SettingsExportPlugin();

  @override
  PluginId get id => const PluginId('settings.export');

  @override
  String get title => 'Data Export';

  @override
  String get description => 'Export local glucose data.';

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
    section: 'Data Export',
    title: 'Data Export',
    subtitle: 'Export local data files',
    order: 40,
  );

  @override
  List<PluginRoute> get routes => const [];
}
