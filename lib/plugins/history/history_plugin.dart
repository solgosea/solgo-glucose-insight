import 'package:flutter/material.dart';

import 'package:smart_xdrip/application/analysis/analysis_facade.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_data_requirement.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_entry.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_id.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_placement.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_release_stage.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_route.dart';
import 'package:smart_xdrip/plugin_platform/contracts/smart_feature_plugin.dart';
import 'package:smart_xdrip/plugin_platform/install/plugin_install_context.dart';
import 'package:smart_xdrip/plugin_platform/runtime/manager/plugin_runtime_start_policy.dart';
import 'application/history_host_services.dart';
import 'application/history_snapshot_preheater.dart';
import 'pages/history_page.dart';
import 'runtime/history_plugin_runtime.dart';
import 'runtime/history_runtime_cache.dart';

class HistoryPlugin extends SmartFeaturePlugin {
  const HistoryPlugin();

  @override
  PluginId get id => const PluginId('core.history');

  @override
  String get title => 'History';

  @override
  String get description => 'Day-level glucose curve, events, and episodes.';

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  Set<PluginPlacement> get placements => const {PluginPlacement.mainTab};

  @override
  Set<PluginDataRequirement> get dataRequirements => const {
    PluginDataRequirement.glucoseReadings,
    PluginDataRequirement.glucoseEvents,
    PluginDataRequirement.appSettings,
  };

  @override
  MainTabPluginEntry get mainTabEntry => const MainTabPluginEntry(
    label: 'History',
    route: '/history',
    icon: Icons.calendar_today_outlined,
    activeIcon: Icons.calendar_today,
    order: 10,
  );

  @override
  List<PluginRoute> get routes => [
    PluginRoute(path: '/history', builder: (_) => const HistoryPage()),
  ];

  @override
  void install(PluginInstallContext context) {
    final cache = HistoryRuntimeCache();
    final hostServices =
        context.services.maybe<HistoryHostServices>() ??
        HistoryHostServices(
          changeSignal: context.runtimeManager.store,
          facadeProvider: AnalysisFacade.current,
          settingsProvider: () => AnalysisFacade.current().settings,
        );
    final runtime = HistoryPluginRuntime(
      cache: cache,
      preheater: HistorySnapshotPreheater(hostServices: hostServices),
    );
    context.services.register<HistoryRuntimeCache>(cache);
    context.services.register<HistoryPluginRuntime>(runtime);
    context.registerRuntime(
      runtime,
      startPolicy: PluginRuntimeStartPolicy.onEnter,
    );
  }
}
