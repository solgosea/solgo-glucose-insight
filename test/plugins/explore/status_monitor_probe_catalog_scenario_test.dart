import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/probe/catalog/status_probe_catalog_repository.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/probe/catalog/status_probe_catalog_service.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/probe/contracts/status_probe_driver.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/probe/contracts/status_probe_suite.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/probe/runtime/status_probe_event_bus.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/probe/runtime/status_probe_registry.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/probe/runtime/status_probe_result_cache.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/probe_scenario/engine/status_probe_scenario_engine.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/probe_scenario/scenarios/status_probe_scenario_ids.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/status_monitor_target_resolution.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/data/probe/catalog/status_probe_default_catalog.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/data/probe/catalog/sqlite_status_probe_catalog_repository.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_catalog.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_category.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_context.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_definition.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_display_definition.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_id.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_kind.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_result.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_run_mode.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_state.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_suite_definition.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe_scenario/status_probe_scenario_definition.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  test('default catalog exposes overview scenario from registry suites',
      () async {
    final now = DateTime(2026, 6, 26, 10);
    final registry = StatusProbeRegistry(
      suites: [
        _FakeSuite('common', StatusProbeKind.common, [
          _FakeDriver(
            suiteId: 'common',
            id: 'common.network.connectivity',
            kind: StatusProbeKind.common,
            category: StatusProbeCategory.network,
            state: StatusProbeState.healthy,
            now: now,
            requiredForCorePath: true,
          ),
        ]),
        _FakeSuite('xdrip', StatusProbeKind.xdrip, [
          _FakeDriver(
            suiteId: 'xdrip',
            id: 'xdrip.broadcast.freshness',
            kind: StatusProbeKind.xdrip,
            category: StatusProbeCategory.freshness,
            state: StatusProbeState.watch,
            now: now,
          ),
        ]),
      ],
    );
    final seed = const StatusProbeDefaultCatalog().build(registry);
    final catalogRepository = _MemoryCatalogRepository();
    await catalogRepository.installDefault(seed);
    final runner = StatusProbeScenarioEngine(
      registry: registry,
      catalogService: StatusProbeCatalogService(
        repository: catalogRepository,
        seedCatalog: seed,
      ),
      cache: StatusProbeResultCache(),
      eventBus: StatusProbeEventBus(),
      now: () => now,
    );

    final result = await runner.run(
      StatusProbeContext(
        subjectId: 'self',
        now: now,
        target: const StatusMonitorTargetResolution.none(subjectId: 'self'),
      ),
      StatusProbeScenarioIds.overview,
    );

    expect(result.definition.id, StatusProbeScenarioIds.overview);
    expect(result.bundle.suites.map((suite) => suite.suiteId), [
      'common',
      'xdrip',
    ]);
    expect(result.score, greaterThan(0));
    expect(result.bundle.suite('common')!.results.single.probeId,
        'common.network.connectivity');
  });

  test('default catalog maps checklist probes to guide routes', () {
    final now = DateTime(2026, 6, 26, 10);
    final registry = StatusProbeRegistry(
      suites: [
        _FakeSuite('common', StatusProbeKind.common, [
          _FakeDriver(
            suiteId: 'common',
            id: 'common.network.connectivity',
            kind: StatusProbeKind.common,
            category: StatusProbeCategory.network,
            state: StatusProbeState.healthy,
            now: now,
          ),
          _FakeDriver(
            suiteId: 'common',
            id: 'common.bluetooth.enabled',
            kind: StatusProbeKind.common,
            category: StatusProbeCategory.bluetooth,
            state: StatusProbeState.healthy,
            now: now,
          ),
        ]),
        _FakeSuite('xdrip', StatusProbeKind.xdrip, [
          _FakeDriver(
            suiteId: 'xdrip',
            id: 'xdrip.broadcast.bg_estimate',
            kind: StatusProbeKind.xdrip,
            category: StatusProbeCategory.broadcast,
            state: StatusProbeState.healthy,
            now: now,
          ),
          _FakeDriver(
            suiteId: 'xdrip',
            id: 'xdrip.broadcast.freshness',
            kind: StatusProbeKind.xdrip,
            category: StatusProbeCategory.freshness,
            state: StatusProbeState.healthy,
            now: now,
          ),
        ]),
        _FakeSuite('juggluco', StatusProbeKind.juggluco, [
          _FakeDriver(
            suiteId: 'juggluco',
            id: 'juggluco.broadcast.xdrip_compatible',
            kind: StatusProbeKind.juggluco,
            category: StatusProbeCategory.broadcast,
            state: StatusProbeState.healthy,
            now: now,
          ),
        ]),
        _FakeSuite('nightscout', StatusProbeKind.nightscout, [
          _FakeDriver(
            suiteId: 'nightscout',
            id: 'nightscout.entries.freshness',
            kind: StatusProbeKind.nightscout,
            category: StatusProbeCategory.freshness,
            state: StatusProbeState.healthy,
            now: now,
          ),
        ]),
        _FakeSuite('aaps', StatusProbeKind.aaps, [
          _FakeDriver(
            suiteId: 'aaps',
            id: 'aaps.bg_source.xdrip_evidence',
            kind: StatusProbeKind.aaps,
            category: StatusProbeCategory.downstream,
            state: StatusProbeState.healthy,
            now: now,
          ),
          _FakeDriver(
            suiteId: 'aaps',
            id: 'aaps.xdrip.output_evidence',
            kind: StatusProbeKind.aaps,
            category: StatusProbeCategory.downstream,
            state: StatusProbeState.healthy,
            now: now,
          ),
        ]),
        _FakeSuite('watch', StatusProbeKind.watch, [
          _FakeDriver(
            suiteId: 'watch',
            id: 'watch.xdrip_web_service.entries',
            kind: StatusProbeKind.watch,
            category: StatusProbeCategory.api,
            state: StatusProbeState.healthy,
            now: now,
          ),
          _FakeDriver(
            suiteId: 'watch',
            id: 'watch.display.evidence',
            kind: StatusProbeKind.watch,
            category: StatusProbeCategory.downstream,
            state: StatusProbeState.healthy,
            now: now,
          ),
        ]),
      ],
    );

    final catalog = const StatusProbeDefaultCatalog().build(registry);
    final routes = {
      for (final probe in catalog.probes)
        probe.probeId: probe.display.guideRoute
    };

    expect(
      catalog.probes.every((probe) => probe.display.guideRoute != null),
      isTrue,
    );
    expect(
      routes['common.network.connectivity'],
      '/explore/status/probe/nightscout-guide',
    );
    expect(
      routes['common.bluetooth.enabled'],
      '/explore/status/probe/xdrip-guide',
    );
    expect(
      routes['xdrip.broadcast.bg_estimate'],
      '/explore/status/probe/xdrip-guide',
    );
    expect(
      routes['xdrip.broadcast.freshness'],
      '/explore/status/probe/xdrip-guide',
    );
    expect(
      routes['juggluco.broadcast.xdrip_compatible'],
      '/explore/status/probe/juggluco-guide',
    );
    expect(
      routes['nightscout.entries.freshness'],
      '/explore/status/probe/nightscout-guide',
    );
    expect(
      routes['aaps.bg_source.xdrip_evidence'],
      '/explore/status/probe/aaps-guide',
    );
    expect(
      routes['aaps.xdrip.output_evidence'],
      '/explore/status/probe/aaps-guide',
    );
    expect(
      routes['watch.xdrip_web_service.entries'],
      '/explore/status/probe/watch-guide',
    );
    expect(
      routes['watch.display.evidence'],
      '/explore/status/probe/watch-guide',
    );
  });

  test('scenarios keep xDrip core separate from downstream checks', () {
    final now = DateTime(2026, 6, 26, 10);
    final registry = StatusProbeRegistry(
      suites: [
        _FakeSuite('common', StatusProbeKind.common, [
          _FakeDriver(
            suiteId: 'common',
            id: 'common.network.connectivity',
            kind: StatusProbeKind.common,
            category: StatusProbeCategory.network,
            state: StatusProbeState.healthy,
            now: now,
          ),
        ]),
        _FakeSuite('xdrip', StatusProbeKind.xdrip, [
          _FakeDriver(
            suiteId: 'xdrip',
            id: 'xdrip.package.visible',
            kind: StatusProbeKind.xdrip,
            category: StatusProbeCategory.package,
            state: StatusProbeState.healthy,
            now: now,
          ),
          _FakeDriver(
            suiteId: 'xdrip',
            id: 'xdrip.broadcast.bg_estimate',
            kind: StatusProbeKind.xdrip,
            category: StatusProbeCategory.broadcast,
            state: StatusProbeState.healthy,
            now: now,
          ),
          _FakeDriver(
            suiteId: 'xdrip',
            id: 'xdrip.broadcast.freshness',
            kind: StatusProbeKind.xdrip,
            category: StatusProbeCategory.freshness,
            state: StatusProbeState.healthy,
            now: now,
          ),
        ]),
        _FakeSuite('aaps', StatusProbeKind.aaps, [
          _FakeDriver(
            suiteId: 'aaps',
            id: 'aaps.package.visible',
            kind: StatusProbeKind.aaps,
            category: StatusProbeCategory.package,
            state: StatusProbeState.healthy,
            now: now,
          ),
          _FakeDriver(
            suiteId: 'aaps',
            id: 'aaps.xdrip.output_evidence',
            kind: StatusProbeKind.aaps,
            category: StatusProbeCategory.downstream,
            state: StatusProbeState.healthy,
            now: now,
          ),
        ]),
        _FakeSuite('watch', StatusProbeKind.watch, [
          _FakeDriver(
            suiteId: 'watch',
            id: 'watch.bridge.package',
            kind: StatusProbeKind.watch,
            category: StatusProbeCategory.package,
            state: StatusProbeState.healthy,
            now: now,
          ),
          _FakeDriver(
            suiteId: 'watch',
            id: 'watch.xdrip_web_service.entries',
            kind: StatusProbeKind.watch,
            category: StatusProbeCategory.api,
            state: StatusProbeState.healthy,
            now: now,
          ),
        ]),
      ],
    );

    final catalog = const StatusProbeDefaultCatalog().build(registry);
    final xdripScenario = catalog.scenarios.firstWhere(
      (item) => item.id == StatusProbeScenarioIds.xdrip,
    );
    final aapsScenario = catalog.scenarios.firstWhere(
      (item) => item.id == StatusProbeScenarioIds.aaps,
    );
    final watchScenario = catalog.scenarios.firstWhere(
      (item) => item.id == StatusProbeScenarioIds.watch,
    );

    expect(
      xdripScenario.items.map((item) => item.probeId).whereType<String>(),
      [
        'xdrip.package.visible',
        'xdrip.broadcast.bg_estimate',
        'xdrip.broadcast.freshness',
      ],
    );
    expect(
      aapsScenario.items.map((item) => item.probeId).whereType<String>(),
      contains('aaps.xdrip.output_evidence'),
    );
    expect(
      watchScenario.items.map((item) => item.probeId).whereType<String>(),
      contains('watch.xdrip_web_service.entries'),
    );
  });

  test('optional suite activation probe skips unused setup checks', () async {
    final now = DateTime(2026, 6, 26, 10);
    final registry = StatusProbeRegistry(
      suites: [
        _FakeSuite('common', StatusProbeKind.common, [
          _FakeDriver(
            suiteId: 'common',
            id: 'common.network.connectivity',
            kind: StatusProbeKind.common,
            category: StatusProbeCategory.network,
            state: StatusProbeState.healthy,
            now: now,
          ),
        ]),
        _FakeSuite('juggluco', StatusProbeKind.juggluco, [
          _FakeDriver(
            suiteId: 'juggluco',
            id: 'juggluco.package.visible',
            kind: StatusProbeKind.juggluco,
            category: StatusProbeCategory.package,
            state: StatusProbeState.notObserved,
            now: now,
          ),
          _FakeDriver(
            suiteId: 'juggluco',
            id: 'juggluco.broadcast.xdrip_compatible',
            kind: StatusProbeKind.juggluco,
            category: StatusProbeCategory.broadcast,
            state: StatusProbeState.healthy,
            now: now,
          ),
        ]),
      ],
    );
    final seed = const StatusProbeDefaultCatalog().build(registry);
    final catalogRepository = _MemoryCatalogRepository();
    await catalogRepository.installDefault(seed);
    final runner = StatusProbeScenarioEngine(
      registry: registry,
      catalogService: StatusProbeCatalogService(
        repository: catalogRepository,
        seedCatalog: seed,
      ),
      cache: StatusProbeResultCache(),
      eventBus: StatusProbeEventBus(),
      now: () => now,
    );

    final result = await runner.run(
      StatusProbeContext(
        subjectId: 'self',
        now: now,
        target: const StatusMonitorTargetResolution.none(subjectId: 'self'),
      ),
      StatusProbeScenarioIds.overview,
    );

    final juggluco = result.bundle.suite('juggluco')!;
    expect(juggluco.results.map((item) => item.probeId), [
      'juggluco.package.visible',
      'juggluco.broadcast.xdrip_compatible',
    ]);
    expect(juggluco.results.first.state, StatusProbeState.notObserved);
    expect(juggluco.results.last.summary, 'Not used for this detected setup.');
    expect(result.breakdown.optionalActive, 0);
  });

  test('sqlite catalog install prunes stale probes and scenario items',
      () async {
    sqfliteFfiInit();
    final database =
        await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    addTearDown(database.close);
    final repository = SqliteStatusProbeCatalogRepository(
      databaseProvider: () async => database,
    );

    await repository.installDefault(
      _catalog(
        probeIds: const [
          'xdrip.package.visible',
          'xdrip.broadcast.bg_estimate',
          'xdrip.web_service.entries',
        ],
        scenarioItems: const [
          StatusProbeScenarioItem(
            suiteId: 'xdrip',
            orderIndex: 0,
          ),
        ],
      ),
    );
    await repository.installDefault(
      _catalog(
        probeIds: const [
          'xdrip.package.visible',
          'xdrip.broadcast.bg_estimate',
          'xdrip.broadcast.freshness',
        ],
        scenarioItems: const [
          StatusProbeScenarioItem(
            suiteId: 'xdrip',
            probeId: 'xdrip.package.visible',
            orderIndex: 0,
          ),
          StatusProbeScenarioItem(
            suiteId: 'xdrip',
            probeId: 'xdrip.broadcast.bg_estimate',
            orderIndex: 10,
          ),
          StatusProbeScenarioItem(
            suiteId: 'xdrip',
            probeId: 'xdrip.broadcast.freshness',
            orderIndex: 20,
            weight: 3,
            hardGate: true,
            scoreCap: 55,
          ),
        ],
      ),
    );

    final loaded = await repository.load();
    expect(
      loaded.probes.map((probe) => probe.probeId),
      isNot(contains('xdrip.web_service.entries')),
    );
    final scenario = loaded.scenarios.single;
    expect(
      scenario.items.map((item) => item.probeId).toList(growable: false),
      [
        'xdrip.package.visible',
        'xdrip.broadcast.bg_estimate',
        'xdrip.broadcast.freshness',
      ],
    );
    final freshness = scenario.items.last;
    expect(freshness.weight, 3);
    expect(freshness.hardGate, isTrue);
    expect(freshness.scoreCap, 55);
  });

  test('scenario score uses probe weights and hard gate caps', () async {
    final now = DateTime(2026, 6, 26, 10);
    final registry = StatusProbeRegistry(
      suites: [
        _FakeSuite('xdrip', StatusProbeKind.xdrip, [
          _FakeDriver(
            suiteId: 'xdrip',
            id: 'xdrip.package.visible',
            kind: StatusProbeKind.xdrip,
            category: StatusProbeCategory.package,
            state: StatusProbeState.healthy,
            now: now,
          ),
          _FakeDriver(
            suiteId: 'xdrip',
            id: 'xdrip.broadcast.bg_estimate',
            kind: StatusProbeKind.xdrip,
            category: StatusProbeCategory.broadcast,
            state: StatusProbeState.watch,
            now: now,
          ),
        ]),
      ],
    );
    final catalog = _catalog(
      probeIds: const [
        'xdrip.package.visible',
        'xdrip.broadcast.bg_estimate',
      ],
      scenarioItems: const [
        StatusProbeScenarioItem(
          suiteId: 'xdrip',
          probeId: 'xdrip.package.visible',
          orderIndex: 0,
          weight: 1,
        ),
        StatusProbeScenarioItem(
          suiteId: 'xdrip',
          probeId: 'xdrip.broadcast.bg_estimate',
          orderIndex: 10,
          weight: 4,
          hardGate: true,
          scoreCap: 40,
        ),
      ],
    );
    final catalogRepository = _MemoryCatalogRepository();
    await catalogRepository.installDefault(catalog);
    final engine = StatusProbeScenarioEngine(
      registry: registry,
      catalogService: StatusProbeCatalogService(
        repository: catalogRepository,
        seedCatalog: catalog,
      ),
      cache: StatusProbeResultCache(),
      eventBus: StatusProbeEventBus(),
      now: () => now,
    );

    final result = await engine.run(
      StatusProbeContext(
        subjectId: 'self',
        now: now,
        target: const StatusMonitorTargetResolution.none(subjectId: 'self'),
      ),
      StatusProbeScenarioIds.xdrip,
    );

    expect(result.score, 40);
    expect(
      result.breakdown.appliedGateProbeIds,
      contains('xdrip.broadcast.bg_estimate'),
    );
    expect(
      result.breakdown.appliedCapProbeIds,
      contains('xdrip.broadcast.bg_estimate'),
    );
  });
}

