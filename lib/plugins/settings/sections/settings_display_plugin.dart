import '../../../plugin_platform/contracts/plugin_data_requirement.dart';
import '../../../plugin_platform/contracts/plugin_entry.dart';
import '../../../plugin_platform/contracts/plugin_id.dart';
import '../../../plugin_platform/contracts/plugin_placement.dart';
import '../../../plugin_platform/contracts/plugin_release_stage.dart';
import '../../../plugin_platform/contracts/plugin_route.dart';
import '../../../plugin_platform/contracts/smart_feature_plugin.dart';

class SettingsDisplayPlugin extends SmartFeaturePlugin {
  const SettingsDisplayPlugin();

  @override
  PluginId get id => const PluginId('settings.display');

  @override
  String get title => 'Display';

  @override
  String get description => 'Display preferences for glucose units.';

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  Set<PluginPlacement> get placements => const {
    PluginPlacement.settingsSection,
  };

  @override
  Set<PluginDataRequirement> get dataRequirements => const {
    PluginDataRequirement.appSettings,
  };

  @override
  SectionPluginEntry get settingsEntry => const SectionPluginEntry(
    section: 'Display',
    title: 'Display',
    subtitle: 'Units and presentation preferences',
    order: 10,
  );

  @override
  List<PluginRoute> get routes => const [];
}
