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
import 'application/history_host_services.dart';
import 'application/history_snapshot_preheater.dart';
import 'application/text/history_text_template_installer.dart';
import 'data/schema/history_template_schema_contributor.dart';
import 'data/sqlite/history_template_repository.dart';
import 'data/sqlite/sqlite_history_template_repository.dart';
import 'pages/history_page.dart';
import 'runtime/history_plugin_runtime.dart';
import 'runtime/history_runtime_cache.dart';
import 'application/i18n/history_entry_localizer.dart';
import 'application/i18n/history_l10n_resolver.dart';

class HistoryPlugin extends SmartFeaturePlugin {
  const HistoryPlugin();

  static final _strings = HistoryL10nResolver.fallback;

  @override
  PluginId get id => const PluginId('core.history');

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
        PluginDataRequirement.glucoseEvents,
        PluginDataRequirement.appSettings,
      };
  @override
  List<PluginPlacementSpec> get placementSpecs => [
        PluginPlacementSpec(
          pluginId: id,
          slot: const PluginSlotKey('app.mainTab'),
          renderKey: '/history',
          title: _strings.pluginTitle,
          order: 10,
          dataRequirements: dataRequirements,
        ),
      ];

  @override
  MainTabPluginEntry get mainTabEntry => MainTabPluginEntry(
        label: _strings.pluginTitle,
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
    context.entryLocalizers.register(id, const HistoryEntryLocalizer());
    context.registerSchema(const HistoryTemplateSchemaContributor());
    final database = context.services.get<GlucoseDatabase>();
    final templateRepository = SqliteHistoryTemplateRepository(
      databaseProvider: () => database.db,
    );
    final textTemplateInstaller = HistoryTextTemplateInstaller(
      repository: templateRepository,
    );
    final cache = HistoryRuntimeCache();
    final host = context.services.get<AppHostServices>();
    final hostServices = HistoryHostServices(
      changeSignal: host.changeSignal,
      facadeProvider: host.facadeProvider,
      settingsProvider: host.settingsProvider,
    );
    final runtime = HistoryPluginRuntime(
      cache: cache,
      preheater: HistorySnapshotPreheater(hostServices: hostServices),
      textTemplateInstaller: textTemplateInstaller,
    );
    context.services.register<HistoryTemplateRepository>(templateRepository);
    context.services
        .register<HistoryTextTemplateInstaller>(textTemplateInstaller);
    context.services.register<HistoryRuntimeCache>(cache);
    context.services.register<HistoryHostServices>(hostServices);
    context.services.register<HistoryPluginRuntime>(runtime);
    context.registerRuntime(
      runtime,
      startPolicy: PluginRuntimeStartPolicy.onEnter,
    );
  }
}