StatusProbeCatalog _catalog({
  required List<String> probeIds,
  required List<StatusProbeScenarioItem> scenarioItems,
}) {
  return StatusProbeCatalog(
    suites: const [
      StatusProbeSuiteCatalogEntry(
        suiteId: 'xdrip',
        kind: StatusProbeKind.xdrip,
        display: StatusProbeDisplayDefinition(
          titleKey: 'probe.suite.xdrip.title',
          descriptionKey: 'probe.suite.xdrip.description',
        ),
      ),
    ],
    probes: [
      for (var i = 0; i < probeIds.length; i++)
        StatusProbeCatalogEntry(
          probeId: probeIds[i],
          suiteId: 'xdrip',
          driverId: probeIds[i],
          display: StatusProbeDisplayDefinition(
            titleKey: 'probe.${probeIds[i]}.title',
            descriptionKey: 'probe.${probeIds[i]}.description',
          ),
          priority: i * 10,
        ),
    ],
    scenarios: [
      StatusProbeScenarioDefinition(
        id: StatusProbeScenarioIds.xdrip,
        titleKey: 'probe.scenario.xdrip.title',
        descriptionKey: 'probe.scenario.xdrip.description',
        items: scenarioItems,
      ),
    ],
  );
}

class _MemoryCatalogRepository implements StatusProbeCatalogRepository {
  StatusProbeCatalog catalog = const StatusProbeCatalog.empty();

