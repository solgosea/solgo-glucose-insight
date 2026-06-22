import 'package:smart_xdrip/plugin_platform/graph/plugin_slot_key.dart';
import 'package:smart_xdrip/plugin_platform/composition/plugin_placement_spec.dart';
import 'package:flutter/material.dart';

import '../../application/plugin_host/app_host_actions.dart';
import '../../application/plugin_host/app_host_services.dart';
import '../../plugin_platform/contracts/plugin_data_requirement.dart';
import '../../plugin_platform/contracts/plugin_entry.dart';
import '../../plugin_platform/contracts/plugin_id.dart';
import '../../plugin_platform/contracts/plugin_placement.dart';
import '../../plugin_platform/contracts/plugin_release_stage.dart';
import '../../plugin_platform/contracts/plugin_route.dart';
import '../../plugin_platform/contracts/smart_feature_plugin.dart';
import '../../plugin_platform/graph/plugin_node_kind.dart';
import '../../plugin_platform/graph/plugin_slot.dart';
import '../../plugin_platform/install/plugin_install_context.dart';
import '../../plugin_platform/runtime/manager/plugin_runtime_start_policy.dart';
import 'application/profile_host_services.dart';
import 'application/profile_settings_actions.dart';
import 'application/profile_snapshot_preheater.dart';
import 'composition/profile_slots.dart';
import 'pages/profile_page.dart';
import 'runtime/profile_plugin_runtime.dart';
import 'runtime/profile_runtime_cache.dart';
import 'application/i18n/profile_entry_localizer.dart';
import 'application/i18n/profile_l10n_resolver.dart';

class ProfilePlugin extends SmartFeaturePlugin {
  const ProfilePlugin();

  static final _strings = ProfileL10nResolver.fallback;

  @override
  PluginId get id => const PluginId('core.profile');

  @override
  String get title => _strings.pluginTitle;

  @override
  String get description => _strings.pluginDescription;

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  PluginNodeKind get nodeKind => PluginNodeKind.container;

  @override
  List<PluginSlot> get slots => ProfileSlots.all;

  @override
  Set<PluginPlacement> get placements => const {PluginPlacement.mainTab};

  @override
  Set<PluginDataRequirement> get dataRequirements => const {
        PluginDataRequirement.appSettings,
        PluginDataRequirement.sourceConnection,
      };
  @override
  List<PluginPlacementSpec> get placementSpecs => [
        PluginPlacementSpec(
          pluginId: id,
          slot: const PluginSlotKey('app.mainTab'),
          renderKey: '/profile',
          title: _strings.pluginTitle,
          order: 40,
          dataRequirements: dataRequirements,
        ),
      ];

  @override
  MainTabPluginEntry get mainTabEntry => MainTabPluginEntry(
        label: _strings.pluginTitle,
        route: '/profile',
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        order: 40,
      );

  @override
  List<PluginRoute> get routes => [
        PluginRoute(path: '/profile', builder: (_) => const ProfilePage()),
      ];

  @override
  void install(PluginInstallContext context) {
    context.entryLocalizers.register(id, const ProfileEntryLocalizer());
    final host = context.services.get<AppHostServices>();
    final actions = context.services.get<AppHostActions>();
    final hostServices = ProfileHostServices(
      changeSignal: host.changeSignal,
      facadeProvider: host.facadeProvider,
      settingsProvider: host.settingsProvider,
    );
    final cache = ProfileRuntimeCache();
    final runtime = ProfilePluginRuntime(
      cache: cache,
      preheater: ProfileSnapshotPreheater(
        hostServices: hostServices,
      ),
    );
    context.services.register<ProfileHostServices>(hostServices);
    context.services.register<ProfileSettingsActions>(
      ProfileSettingsActions(
        updateSettings: actions.updateSettings,
        settingsProvider: host.settingsProvider,
      ),
    );
    context.services.register<ProfileRuntimeCache>(cache);
    context.services.register<ProfilePluginRuntime>(runtime);
    context.registerRuntime(
      runtime,
      startPolicy: PluginRuntimeStartPolicy.onEnter,
    );
  }
}
