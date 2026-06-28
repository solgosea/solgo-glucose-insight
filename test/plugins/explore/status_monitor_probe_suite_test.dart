import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/domain/entities/glucose_reading.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/probe/suites/aaps/probes/aaps_xdrip_bg_source_evidence_probe.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/probe/suites/juggluco/probes/juggluco_broadcast_freshness_probe.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/probe/suites/juggluco/probes/juggluco_glucodata_broadcast_probe.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/probe/suites/nightscout/probes/nightscout_devicestatus_probe.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/probe/suites/nightscout/probes/nightscout_entries_freshness_probe.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/probe/suites/nightscout/probes/nightscout_response_time_probe.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/probe/suites/nightscout/probes/nightscout_status_reachable_probe.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/probe/suites/xdrip/probes/xdrip_bg_estimate_broadcast_probe.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/probe/suites/xdrip/probes/xdrip_broadcast_freshness_probe.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/probe/suites/xdrip/probes/xdrip_package_probe.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/probe/suites/watch/probes/watch_bridge_package_probe.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/probe/suites/watch/probes/watch_display_evidence_probe.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/status_monitor_target_resolution.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/data/sources/status_monitor_source_client.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/data/platform/aaps/aaps_evidence_bridge.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/data/platform/aaps/aaps_evidence_snapshot.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/data/platform/juggluco/juggluco_broadcast_bridge.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/data/platform/juggluco/juggluco_broadcast_snapshot.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/data/platform/watch/watch_evidence_bridge.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/data/platform/watch/watch_evidence_snapshot.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/data/platform/xdrip/xdrip_broadcast_bridge.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/data/platform/xdrip/xdrip_broadcast_snapshot.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/data/probe/platform/aaps_probe_platform_source.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/data/probe/platform/juggluco_probe_platform_source.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/data/probe/platform/package_probe_platform_source.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/data/probe/platform/package_probe_snapshot.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/data/probe/platform/watch_probe_platform_source.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/data/probe/platform/xdrip_probe_platform_source.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/juggluco/juggluco_broadcast_format.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/juggluco/juggluco_broadcast_path.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/juggluco/juggluco_broadcast_path_snapshot.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_context.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_state.dart';

