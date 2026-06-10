import '../../../plugin_platform/contracts/plugin_data_requirement.dart';
import '../../../plugin_platform/contracts/plugin_entry.dart';
import '../../../plugin_platform/contracts/plugin_id.dart';
import '../../../plugin_platform/contracts/plugin_placement.dart';
import '../../../plugin_platform/contracts/plugin_release_stage.dart';
import '../../../plugin_platform/contracts/plugin_route.dart';
import '../../../plugin_platform/contracts/smart_feature_plugin.dart';

class SettingsAboutPlugin extends SmartFeaturePlugin {
  const SettingsAboutPlugin();

  @override
  PluginId get id => const PluginId('settings.about');

  @override
  String get title => 'About';

  @override
  String get description => 'Application metadata and support links.';

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  Set<PluginPlacement> get placements => const {
    PluginPlacement.settingsSection,
  };

  @override
  Set<PluginDataRequirement> get dataRequirements => const {};

  @override
  SectionPluginEntry get settingsEntry => const SectionPluginEntry(
    section: 'About',
    title: 'About',
    subtitle: 'Application information',
    order: 60,
  );

  @override
  List<PluginRoute> get routes => const [];
}
