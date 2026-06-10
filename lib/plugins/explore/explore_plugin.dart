import 'package:flutter/material.dart';

import '../../plugin_platform/contracts/plugin_data_requirement.dart';
import '../../plugin_platform/contracts/plugin_entry.dart';
import '../../plugin_platform/contracts/plugin_id.dart';
import '../../plugin_platform/contracts/plugin_placement.dart';
import '../../plugin_platform/contracts/plugin_release_stage.dart';
import '../../plugin_platform/contracts/plugin_route.dart';
import '../../plugin_platform/contracts/smart_feature_plugin.dart';
import '../../plugin_platform/install/plugin_install_context.dart';
import '../../plugin_platform/registry/plugin_registry.dart';
import '../../plugin_platform/runtime/manager/plugin_runtime_start_policy.dart';
import 'application/explore_entry_context_builder.dart';
import 'application/explore_entry_state_refresh_service.dart';
import 'pages/explore_page.dart';
import 'runtime/explore_entry_state_store.dart';
import 'runtime/explore_plugin_runtime.dart';

class ExplorePlugin extends SmartFeaturePlugin {
  const ExplorePlugin();

  @override
  PluginId get id => const PluginId('core.explore');

  @override
  String get title => 'Explore';

  @override
  String get description => 'Container for optional analysis plugins.';

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  Set<PluginPlacement> get placements => const {PluginPlacement.mainTab};

  @override
  Set<PluginDataRequirement> get dataRequirements => const {
    PluginDataRequirement.glucoseReadings,
  };

  @override
  MainTabPluginEntry get mainTabEntry => const MainTabPluginEntry(
    label: 'Explore',
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
    final store = ExploreEntryStateStore();
    final runtime = ExplorePluginRuntime(
      store: store,
      refreshService: ExploreEntryStateRefreshService(
        registry: context.services.get<PluginRegistry>(),
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
