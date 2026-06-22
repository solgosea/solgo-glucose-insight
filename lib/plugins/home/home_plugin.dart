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
import 'application/home_host_services.dart';
import 'application/home_snapshot_preheater.dart';
import 'composition/home_slots.dart';
import 'pages/home_page.dart';
import 'runtime/home_plugin_runtime.dart';
import 'runtime/home_runtime_cache.dart';
import 'application/i18n/home_l10n_resolver.dart';
import 'application/i18n/home_entry_localizer.dart';

class HomePlugin extends SmartFeaturePlugin {
  const HomePlugin();

  static final _strings = HomeL10nResolver.fallback;

  @override
  PluginId get id => const PluginId('core.home');

  @override
  String get title => _strings.pluginTitle;

  @override
  String get description => _strings.pluginDescription;

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  PluginNodeKind get nodeKind => PluginNodeKind.container;

  @override
  List<PluginSlot> get slots => HomeSlots.all;

  @override
  Set<PluginPlacement> get placements => const {PluginPlacement.mainTab};

  @override
  Set<PluginDataRequirement> get dataRequirements => const {
        PluginDataRequirement.glucoseReadings,
        PluginDataRequirement.syncStatus,
        PluginDataRequirement.appSettings,
      };
  @override
  List<PluginPlacementSpec> get placementSpecs => [
        PluginPlacementSpec(
          pluginId: id,
          slot: const PluginSlotKey('app.mainTab'),
          renderKey: '/home',
          title: _strings.pluginTitle,
          order: 0,
          dataRequirements: dataRequirements,
        ),
      ];

  @override
  MainTabPluginEntry get mainTabEntry => MainTabPluginEntry(
        label: _strings.pluginTitle,
        route: '/home',
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        order: 0,
      );

  @override
  List<PluginRoute> get routes => [
        PluginRoute(path: '/home', builder: (_) => const HomePage()),
      ];

  @override
  void install(PluginInstallContext context) {
    context.entryLocalizers.register(id, const HomeEntryLocalizer());
    final host = context.services.get<AppHostServices>();
    final actions = context.services.get<AppHostActions>();
    final hostServices = HomeHostServices(
      changeSignal: host.changeSignal,
      syncStatusSnapshot: host.syncStatusSnapshot,
      syncRuntimeStatus: host.syncRuntimeStatus,
      switchToSelfSubject: actions.switchToSelfSubject,
      updateUnit: (unit) {
        final current = host.settingsProvider();
        return actions.updateSettings(current.copyWith(unit: unit));
      },
    );
    final cache = HomeRuntimeCache();
    final runtime = HomePluginRuntime(
      cache: cache,
      preheater: HomeSnapshotPreheater(
        hostServices: hostServices,
      ),
    );
    context.services.register<HomeHostServices>(hostServices);
    context.services.register<HomeRuntimeCache>(cache);
    context.services.register<HomePluginRuntime>(runtime);
    context.registerRuntime(
      runtime,
      startPolicy: PluginRuntimeStartPolicy.appStart,
    );
  }
}
