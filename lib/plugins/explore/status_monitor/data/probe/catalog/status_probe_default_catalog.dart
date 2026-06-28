import '../../../application/probe/runtime/status_probe_registry.dart';
import '../../../application/probe_scenario/scenarios/status_probe_scenario_ids.dart';
import '../../../domain/probe/status_probe_catalog.dart';
import '../../../domain/probe/status_probe_display_definition.dart';
import '../../../domain/probe/status_probe_path_role.dart';
import '../../../domain/probe/status_probe_score_scope.dart';
import '../../../domain/probe_scenario/status_probe_scenario_definition.dart';

class StatusProbeDefaultCatalog {
  const StatusProbeDefaultCatalog();

  StatusProbeCatalog build(StatusProbeRegistry registry) {
    final suites = <StatusProbeSuiteCatalogEntry>[];
    final probes = <StatusProbeCatalogEntry>[];
    var suitePriority = 10;
    for (final suite in registry.suites) {
      suites.add(
        StatusProbeSuiteCatalogEntry(
          suiteId: suite.definition.id,
          kind: suite.definition.kind,
          display: StatusProbeDisplayDefinition(
            titleKey: 'probe.suite.${suite.definition.id}.title',
            descriptionKey: 'probe.suite.${suite.definition.id}.description',
            iconKey: suite.definition.id,
          ),
          role: _roleFor(suite.definition.id),
          scoreScope: _scopeFor(suite.definition.id),
          priority: suitePriority,
        ),
      );
      var probePriority = 10;
      for (final driver in suite.drivers) {
        final probeId = driver.definition.id.value;
        probes.add(
          StatusProbeCatalogEntry(
            probeId: probeId,
            suiteId: suite.definition.id,
            driverId: probeId,
            display: StatusProbeDisplayDefinition(
              titleKey: 'probe.$probeId.title',
              descriptionKey: 'probe.$probeId.description',
              iconKey: driver.definition.category.name,
              guideRoute: _guideRouteFor(
                probeId: probeId,
                suiteId: suite.definition.id,
              ),
            ),
            role: _roleFor(suite.definition.id),
            scoreScope: _scopeFor(suite.definition.id),
            required: driver.definition.requiredForCorePath,
            activationProbe: _isActivationProbe(probeId),
            priority: probePriority,
          ),
        );
        probePriority += 10;
      }
      suitePriority += 10;
    }
    return StatusProbeCatalog(
      suites: suites,
      probes: probes,
      scenarios: [
        _scenario(
          id: StatusProbeScenarioIds.overview,
          titleKey: 'probe.scenario.overview.title',
          descriptionKey: 'probe.scenario.overview.description',
          items: [
            _suite('common'),
            ..._xdripCore(),
            ..._jugglucoPath(),
            ..._nightscoutPath(),
            ..._aapsPath(),
            ..._watchPath(),
          ],
        ),
        _scenario(
          id: StatusProbeScenarioIds.xdrip,
          titleKey: 'probe.scenario.xdrip.title',
          descriptionKey: 'probe.scenario.xdrip.description',
          items: [_suite('common'), ..._xdripCore()],
        ),
        _scenario(
          id: StatusProbeScenarioIds.juggluco,
          titleKey: 'probe.scenario.juggluco.title',
          descriptionKey: 'probe.scenario.juggluco.description',
          items: [_suite('common'), ..._jugglucoPath(), ..._xdripCore()],
        ),
        _scenario(
          id: StatusProbeScenarioIds.nightscout,
          titleKey: 'probe.scenario.nightscout.title',
          descriptionKey: 'probe.scenario.nightscout.description',
          items: [_suite('common'), ..._xdripCore(), ..._nightscoutPath()],
        ),
        _scenario(
          id: StatusProbeScenarioIds.aaps,
          titleKey: 'probe.scenario.aaps.title',
          descriptionKey: 'probe.scenario.aaps.description',
          items: [_suite('common'), ..._xdripCore(), ..._aapsPath()],
        ),
        _scenario(
          id: StatusProbeScenarioIds.watch,
          titleKey: 'probe.scenario.watch.title',
          descriptionKey: 'probe.scenario.watch.description',
          items: [_suite('common'), ..._xdripCore(), ..._watchPath()],
        ),
      ],
    );
  }

  StatusProbeScenarioDefinition _scenario({
    required String id,
    required String titleKey,
    required String descriptionKey,
    required List<StatusProbeScenarioItem> items,
  }) {
    return StatusProbeScenarioDefinition(
      id: id,
      titleKey: titleKey,
      descriptionKey: descriptionKey,
      items: [
        for (var i = 0; i < items.length; i++)
          StatusProbeScenarioItem(
            suiteId: items[i].suiteId,
            probeId: items[i].probeId,
            sectionId: items[i].sectionId,
            orderIndex: i * 10,
            enabled: items[i].enabled,
            weight: items[i].weight,
            scoreScope: items[i].scoreScope,
            hardGate: items[i].hardGate,
            activationProbe: items[i].activationProbe,
            scoreCap: items[i].scoreCap,
          ),
      ],
    );
  }

  StatusProbeScenarioItem _suite(String suiteId) {
    return StatusProbeScenarioItem(
      suiteId: suiteId,
      orderIndex: 0,
    );
  }

  StatusProbeScenarioItem _probe(
    String suiteId,
    String probeId, {
    double weight = 1,
    bool hardGate = false,
    bool activationProbe = false,
    int? scoreCap,
  }) {
    return StatusProbeScenarioItem(
      suiteId: suiteId,
      probeId: probeId,
      orderIndex: 0,
      weight: weight,
      hardGate: hardGate,
      activationProbe: activationProbe,
      scoreCap: scoreCap,
    );
  }

