import 'package:flutter/material.dart';

import '../../plugin_platform/contracts/plugin_data_requirement.dart';
import '../../plugin_platform/contracts/plugin_entry.dart';
import '../../plugin_platform/contracts/plugin_id.dart';
import '../../plugin_platform/contracts/plugin_placement.dart';
import '../../plugin_platform/contracts/plugin_release_stage.dart';
import '../../plugin_platform/contracts/plugin_route.dart';
import '../../plugin_platform/contracts/smart_feature_plugin.dart';
import '../../plugin_platform/install/plugin_install_context.dart';
import '../../plugin_platform/runtime/manager/plugin_runtime_start_policy.dart';
import 'application/home_host_services.dart';
import 'application/home_snapshot_preheater.dart';
import 'pages/home_page.dart';
import 'runtime/home_plugin_runtime.dart';
import 'runtime/home_runtime_cache.dart';

class HomePlugin extends SmartFeaturePlugin {
  const HomePlugin();

  @override
  PluginId get id => const PluginId('core.home');

  @override
  String get title => 'Home';

  @override
  String get description => 'Current glucose overview and sync status.';

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  Set<PluginPlacement> get placements => const {PluginPlacement.mainTab};

  @override
  Set<PluginDataRequirement> get dataRequirements => const {
    PluginDataRequirement.glucoseReadings,
    PluginDataRequirement.syncStatus,
    PluginDataRequirement.appSettings,
  };

  @override
  MainTabPluginEntry get mainTabEntry => const MainTabPluginEntry(
    label: 'Home',
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
    final cache = HomeRuntimeCache();
    final runtime = HomePluginRuntime(
      cache: cache,
      preheater: HomeSnapshotPreheater(
        hostServices: context.services.get<HomeHostServices>(),
      ),
    );
    context.services.register<HomeRuntimeCache>(cache);
    context.services.register<HomePluginRuntime>(runtime);
    context.registerRuntime(
      runtime,
      startPolicy: PluginRuntimeStartPolicy.appStart,
    );
  }
}
