import 'dart:async';

import 'package:smart_xdrip/data/local/glucose_database.dart';
import 'package:smart_xdrip/plugin_platform/install/plugin_install_context.dart';

import '../application/probe/runtime/status_probe_event_bus.dart';
import '../application/probe/runtime/status_probe_registry.dart';
import '../application/probe/runtime/status_probe_result_cache.dart';
import '../application/probe/runtime/status_probe_runtime.dart';
import '../application/probe/catalog/status_probe_catalog_service.dart';
import '../application/probe/history/status_probe_history_query_service.dart';
import '../application/probe/history/status_probe_history_recorder.dart';
import '../application/probe/suites/aaps/aaps_probe_suite.dart';
import '../application/probe/suites/common/common_probe_suite.dart';
import '../application/probe/suites/juggluco/juggluco_probe_suite.dart';
import '../application/probe/suites/nightscout/nightscout_probe_suite.dart';
import '../application/probe/suites/watch/watch_probe_suite.dart';
import '../application/probe/suites/xdrip/xdrip_probe_suite.dart';
import '../application/probe_scenario/engine/status_probe_scenario_engine.dart';
import '../data/probe/catalog/sqlite_status_probe_catalog_repository.dart';
import '../data/probe/catalog/status_probe_default_catalog.dart';
import '../data/probe/local/sqlite_status_probe_history_repository.dart';

class StatusMonitorProbeInstallBundle {
  final StatusProbeRegistry registry;
  final StatusProbeResultCache cache;
  final StatusProbeEventBus eventBus;
  final StatusProbeRuntime runtime;
  final SqliteStatusProbeCatalogRepository catalogRepository;
  final StatusProbeCatalogService catalogService;
  final StatusProbeScenarioEngine scenarioEngine;
  final SqliteStatusProbeHistoryRepository historyRepository;
  final StatusProbeHistoryRecorder historyRecorder;
  final StatusProbeHistoryQueryService historyQueryService;

  const StatusMonitorProbeInstallBundle({
    required this.registry,
    required this.cache,
    required this.eventBus,
    required this.runtime,
    required this.catalogRepository,
    required this.catalogService,
    required this.scenarioEngine,
    required this.historyRepository,
    required this.historyRecorder,
    required this.historyQueryService,
  });
}

class StatusMonitorProbeRegistrar {
  const StatusMonitorProbeRegistrar();

  StatusMonitorProbeInstallBundle install(PluginInstallContext context) {
    final database = context.services.get<GlucoseDatabase>();
    final registry = StatusProbeRegistry(
      suites: [
        CommonProbeSuite(),
        XdripProbeSuite(),
        JugglucoProbeSuite(),
        NightscoutProbeSuite(),
        AapsProbeSuite(),
        WatchProbeSuite(),
      ],
    );
    final cache = StatusProbeResultCache();
    final eventBus = StatusProbeEventBus();
    final catalogRepository = SqliteStatusProbeCatalogRepository(
      databaseProvider: () => database.db,
    );
    final defaultCatalog = const StatusProbeDefaultCatalog().build(registry);
    final catalogService = StatusProbeCatalogService(
      repository: catalogRepository,
      seedCatalog: defaultCatalog,
    );
    final historyRepository = SqliteStatusProbeHistoryRepository(
      databaseProvider: () => database.db,
    );
    final historyRecorder = StatusProbeHistoryRecorder(
      repository: historyRepository,
    );
    final historyQueryService = StatusProbeHistoryQueryService(
      repository: historyRepository,
    );
    final runtime = StatusProbeRuntime(
      registry: registry,
      cache: cache,
      eventBus: eventBus,
      historyRecorder: historyRecorder,
    );
    final scenarioEngine = StatusProbeScenarioEngine(
      registry: registry,
      catalogService: catalogService,
      cache: cache,
      eventBus: eventBus,
      historyRecorder: historyRecorder,
    );
    final bundle = StatusMonitorProbeInstallBundle(
      registry: registry,
      cache: cache,
      eventBus: eventBus,
      runtime: runtime,
      catalogRepository: catalogRepository,
      catalogService: catalogService,
      scenarioEngine: scenarioEngine,
      historyRepository: historyRepository,
      historyRecorder: historyRecorder,
      historyQueryService: historyQueryService,
    );
    context.services.register<StatusProbeRegistry>(registry);
    context.services.register<StatusProbeResultCache>(cache);
    context.services.register<StatusProbeEventBus>(eventBus);
    context.services.register<StatusProbeRuntime>(runtime);
    context.services.register<SqliteStatusProbeCatalogRepository>(
      catalogRepository,
    );
    context.services.register<StatusProbeCatalogService>(catalogService);
    context.services.register<StatusProbeScenarioEngine>(scenarioEngine);
    context.services.register<SqliteStatusProbeHistoryRepository>(
      historyRepository,
    );
    context.services.register<StatusProbeHistoryRecorder>(historyRecorder);
    context.services.register<StatusProbeHistoryQueryService>(
      historyQueryService,
    );
    unawaited(
      catalogService.installDefault(
        defaultCatalog,
      ),
    );
    return bundle;
  }
}
