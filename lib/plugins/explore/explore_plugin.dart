import 'package:smart_xdrip/plugin_platform/graph/plugin_slot_key.dart';
import 'package:smart_xdrip/plugin_platform/composition/plugin_placement_spec.dart';
import 'package:flutter/material.dart';

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
import '../../plugin_platform/registry/plugin_registry.dart';
import '../../plugin_platform/runtime/manager/plugin_runtime_start_policy.dart';
import 'application/explore_entry_context_builder.dart';
import 'application/explore_entry_state_refresh_service.dart';
import 'composition/explore_slots.dart';
import 'pages/explore_page.dart';
import 'runtime/explore_entry_state_store.dart';
import 'runtime/explore_plugin_runtime.dart';
import 'application/i18n/explore_l10n_resolver.dart';
import 'application/i18n/explore_entry_localizer.dart';

class ExplorePlugin extends SmartFeaturePlugin {
  const ExplorePlugin();

  static final _strings = ExploreL10nResolver.fallback;

  @override
  PluginId get id => const PluginId('core.explore');

  @override
  String get title => _strings.pluginTitle;

  @override
  String get description => _strings.pluginDescription;

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  PluginNodeKind get nodeKind => PluginNodeKind.container;

  @override
  List<PluginSlot> get slots => ExploreSlots.all;

  @override
  Set<PluginPlacement> get placements => const {PluginPlacement.mainTab};

  @override
  Set<PluginDataRequirement> get dataRequirements =>
      const {PluginDataRequirement.glucoseReadings};
  @override
  List<PluginPlacementSpec> get placementSpecs => [
        PluginPlacementSpec(
          pluginId: id,
          slot: const PluginSlotKey('app.mainTab'),
          renderKey: '/explore',
          title: _strings.pluginTitle,
          order: 30,
          dataRequirements: dataRequirements,
        ),
      ];

  @override
  MainTabPluginEntry get mainTabEntry => MainTabPluginEntry(
        label: _strings.pluginTitle,
        route: '/explore',
        icon: Icons.search_outlined,
        activeIcon: Icons.search,
        order: 30,
      );

  @override
  List<PluginRoute> get routes => [
        PluginRoute(path: '/explore', builder: (_) => const ExplorePage()),
      ];

  @override
  void install(PluginInstallContext context) {
    context.entryLocalizers.register(id, const ExploreEntryLocalizer());
    final store = ExploreEntryStateStore();
    final runtime = ExplorePluginRuntime(
      store: store,
      refreshService: ExploreEntryStateRefreshService(
        registry: context.services.get<PluginRegistry>(),
        compositionRegistry: context.compositionRegistry,
        contextBuilder: ExploreEntryContextBuilder.current(),
      ),
    );
    context.services.register<ExploreEntryStateStore>(store);
    context.services.register<ExplorePluginRuntime>(runtime);
    context.registerRuntime(
      runtime,
      startPolicy: PluginRuntimeStartPolicy.appStart,
    );
  }
}
