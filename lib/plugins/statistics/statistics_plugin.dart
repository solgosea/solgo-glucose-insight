import 'package:flutter/material.dart';

import 'package:smart_xdrip/plugin_platform/contracts/plugin_data_requirement.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_entry.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_id.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_placement.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_release_stage.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_route.dart';
import 'package:smart_xdrip/plugin_platform/contracts/smart_feature_plugin.dart';
import 'package:smart_xdrip/plugin_platform/install/plugin_install_context.dart';
import 'package:smart_xdrip/plugin_platform/runtime/manager/plugin_runtime_start_policy.dart';
import 'application/statistics_host_services.dart';
import 'application/statistics_snapshot_preheater.dart';
import 'pages/statistics_page.dart';
import 'runtime/statistics_plugin_runtime.dart';
import 'runtime/statistics_runtime_cache.dart';

class StatisticsPlugin extends SmartFeaturePlugin {
  const StatisticsPlugin();

  @override
  PluginId get id => const PluginId('core.statistics');

  @override
  String get title => 'Stats';

  @override
  String get description => 'Aggregate metrics, AGP, and TIR distribution.';

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  Set<PluginPlacement> get placements => const {PluginPlacement.mainTab};

  @override
  Set<PluginDataRequirement> get dataRequirements => const {
    PluginDataRequirement.glucoseReadings,
    PluginDataRequirement.dailySummaries,
    PluginDataRequirement.agpSlots,
    PluginDataRequirement.appSettings,
  };

  @override
  MainTabPluginEntry get mainTabEntry => const MainTabPluginEntry(
    label: 'Stats',
    route: '/stats',
    icon: Icons.bar_chart_outlined,
    activeIcon: Icons.bar_chart,
    order: 20,
  );

  @override
  List<PluginRoute> get routes => [
    PluginRoute(path: '/stats', builder: (_) => const StatisticsPage()),
  ];

  @override
  void install(PluginInstallContext context) {
    final cache = StatisticsRuntimeCache();
    final runtime = StatisticsPluginRuntime(
      cache: cache,
      preheater: StatisticsSnapshotPreheater(
        hostServices: context.services.get<StatisticsHostServices>(),
      ),
    );
    context.services.register<StatisticsRuntimeCache>(cache);
    context.services.register<StatisticsPluginRuntime>(runtime);
    context.registerRuntime(
      runtime,
      startPolicy: PluginRuntimeStartPolicy.onEnter,
    );
  }
}