  @override
  Future<void> installDefault(StatusProbeCatalog catalog) async {
    this.catalog = catalog;
  }

  @override
  Future<StatusProbeCatalog> load() async => catalog;
}

class _FakeSuite implements StatusProbeSuite {
  _FakeSuite(this.id, this.kind, this.drivers);

  final String id;
  final StatusProbeKind kind;

  @override
  final List<StatusProbeDriver> drivers;

  @override
  StatusProbeSuiteDefinition get definition => StatusProbeSuiteDefinition(
        id: id,
        label: id,
        kind: kind,
        probes: drivers.map((driver) => driver.definition).toList(),
      );
}

class _FakeDriver implements StatusProbeDriver {
  _FakeDriver({
    required this.suiteId,
    required this.id,
    required this.kind,
    required this.category,
    required this.state,
    required this.now,
    this.requiredForCorePath = false,
  });

  final String suiteId;
  final String id;
  final StatusProbeKind kind;
  final StatusProbeCategory category;
  final StatusProbeState state;
  final DateTime now;
  final bool requiredForCorePath;

  @override
  StatusProbeDefinition get definition => StatusProbeDefinition(
        id: StatusProbeId(id),
        suiteId: suiteId,
        label: id,
        kind: kind,
        category: category,
        runMode: StatusProbeRunMode.active,
        requiredForCorePath: requiredForCorePath,
      );

  @override
  Future<StatusProbeResult> run(StatusProbeContext context) async {
    return StatusProbeResult(
      definition: definition,
      state: state,
      observedAt: now,
      confidence: 1,
      runMode: StatusProbeRunMode.active,
      summary: state.name,
    );
  }
}
