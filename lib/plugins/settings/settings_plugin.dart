import '../../plugin_platform/contracts/plugin_data_requirement.dart';
import '../../plugin_platform/contracts/plugin_entry.dart';
import '../../plugin_platform/contracts/plugin_id.dart';
import '../../plugin_platform/contracts/plugin_placement.dart';
import '../../plugin_platform/contracts/plugin_release_stage.dart';
import '../../plugin_platform/contracts/plugin_route.dart';
import '../../plugin_platform/contracts/smart_feature_plugin.dart';
import '../../plugin_platform/composition/plugin_placement_spec.dart';
import '../../application/plugin_host/app_host_actions.dart';
import '../../application/plugin_host/app_host_services.dart';
import '../../plugin_platform/graph/plugin_node_kind.dart';
import '../../plugin_platform/graph/plugin_slot.dart';
import '../../plugin_platform/install/plugin_install_context.dart';
import '../../plugin_platform/runtime/manager/plugin_runtime_start_policy.dart';
import 'application/settings_actions.dart';
import 'application/settings_export_actions.dart';
import 'application/settings_host_services.dart';
import 'application/settings_snapshot_preheater.dart';
import 'application/settings_storage_actions.dart';
import '../profile/composition/profile_slots.dart';
import 'composition/settings_slots.dart';
import 'pages/settings_page.dart';
import 'runtime/settings_plugin_runtime.dart';
import 'runtime/settings_runtime_cache.dart';
import 'application/i18n/settings_l10n_resolver.dart';
import 'application/i18n/settings_entry_localizer.dart';

class SettingsPlugin extends SmartFeaturePlugin {
  const SettingsPlugin();

  static final _strings = SettingsL10nResolver.fallback;

  @override
  PluginId get id => const PluginId('core.settings');

  @override
  String get title => _strings.pluginTitle;

  @override
  String get description => _strings.pluginDescription;

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  PluginNodeKind get nodeKind => PluginNodeKind.container;

  @override
  List<PluginSlot> get slots => SettingsSlots.all;

  @override
  Set<PluginPlacement> get placements => const {PluginPlacement.profileSection};

  @override
  Set<PluginDataRequirement> get dataRequirements =>
      const {PluginDataRequirement.appSettings};

  @override
  List<PluginPlacementSpec> get placementSpecs => [
        PluginPlacementSpec(
          pluginId: id,
          slot: ProfileSlots.section,
          renderKey: 'App Settings',
          title: _strings.pluginTitle,
          order: 40,
          dataRequirements: dataRequirements,
        ),
      ];

  @override
  SectionPluginEntry get profileEntry => SectionPluginEntry(
        section: 'App Settings',
        title: _strings.pluginTitle,
        subtitle: _strings.pluginTitle,
        order: 40,
      );

  @override
  List<PluginRoute> get routes => [
        PluginRoute(
          path: '/settings',
          builder: (_) => const SettingsPage(),
        ),
      ];

  @override
  void install(PluginInstallContext context) {
    context.entryLocalizers.register(id, const SettingsEntryLocalizer());
    final host = context.services.get<AppHostServices>();
    final actions = context.services.get<AppHostActions>();
    final hostServices = SettingsHostServices(
      changeSignal: host.changeSignal,
      settingsProvider: host.settingsProvider,
      databaseFileSizeBytes: host.databaseFileSizeBytes,
      readingsForDays: host.readingsForDays,
    );
    final cache = SettingsRuntimeCache();
    final runtime = SettingsPluginRuntime(
      cache: cache,
      preheater: SettingsSnapshotPreheater(
        hostServices: hostServices,
      ),
    );
    context.services.register<SettingsHostServices>(hostServices);
    context.services.register<SettingsActions>(
      SettingsActions(
        settingsProvider: host.settingsProvider,
        updateSettings: actions.updateSettings,
      ),
    );
    context.services.register<SettingsStorageActions>(
      SettingsStorageActions(clearAllData: actions.clearAllData),
    );
    context.services.register<SettingsExportActions>(
      SettingsExportActions(hostServices: hostServices),
    );
    context.services.register<SettingsRuntimeCache>(cache);
    context.services.register<SettingsPluginRuntime>(runtime);
    context.registerRuntime(
      runtime,
      startPolicy: PluginRuntimeStartPolicy.onEnter,
    );
  }
}