void main() {
  test('xDrip broadcast probe reports not observed without passive evidence',
      () async {
    final now = DateTime(2026, 6, 26, 10);
    final probe = XdripBgEstimateBroadcastProbe(
      source: XdripProbePlatformSource(bridge: _FakeXdripBridge()),
    );

    final result = await probe.run(_context(now));

    expect(result.state, StatusProbeState.notObserved);
    expect(result.confidence, 0);
    expect(
        result.sourceRefs.first.path, 'com.eveningoutpost.dexdrip.BgEstimate');
  });

  test('xDrip broadcast and freshness probes report observed and stale states',
      () async {
    final now = DateTime(2026, 6, 26, 10);
    final freshSource = XdripProbePlatformSource(
      bridge: _FakeXdripBridge(
        snapshot: XdripBroadcastSnapshot(
          receiverConfigured: true,
          broadcastObserved: true,
          latestBroadcastAt: now.subtract(const Duration(minutes: 2)),
        ),
      ),
    );
    final staleSource = XdripProbePlatformSource(
      bridge: _FakeXdripBridge(
        snapshot: XdripBroadcastSnapshot(
          receiverConfigured: true,
          broadcastObserved: true,
          latestBroadcastAt: now.subtract(const Duration(minutes: 40)),
        ),
      ),
    );

    expect(
      (await XdripBgEstimateBroadcastProbe(source: freshSource)
              .run(_context(now)))
          .state,
      StatusProbeState.healthy,
    );
    expect(
      (await XdripBroadcastFreshnessProbe(source: freshSource)
              .run(_context(now)))
          .state,
      StatusProbeState.healthy,
    );
    expect(
      (await XdripBroadcastFreshnessProbe(source: staleSource)
              .run(_context(now)))
          .state
          .isProblem,
      isTrue,
    );
  });

  test('package probes distinguish visible and missing external apps',
      () async {
    final now = DateTime(2026, 6, 26, 10);
    final visibleSource = _FakePackageProbeSource(
      visiblePackages: {
        'jamorham.xdrip.plus.variant4',
        'com.thatguysservice.huami_xdrip'
      },
      now: now,
    );
    final missingSource =
        _FakePackageProbeSource(visiblePackages: {}, now: now);

    expect(
      (await XdripPackageProbe(source: visibleSource).run(_context(now))).state,
      StatusProbeState.healthy,
    );
    expect(
      (await WatchBridgePackageProbe(source: visibleSource).run(_context(now)))
          .state,
      StatusProbeState.healthy,
    );
    expect(
      (await WatchBridgePackageProbe(source: missingSource).run(_context(now)))
          .state,
      StatusProbeState.notObserved,
    );
  });

  test('Nightscout active probe is not configured without target', () async {
    final now = DateTime(2026, 6, 26, 10);
    final result = await NightscoutStatusReachableProbe().run(_context(now));

    expect(result.state, StatusProbeState.notConfigured);
    expect(result.confidence, 0);
  });

  test('Nightscout reachable, entries, and devicestatus map useful states',
      () async {
    final now = DateTime(2026, 6, 26, 10);
    final freshClient = _FakeStatusSourceClient(
      result: const StatusHttpResult(
        reachable: true,
        statusCode: 200,
        elapsed: Duration(milliseconds: 80),
        data: [
          {'created_at': 'now'}
        ],
      ),
      entries: [
        GlucoseReading(
          timestamp: now.subtract(const Duration(minutes: 1)),
          value: 6.1,
        ),
      ],
    );
    final emptyClient = _FakeStatusSourceClient(
      result: const StatusHttpResult(
        reachable: true,
        statusCode: 200,
        elapsed: Duration(milliseconds: 80),
        data: [],
      ),
    );
    final downClient = _FakeStatusSourceClient(
      result: const StatusHttpResult(
        reachable: false,
        elapsed: Duration(milliseconds: 80),
      ),
    );

    expect(
      (await NightscoutStatusReachableProbe(clientFactory: (_) => freshClient)
              .run(_nightscoutContext(now)))
          .state,
      StatusProbeState.healthy,
    );
    expect(
      (await NightscoutStatusReachableProbe(clientFactory: (_) => downClient)
              .run(_nightscoutContext(now)))
          .state,
      StatusProbeState.issue,
    );
    expect(
      (await NightscoutEntriesFreshnessProbe(clientFactory: (_) => freshClient)
              .run(_nightscoutContext(now)))
          .state,
      StatusProbeState.healthy,
    );
    expect(
      (await NightscoutEntriesFreshnessProbe(clientFactory: (_) => emptyClient)
              .run(_nightscoutContext(now)))
          .state,
      StatusProbeState.waiting,
    );
    expect(
      (await NightscoutDevicestatusProbe(clientFactory: (_) => freshClient)
              .run(_nightscoutContext(now)))
          .state,
      StatusProbeState.healthy,
    );
    expect(
      (await NightscoutDevicestatusProbe(clientFactory: (_) => emptyClient)
              .run(_nightscoutContext(now)))
          .state,
      StatusProbeState.unknown,
    );
  });

  test('Nightscout response time maps latency thresholds deterministically',
      () async {
    final now = DateTime(2026, 6, 26, 10);
    Future<StatusProbeState> run(Duration elapsed, {bool reachable = true}) {
      return NightscoutResponseTimeProbe(
        clientFactory: (_) => _FakeStatusSourceClient(
          result: StatusHttpResult(
            reachable: reachable,
            statusCode: reachable ? 200 : null,
            elapsed: elapsed,
          ),
        ),
      ).run(_nightscoutContext(now)).then((result) => result.state);
    }

    expect(
        await run(const Duration(milliseconds: 120)), StatusProbeState.healthy);
    expect(
        await run(const Duration(milliseconds: 900)), StatusProbeState.watch);
    expect(
        await run(const Duration(milliseconds: 3500)), StatusProbeState.issue);
    expect(await run(const Duration(milliseconds: 20), reachable: false),
        StatusProbeState.issue);
  });

  test(
      'AAPS BG source probe stays observational and does not require xDrip Web Service',
      () async {
    final now = DateTime(2026, 6, 26, 10);
    final result = await AapsXdripBgSourceEvidenceProbe(
      source: AapsProbePlatformSource(
        bridge: _FakeAapsBridge(
          snapshot: const AapsEvidenceSnapshot(
            receiverConfigured: true,
            evidenceObserved: false,
          ),
        ),
      ),
    ).run(_context(now));

    expect(result.state, StatusProbeState.notObserved);
    expect(result.sourceRefs.first.path, 'com.metaguru.probe.AAPS_CONTEXT');
    expect(result.summary, isNot(contains('Web Service')));
  });

  test('AAPS BG source probe becomes healthy from observed xDrip evidence',
      () async {
    final now = DateTime(2026, 6, 26, 10);
    final result = await AapsXdripBgSourceEvidenceProbe(
      source: AapsProbePlatformSource(
        bridge: _FakeAapsBridge(
          snapshot: AapsEvidenceSnapshot(
            receiverConfigured: true,
            evidenceObserved: true,
            latestEvidenceAt: now,
            bgSource: 'xdrip',
          ),
        ),
      ),
    ).run(_context(now));

    expect(result.state, StatusProbeState.healthy);
    expect(result.sourceRefs.first.path, 'aaps.bgSource');
    expect(result.summary, isNot(contains('Web Service')));
  });

  test('Juggluco broadcast probes distinguish direct evidence and stale data',
      () async {
    final now = DateTime(2026, 6, 26, 10);
    final freshSource = JugglucoProbePlatformSource(
      bridge: _FakeJugglucoBridge(
        snapshot: JugglucoBroadcastSnapshot(
          receiverConfigured: true,
          broadcastObserved: true,
          latestBroadcastAt: now.subtract(const Duration(minutes: 2)),
          latestByPath: [
            JugglucoBroadcastPathSnapshot(
              path: JugglucoBroadcastPath.glucodata,
              at: now.subtract(const Duration(minutes: 2)),
              glucose: 6.2,
              unit: 'mmol/L',
              format: JugglucoBroadcastFormat.glucodataMinute,
            ),
          ],
        ),
      ),
    );
    final emptySource = JugglucoProbePlatformSource(
      bridge: _FakeJugglucoBridge(
        snapshot: const JugglucoBroadcastSnapshot(
          receiverConfigured: true,
          broadcastObserved: false,
        ),
      ),
    );
    final staleSource = JugglucoProbePlatformSource(
      bridge: _FakeJugglucoBridge(
        snapshot: JugglucoBroadcastSnapshot(
          receiverConfigured: true,
          broadcastObserved: true,
          latestBroadcastAt: now.subtract(const Duration(minutes: 40)),
        ),
      ),
    );

    expect(
      (await JugglucoGlucodataBroadcastProbe(source: freshSource)
              .run(_context(now)))
          .state,
      StatusProbeState.healthy,
    );
    expect(
      (await JugglucoGlucodataBroadcastProbe(source: emptySource)
              .run(_context(now)))
          .state,
      StatusProbeState.notObserved,
    );
    expect(
      (await JugglucoBroadcastFreshnessProbe(source: staleSource)
              .run(_context(now)))
          .state
          .isProblem,
      isTrue,
    );
  });

  test('Watch display evidence probe maps observed and missing evidence',
      () async {
    final now = DateTime(2026, 6, 26, 10);
    final observed = WatchProbePlatformSource(
      bridge: _FakeWatchBridge(
        snapshot: WatchEvidenceSnapshot(
          receiverConfigured: true,
          evidenceObserved: true,
          displayObserved: true,
          latestEvidenceAt: now,
        ),
      ),
    );
    final missing = WatchProbePlatformSource(
      bridge: _FakeWatchBridge(
        snapshot: const WatchEvidenceSnapshot(
          receiverConfigured: true,
          evidenceObserved: false,
        ),
      ),
    );

    expect(
      (await WatchDisplayEvidenceProbe(source: observed).run(_context(now)))
          .state,
      StatusProbeState.healthy,
    );
    expect(
      (await WatchDisplayEvidenceProbe(source: missing).run(_context(now)))
          .state,
      StatusProbeState.notObserved,
    );
  });
}