  List<StatusProbeScenarioItem> _xdripCore() {
    return [
      _probe('xdrip', 'xdrip.package.visible'),
      _probe(
        'xdrip',
        'xdrip.broadcast.bg_estimate',
        weight: 3,
        hardGate: true,
        scoreCap: 45,
      ),
      _probe(
        'xdrip',
        'xdrip.broadcast.freshness',
        weight: 3,
        hardGate: true,
        scoreCap: 55,
      ),
    ];
  }

  List<StatusProbeScenarioItem> _jugglucoPath() {
    return [
      _probe(
        'juggluco',
        'juggluco.package.visible',
        activationProbe: true,
      ),
      _probe('juggluco', 'juggluco.broadcast.glucodata_minute'),
      _probe(
        'juggluco',
        'juggluco.broadcast.xdrip_compatible',
        weight: 3,
        hardGate: true,
        scoreCap: 50,
      ),
      _probe(
        'juggluco',
        'juggluco.broadcast.freshness',
        weight: 2,
      ),
    ];
  }

  List<StatusProbeScenarioItem> _nightscoutPath() {
    return [
      _probe(
        'nightscout',
        'nightscout.status.reachable',
        weight: 2,
        hardGate: true,
        scoreCap: 55,
      ),
      _probe(
        'nightscout',
        'nightscout.entries.freshness',
        weight: 3,
        hardGate: true,
        scoreCap: 60,
      ),
      _probe('nightscout', 'nightscout.devicestatus.visible'),
      _probe('nightscout', 'nightscout.response_time'),
    ];
  }

  List<StatusProbeScenarioItem> _aapsPath() {
    return [
      _probe(
        'aaps',
        'aaps.package.visible',
        activationProbe: true,
      ),
      _probe(
        'aaps',
        'aaps.bg_source.xdrip_evidence',
        weight: 3,
        hardGate: true,
        scoreCap: 45,
      ),
      _probe(
        'aaps',
        'aaps.xdrip.output_evidence',
        weight: 2,
      ),
      _probe('aaps', 'aaps.devicestatus.evidence'),
      _probe('aaps', 'aaps.loop.context_evidence'),
    ];
  }

  List<StatusProbeScenarioItem> _watchPath() {
    return [
      _probe(
        'watch',
        'watch.bridge.package',
        activationProbe: true,
      ),
      _probe(
        'watch',
        'watch.xdrip_web_service.reachable',
        weight: 3,
        hardGate: true,
        scoreCap: 45,
      ),
      _probe(
        'watch',
        'watch.xdrip_web_service.entries',
        weight: 3,
        hardGate: true,
        scoreCap: 50,
      ),
      _probe('watch', 'watch.display.evidence'),
    ];
  }

  bool _isActivationProbe(String probeId) {
    return switch (probeId) {
      'juggluco.package.visible' ||
      'aaps.package.visible' ||
      'watch.bridge.package' =>
        true,
      _ => false,
    };
  }

  String? _guideRouteFor({
    required String probeId,
    required String suiteId,
  }) {
    return switch (probeId) {
      'common.network.connectivity' ||
      'common.internet.validated' ||
      'common.battery.optimization' =>
        '/explore/status/probe/nightscout-guide',
      'common.bluetooth.enabled' ||
      'common.bluetooth.permission' ||
      'common.notification.permission' ||
      'common.runtime.background' =>
        '/explore/status/probe/xdrip-guide',
      'xdrip.package.visible' ||
      'xdrip.broadcast.bg_estimate' ||
      'xdrip.broadcast.freshness' =>
        '/explore/status/probe/xdrip-guide',
      'juggluco.package.visible' ||
      'juggluco.broadcast.glucodata_minute' ||
      'juggluco.broadcast.xdrip_compatible' ||
      'juggluco.broadcast.freshness' =>
        '/explore/status/probe/juggluco-guide',
      'nightscout.status.reachable' ||
      'nightscout.entries.freshness' ||
      'nightscout.devicestatus.visible' ||
      'nightscout.response_time' =>
        '/explore/status/probe/nightscout-guide',
      'aaps.package.visible' ||
      'aaps.bg_source.xdrip_evidence' ||
      'aaps.xdrip.output_evidence' ||
      'aaps.devicestatus.evidence' ||
      'aaps.loop.context_evidence' =>
        '/explore/status/probe/aaps-guide',
      'watch.bridge.package' ||
      'watch.xdrip_web_service.reachable' ||
      'watch.xdrip_web_service.entries' ||
      'watch.display.evidence' =>
        '/explore/status/probe/watch-guide',
      _ => _guideRouteForSuite(suiteId),
    };
  }

  String? _guideRouteForSuite(String suiteId) {
    return switch (suiteId) {
      'xdrip' => '/explore/status/probe/xdrip-guide',
      'juggluco' => '/explore/status/probe/juggluco-guide',
      'nightscout' => '/explore/status/probe/nightscout-guide',
      'aaps' => '/explore/status/probe/aaps-guide',
      'watch' => '/explore/status/probe/watch-guide',
      _ => null,
    };
  }

  StatusProbePathRole _roleFor(String suiteId) {
    return switch (suiteId) {
      'common' || 'xdrip' || 'nightscout' => StatusProbePathRole.core,
      'juggluco' || 'aaps' || 'watch' => StatusProbePathRole.optional,
      _ => StatusProbePathRole.support,
    };
  }

  StatusProbeScoreScope _scopeFor(String suiteId) {
    return switch (suiteId) {
      'common' || 'xdrip' || 'nightscout' => StatusProbeScoreScope.included,
      'juggluco' || 'aaps' || 'watch' => StatusProbeScoreScope.excluded,
      _ => StatusProbeScoreScope.informational,
    };
  }
}
