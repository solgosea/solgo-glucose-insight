import 'package:smart_xdrip/plugin_platform/contracts/plugin_data_requirement.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_id.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_placement.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_release_stage.dart';
import 'package:smart_xdrip/plugin_platform/contracts/plugin_route.dart';
import 'package:smart_xdrip/plugin_platform/contracts/smart_feature_plugin.dart';
import 'package:smart_xdrip/plugin_platform/install/plugin_install_context.dart';
import 'package:smart_xdrip/plugin_platform/runtime/manager/plugin_runtime_start_policy.dart';
import 'application/insights_host_services.dart';
import 'application/insights_snapshot_preheater.dart';
import 'pages/insights_page.dart';
import 'runtime/insights_plugin_runtime.dart';
import 'runtime/insights_runtime_cache.dart';

class InsightsPlugin extends SmartFeaturePlugin {
  const InsightsPlugin();

  @override
  PluginId get id => const PluginId('analysis.insights');

  @override
  String get title => 'Insights';

  @override
  String get description => 'Narrative daily and weekly glucose insights.';

  @override
  PluginReleaseStage get releaseStage => PluginReleaseStage.stable;

  @override
  Set<PluginPlacement> get placements => const {};

  @override
  Set<PluginDataRequirement> get dataRequirements => const {
    PluginDataRequirement.glucoseReadings,
    PluginDataRequirement.dailySummaries,
    PluginDataRequirement.appSettings,
  };

  @override
  List<PluginRoute> get routes => [
    PluginRoute(path: '/insight', builder: (_) => const InsightsPage()),
    PluginRoute(path: '/insights', builder: (_) => const InsightsPage()),
  ];

  @override
  void install(PluginInstallContext context) {
    final cache = InsightsRuntimeCache();
    final runtime = InsightsPluginRuntime(
      cache: cache,
      preheater: InsightsSnapshotPreheater(
        hostServices: context.services.get<InsightsHostServices>(),
      ),
    );
    context.services.register<InsightsRuntimeCache>(cache);
    context.services.register<InsightsPluginRuntime>(runtime);
    context.registerRuntime(
      runtime,
      startPolicy: PluginRuntimeStartPolicy.onEnter,
    );
  }
}