StatusProbeContext _context(DateTime now) {
  return StatusProbeContext(
    subjectId: 'self',
    now: now,
    target: const StatusMonitorTargetResolution.none(subjectId: 'self'),
  );
}

StatusProbeContext _nightscoutContext(DateTime now) {
  return StatusProbeContext(
    subjectId: 'self',
    now: now,
    target: const StatusMonitorTargetResolution(
      subjectId: 'self',
      sourceKind: StatusMonitorTargetSourceKind.nightscout,
      sourceLabel: 'Nightscout',
      baseUrl: 'http://127.0.0.1:14120',
      enabled: true,
    ),
  );
}

class _FakeXdripBridge implements XdripBroadcastBridge {
  final XdripBroadcastSnapshot snapshot;

  const _FakeXdripBridge({
    this.snapshot = const XdripBroadcastSnapshot(
      receiverConfigured: true,
      broadcastObserved: false,
    ),
  });

  @override
  bool get isSupported => true;

  @override
  Future<XdripBroadcastSnapshot> latest() async {
    return snapshot;
  }
}

class _FakeAapsBridge implements AapsEvidenceBridge {
  final AapsEvidenceSnapshot snapshot;

  const _FakeAapsBridge({required this.snapshot});

  @override
  bool get isSupported => true;

