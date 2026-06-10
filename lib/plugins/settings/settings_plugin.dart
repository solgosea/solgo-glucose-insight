import '../../plugin_platform/contracts/plugin_data_requirement.dart';
import '../../plugin_platform/contracts/plugin_entry.dart';
import '../../plugin_platform/contracts/plugin_id.dart';
import '../../plugin_platform/contracts/plugin_placement.dart';
import '../../plugin_platform/contracts/plugin_release_stage.dart';
import '../../plugin_platform/contracts/plugin_route.dart';
import '../../plugin_platform/contracts/smart_feature_plugin.dart';
import '../../plugin_platform/install/plugin_install_context.dart';
import '../../plugin_platform/runtime/manager/plugin_runtime_start_policy.dart';
import 'application/settings_host_services.dart';
import 'application/settings_snapshot_preheater.dart';
import 'pages/settings_page.dart';
import 'runtime/settings_plugin_runtime.dart';
import 'runtime/settings_runtime_cache.dart';

class SettingsPlugin extends SmartFeaturePlugin {
  const SettingsPlugin();

  @override
  PluginId get id => const PluginId('core.settings');

  @override
  String get title => 'Settings';

  @override
  String get description => 'Display, sync, storage, and export settings.';

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
    section: 'App Settings',
    title: 'Settings',
    subtitle: 'Display, sync window, storage, export',
    order: 40,
  );

  @override
  List<PluginRoute> get routes => [
    PluginRoute(path: '/settings', builder: (_) => const SettingsPage()),
  ];

  @override
  void install(PluginInstallContext context) {
    final cache = SettingsRuntimeCache();
    final runtime = SettingsPluginRuntime(
      cache: cache,
      preheater: SettingsSnapshotPreheater(
        hostServices: context.services.get<SettingsHostServices>(),
      ),
    );
    context.services.register<SettingsRuntimeCache>(cache);
    context.services.register<SettingsPluginRuntime>(runtime);
    context.registerRuntime(
      runtime,
      startPolicy: PluginRuntimeStartPolicy.onEnter,
    );
  }
}
