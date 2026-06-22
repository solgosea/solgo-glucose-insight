import 'package:smart_xdrip/plugin_platform/graph/plugin_slot_key.dart';
import 'package:smart_xdrip/plugin_platform/composition/plugin_placement_spec.dart';
import 'package:flutter/material.dart';

import 'package:smart_xdrip/application/plugin_host/app_host_services.dart';
import 'package:smart_xdrip/data/local/glucose_database.dart';
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
import 'application/text/statistics_text_template_installer.dart';
import 'data/schema/statistics_template_schema_contributor.dart';
import 'data/sqlite/sqlite_statistics_template_repository.dart';
import 'data/sqlite/statistics_template_repository.dart';
import 'pages/statistics_page.dart';
import 'runtime/statistics_plugin_runtime.dart';
import 'runtime/statistics_runtime_cache.dart';
import 'application/i18n/statistics_entry_localizer.dart';
import 'application/i18n/statistics_l10n_resolver.dart';

class StatisticsPlugin extends SmartFeaturePlugin {
  const StatisticsPlugin();

  static final _strings = StatisticsL10nResolver.fallback;

  @override
  PluginId get id => const PluginId('core.statistics');

  @override
  String get title => _strings.pluginTitle;

  @override
  String get description => _strings.pluginDescription;

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
  List<PluginPlacementSpec> get placementSpecs => [
        PluginPlacementSpec(
          pluginId: id,
          slot: const PluginSlotKey('app.mainTab'),
          renderKey: '/stats',
          title: _strings.pluginTitle,
          order: 20,
          dataRequirements: dataRequirements,
        ),
      ];

  @override
  MainTabPluginEntry get mainTabEntry => MainTabPluginEntry(
        label: _strings.pluginTitle,
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
    context.entryLocalizers.register(id, const StatisticsEntryLocalizer());
    context.registerSchema(const StatisticsTemplateSchemaContributor());
    final database = context.services.get<GlucoseDatabase>();
    final templateRepository = SqliteStatisticsTemplateRepository(
      databaseProvider: () => database.db,
    );
    final textTemplateInstaller = StatisticsTextTemplateInstaller(
      repository: templateRepository,
    );
    final host = context.services.get<AppHostServices>();
    final hostServices = StatisticsHostServices(
      changeSignal: host.changeSignal,
      facadeProvider: host.facadeProvider,
      settingsProvider: host.settingsProvider,
    );
    final cache = StatisticsRuntimeCache();
    final runtime = StatisticsPluginRuntime(
      cache: cache,
      preheater: StatisticsSnapshotPreheater(
        hostServices: hostServices,
      ),
      textTemplateInstaller: textTemplateInstaller,
    );
    context.services.register<StatisticsTemplateRepository>(templateRepository);
    context.services.register<StatisticsTextTemplateInstaller>(
      textTemplateInstaller,
    );
    context.services.register<StatisticsHostServices>(hostServices);
    context.services.register<StatisticsRuntimeCache>(cache);
    context.services.register<StatisticsPluginRuntime>(runtime);
    context.registerRuntime(
      runtime,
      startPolicy: PluginRuntimeStartPolicy.onEnter,
    );
  }
}
