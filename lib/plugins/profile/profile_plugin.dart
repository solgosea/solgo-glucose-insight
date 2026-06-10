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
import 'application/profile_host_services.dart';
import 'application/profile_snapshot_preheater.dart';
import 'pages/profile_page.dart';
import 'runtime/profile_plugin_runtime.dart';
import 'runtime/profile_runtime_cache.dart';

class ProfilePlugin extends SmartFeaturePlugin {
  const ProfilePlugin();

  @override
  PluginId get id => const PluginId('core.profile');

  @override
  String get title => 'Profile';

  @override
  String get description => 'Profile, data source, target range, and settings.';

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  Set<PluginPlacement> get placements => const {PluginPlacement.mainTab};

  @override
  Set<PluginDataRequirement> get dataRequirements => const {
    PluginDataRequirement.appSettings,
    PluginDataRequirement.sourceConnection,
  };

  @override
  MainTabPluginEntry get mainTabEntry => const MainTabPluginEntry(
    label: 'Profile',
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
    final cache = ProfileRuntimeCache();
    final runtime = ProfilePluginRuntime(
      cache: cache,
      preheater: ProfileSnapshotPreheater(
        hostServices: context.services.get<ProfileHostServices>(),
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