  @override
  Future<AapsEvidenceSnapshot> latest() async => snapshot;
}

class _FakeStatusSourceClient implements StatusMonitorSourceClient {
  final StatusHttpResult result;
  final List<GlucoseReading> entries;

  const _FakeStatusSourceClient({
    required this.result,
    this.entries = const [],
  });

  @override
  Future<StatusHttpResult> checkService() async => result;

  @override
  Future<StatusHttpResult> get(
    String path, {
    Map<String, Object?>? queryParameters,
  }) async =>
      result;

  @override
  Future<List<GlucoseReading>> loadEntries24h(DateTime now) async => entries;
}

class _FakeJugglucoBridge implements JugglucoBroadcastBridge {
  final JugglucoBroadcastSnapshot snapshot;

  const _FakeJugglucoBridge({required this.snapshot});

  @override
  bool get isSupported => true;

  @override
  Future<JugglucoBroadcastSnapshot> latest() async => snapshot;
}

class _FakeWatchBridge implements WatchEvidenceBridge {
  final WatchEvidenceSnapshot snapshot;

  const _FakeWatchBridge({
    required this.snapshot,
  });

  @override
  bool get isSupported => true;

  @override
  Future<WatchEvidenceSnapshot> latest() async => snapshot;
}

class _FakePackageProbeSource extends PackageProbePlatformSource {
  final Set<String> visiblePackages;
  final DateTime now;

  const _FakePackageProbeSource({
    required this.visiblePackages,
    required this.now,
  });

  @override
  Future<PackageProbeSnapshot> query(String packageName) async {
    final visible = visiblePackages.contains(packageName);
    return PackageProbeSnapshot(
      packageName: packageName,
      visible: visible,
      installed: visible,
      versionName: visible ? '1.0' : null,
      versionCode: visible ? 1 : null,
      checkedAt: now,
    );
  }
}
