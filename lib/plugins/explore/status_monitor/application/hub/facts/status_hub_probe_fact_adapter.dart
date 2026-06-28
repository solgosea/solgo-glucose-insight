import '../../../domain/hub/facts/aaps_hub_facts.dart';
import '../../../domain/hub/facts/cgm_hub_facts.dart';
import '../../../domain/hub/facts/juggluco_hub_facts.dart';
import '../../../domain/hub/facts/nightscout_hub_facts.dart';
import '../../../domain/hub/facts/status_hub_component_facts.dart';
import '../../../domain/hub/facts/status_hub_fact_bundle.dart';
import '../../../domain/hub/facts/watch_hub_facts.dart';
import '../../../domain/hub/facts/xdrip_hub_facts.dart';
import '../../../domain/hub/status_hub_enums.dart';
import '../../../domain/hub/status_hub_models.dart';
import '../../../domain/probe/status_probe_evidence_bundle.dart';
import '../../../domain/probe/status_probe_result.dart';
import '../../../domain/probe/status_probe_state.dart';
import '../../../domain/probe/status_probe_suite_result.dart';
import '../../../domain/status_component_kind.dart';
import '../../../domain/status_level.dart';
import '../../../domain/trace/status_evidence_trace.dart';
import '../../../domain/trace/status_evidence_trace_chain.dart';
import '../../trace/adapters/status_hub_trace_adapter.dart';
import '../../trace/status_evidence_trace_engine.dart';

class StatusHubProbeFactAdapter {
  final StatusEvidenceTraceEngine traceEngine;
  final StatusHubTraceAdapter hubTraceAdapter;

  const StatusHubProbeFactAdapter({
    this.traceEngine = const StatusEvidenceTraceEngine(),
    this.hubTraceAdapter = const StatusHubTraceAdapter(),
  });

  StatusHubFactBundle build(StatusProbeEvidenceBundle bundle, {DateTime? now}) {
    final effectiveNow = now ?? bundle.generatedAt;
    final traceChain = traceEngine.fromProbeBundle(bundle);
    final cgm = _cgm(bundle, effectiveNow, traceChain);
    final juggluco = _juggluco(bundle, effectiveNow, traceChain);
    final xdrip = _xdrip(bundle, effectiveNow, traceChain);
    final nightscout = _nightscout(bundle, effectiveNow, traceChain);
    final aaps = _aaps(bundle, effectiveNow, traceChain);
    final watch = _watch(bundle, effectiveNow, traceChain);
    return StatusHubFactBundle(
      generatedAt: bundle.generatedAt,
      sourceKind: 'probe',
      sourceLabel: 'Probe evidence',
      cgm: cgm,
      juggluco: juggluco,
      xdrip: xdrip,
      nightscout: nightscout,
      aaps: aaps,
      watch: watch,
      traceChain: traceChain,
    );
  }

  CgmHubFacts _cgm(
    StatusProbeEvidenceBundle bundle,
    DateTime now,
    StatusEvidenceTraceChain traceChain,
  ) {
    final xdripFreshness = _probe(bundle, 'xdrip.broadcast.freshness');
    final xdripBg = _probe(bundle, 'xdrip.broadcast.bg_estimate');
    final source = xdripFreshness ?? xdripBg;
    final component = _component(
      kind: StatusComponentKind.cgmSensor,
      nodeId: StatusHubNodeId.cgmSensor,
      role: StatusHubNodeRole.source,
      label: 'CGM Sensor',
      expectedEvidence: 2,
      now: now,
      suite: bundle.suite('xdrip'),
      traceChain: traceChain,
      results:
          [xdripBg, xdripFreshness].whereType<StatusProbeResult>().toList(),
      primary: source,
      evidenceOverrides: [
        _evidenceFromProbe(
          xdripFreshness,
          id: 'sensor_freshness',
          label: 'latest reading',
          traceChain: traceChain,
        ),
        _evidenceFromProbe(
          xdripBg,
          id: 'signal_continuity',
          label: 'continuity',
          traceChain: traceChain,
        ),
      ].whereType<StatusHubEvidenceRef>().toList(),
    );
    return CgmHubFacts(
      component: component,
      latestReadingAgeLabel: _ageLabel(component.age),
      sourceModeLabel: 'xDrip+ local broadcast',
    );
  }

  JugglucoHubFacts _juggluco(
    StatusProbeEvidenceBundle bundle,
    DateTime now,
    StatusEvidenceTraceChain traceChain,
  ) {
    final packageProbe = _probe(bundle, 'juggluco.package.visible');
    final glucodata = _probe(bundle, 'juggluco.broadcast.glucodata_minute');
    final compatible = _probe(
      bundle,
      'juggluco.broadcast.xdrip_compatible',
    );
    final freshness = _probe(bundle, 'juggluco.broadcast.freshness');
    final compatibleObserved = _healthyish(compatible);
    final latest = freshness ?? compatible ?? glucodata ?? packageProbe;
    final component = _component(
      kind: StatusComponentKind.juggluco,
      nodeId: StatusHubNodeId.juggluco,
      role: StatusHubNodeRole.source,
      label: 'Juggluco',
      expectedEvidence: 4,
      now: now,
      suite: bundle.suite('juggluco'),
      traceChain: traceChain,
      results: [
        packageProbe,
        glucodata,
        compatible,
        freshness,
      ].whereType<StatusProbeResult>().toList(),
      primary: latest,
      evidenceOverrides: [
        _evidenceFromProbe(
          freshness,
          id: 'juggluco_broadcast_freshness',
          label: 'broadcast age',
          traceChain: traceChain,
        ),
        _evidenceFromProbe(
          compatible,
          id: 'juggluco_xdrip_handoff',
          label: 'handoff',
          traceChain: traceChain,
        ),
        _evidenceFromProbe(
          glucodata,
          id: 'juggluco_glucodata',
          label: 'direct broadcast',
          traceChain: traceChain,
        ),
      ].whereType<StatusHubEvidenceRef>().toList(),
      detail: {
        'xdripCompatiblePathObserved': compatibleObserved,
        'observedPathLabel': compatibleObserved
            ? 'xDrip-compatible broadcast'
            : _healthyish(glucodata)
                ? 'glucodata.Minute only'
                : 'No broadcast observed',
      },
    );
    return JugglucoHubFacts(
      component: component,
      xdripCompatiblePathObserved: compatibleObserved,
      hasXdripCompatiblePathEvidence: compatible != null,
      receiverLabel: 'com.metaguru.smartxdrip',
      latestLabel: _ageLabel(component.age),
      xdripAgeLabel: _ageLabel(_age(now, compatible)),
      nightscoutAgeLabel: 'Unknown',
      observedPathLabel: component.detail['observedPathLabel']?.toString() ??
          'No broadcast observed',
    );
  }

  XdripHubFacts _xdrip(
    StatusProbeEvidenceBundle bundle,
    DateTime now,
    StatusEvidenceTraceChain traceChain,
  ) {
    final packageProbe = _probe(bundle, 'xdrip.package.visible');
    final bg = _probe(bundle, 'xdrip.broadcast.bg_estimate');
    final freshness = _probe(bundle, 'xdrip.broadcast.freshness');
    final aapsOutput = _probe(bundle, 'aaps.xdrip.output_evidence');
    final primary = freshness ?? bg ?? packageProbe;
    final component = _component(
      kind: StatusComponentKind.xdrip,
      nodeId: StatusHubNodeId.xdrip,
      role: StatusHubNodeRole.hub,
      label: 'xDrip+',
      expectedEvidence: 4,
      now: now,
      suite: bundle.suite('xdrip'),
      traceChain: traceChain,
      results: [
        packageProbe,
        bg,
        freshness,
        aapsOutput,
      ].whereType<StatusProbeResult>().toList(),
      primary: primary,
      evidenceOverrides: [
        _evidenceFromProbe(
          freshness,
          id: 'completeness_24h',
          label: 'local BG freshness',
          traceChain: traceChain,
        ),
        _evidenceFromProbe(
          bg,
          id: 'xdrip_bg_broadcast',
          label: 'BG broadcast',
          traceChain: traceChain,
        ),
        _evidenceFromProbe(
          aapsOutput,
          id: 'xdrip_aaps_output',
          label: 'AAPS output',
          traceChain: traceChain,
        ),
      ].whereType<StatusHubEvidenceRef>().toList(),
      detail: {
        'broadcastReadiness': {
          'state':
              _healthyish(freshness) || _healthyish(bg) ? 'fresh' : 'waiting',
          'level': _levelForResult(freshness ?? bg).name,
          'stateLabel': _healthyish(freshness) || _healthyish(bg)
              ? 'Observed'
              : 'Not observed',
          'latestLabel': _ageLabel(_age(now, freshness ?? bg)),
          'receiverPackage': 'com.metaguru.smartxdrip',
        },
      },
    );
    final readiness = component.detail['broadcastReadiness'];
    final readinessMap =
        readiness is Map<String, Object?> ? readiness : const {};
    return XdripHubFacts(
      component: component,
      localBroadcastObserved: _healthyish(freshness) || _healthyish(bg),
      broadcastLevel: _levelForResult(freshness ?? bg),
      broadcastStateLabel: readinessMap['stateLabel']?.toString() ?? 'Unknown',
      broadcastLatestLabel:
          readinessMap['latestLabel']?.toString() ?? 'Unknown',
      receiverPackage: readinessMap['receiverPackage']?.toString() ??
          'com.metaguru.smartxdrip',
      modeLabel: 'Local broadcast observer',
    );
  }

  NightscoutHubFacts _nightscout(
    StatusProbeEvidenceBundle bundle,
    DateTime now,
    StatusEvidenceTraceChain traceChain,
  ) {
    final status = _probe(bundle, 'nightscout.status.reachable');
    final entries = _probe(bundle, 'nightscout.entries.freshness');
    final devicestatus = _probe(bundle, 'nightscout.devicestatus.visible');
    final response = _probe(bundle, 'nightscout.response_time');
    final primary = entries ?? status ?? response;
    final component = _component(
      kind: StatusComponentKind.nightscout,
      nodeId: StatusHubNodeId.nightscout,
      role: StatusHubNodeRole.cloud,
      label: 'Nightscout',
      expectedEvidence: 4,
      now: now,
      suite: bundle.suite('nightscout'),
      traceChain: traceChain,
      results: [
        status,
        entries,
        devicestatus,
        response,
      ].whereType<StatusProbeResult>().toList(),
      primary: primary,
      evidenceOverrides: [
        _evidenceFromProbe(
          entries,
          id: 'server_data_freshness',
          label: 'cloud reading',
          traceChain: traceChain,
        ),
        _evidenceFromProbe(
          status,
          id: 'api_reachable',
          label: 'API response',
          traceChain: traceChain,
        ),
        _evidenceFromProbe(
          devicestatus,
          id: 'devicestatus_visible',
          label: 'device status',
          traceChain: traceChain,
        ),
      ].whereType<StatusHubEvidenceRef>().toList(),
    );
    return NightscoutHubFacts(
      component: component,
      latestServerReadingLabel: _ageLabel(_age(now, entries)),
      medianResponseMs: _responseMs(response),
      timeoutCount: _levelForResult(response) == StatusLevel.issue ? 1 : 0,
    );
  }

  AapsHubFacts _aaps(
    StatusProbeEvidenceBundle bundle,
    DateTime now,
    StatusEvidenceTraceChain traceChain,
  ) {
    final packageProbe = _probe(bundle, 'aaps.package.visible');
    final bgSource = _probe(bundle, 'aaps.bg_source.xdrip_evidence');
    final devicestatus = _probe(bundle, 'aaps.devicestatus.evidence');
    final loop = _probe(bundle, 'aaps.loop.context_evidence');
    final primary = bgSource ?? loop ?? packageProbe;
    final bgObserved = _healthyish(bgSource);
    final component = _component(
      kind: StatusComponentKind.aapsLoop,
      nodeId: StatusHubNodeId.aaps,
      role: StatusHubNodeRole.loop,
      label: 'AAPS Loop',
      expectedEvidence: 4,
      now: now,
      suite: bundle.suite('aaps'),
      traceChain: traceChain,
      results: [
        packageProbe,
        bgSource,
        devicestatus,
        loop,
      ].whereType<StatusProbeResult>().toList(),
      primary: primary,
      evidenceOverrides: [
        _evidenceFromProbe(
          bgSource,
          id: 'aaps_sync_freshness',
          label: 'BG source',
          traceChain: traceChain,
        ),
        _evidenceFromProbe(
          loop,
          id: 'aaps_loop_context',
          label: 'context',
          traceChain: traceChain,
        ),
        _evidenceFromProbe(
          devicestatus,
          id: 'aaps_devicestatus',
          label: 'devicestatus',
          traceChain: traceChain,
        ),
      ].whereType<StatusHubEvidenceRef>().toList(),
      detail: {
        'xdripBgSource': {
          'state': bgObserved ? 'fresh' : 'waiting',
          'level': _levelForResult(bgSource).name,
          'stateLabel': bgObserved ? 'xDrip+ observed' : 'not observed',
        },
        'latestContextLabel': _ageLabel(_age(now, loop)),
      },
    );
    return AapsHubFacts(
      component: component,
      xdripBgSourceObserved: bgObserved,
      hasXdripBgSourceEvidence: bgSource != null,
      xdripBgSourceLevel: _levelForResult(bgSource),
      xdripBgSourceLabel: bgObserved ? 'xDrip+ observed' : 'not observed',
      latestContextLabel: _ageLabel(_age(now, loop)),
    );
  }

  WatchHubFacts _watch(
    StatusProbeEvidenceBundle bundle,
    DateTime now,
    StatusEvidenceTraceChain traceChain,
  ) {
    final packageProbe = _probe(bundle, 'watch.bridge.package');
    final reachable = _probe(bundle, 'watch.xdrip_web_service.reachable');
    final entries = _probe(bundle, 'watch.xdrip_web_service.entries');
    final display = _probe(bundle, 'watch.display.evidence');
    final primary = display ?? entries ?? reachable ?? packageProbe;
    final component = _component(
      kind: StatusComponentKind.watchDisplay,
      nodeId: StatusHubNodeId.watch,
      role: StatusHubNodeRole.display,
      label: 'Watch / Widget',
      expectedEvidence: 4,
      now: now,
      suite: bundle.suite('watch'),
      traceChain: traceChain,
      results: [
        packageProbe,
        reachable,
        entries,
        display,
      ].whereType<StatusProbeResult>().toList(),
      primary: primary,
      evidenceOverrides: [
        _evidenceFromProbe(
          packageProbe,
          id: 'watch_bridge',
          label: 'bridge',
          traceChain: traceChain,
        ),
        _evidenceFromProbe(
          reachable,
          id: 'watch_xdrip_web_service',
          label: 'xDrip+ Web Service',
          traceChain: traceChain,
        ),
        _evidenceFromProbe(
          entries,
          id: 'watch_entries',
          label: 'entries',
          traceChain: traceChain,
        ),
        _evidenceFromProbe(
          display,
          id: 'watch_display',
          label: 'display',
          traceChain: traceChain,
        ),
      ].whereType<StatusHubEvidenceRef>().toList(),
    );
    return WatchHubFacts(
      component: component,
      bridgePackageObserved: _healthyish(packageProbe),
      webServiceReachable: _healthyish(reachable),
      entriesObserved: _healthyish(entries),
      displayObserved: _healthyish(display),
      latestDisplayLabel: _ageLabel(_age(now, display)),
    );
  }

  StatusHubComponentFacts _component({
    required StatusComponentKind kind,
    required StatusHubNodeId nodeId,
    required StatusHubNodeRole role,
    required String label,
    required int expectedEvidence,
    required DateTime now,
    required StatusProbeSuiteResult? suite,
    required StatusEvidenceTraceChain traceChain,
    required List<StatusProbeResult> results,
    required StatusProbeResult? primary,
    required List<StatusHubEvidenceRef> evidenceOverrides,
    Map<String, Object?> detail = const {},
  }) {
    final latest = _latestObservedAt(suite, results);
    final available = results
        .where((result) => result.state.hasUsefulEvidence)
        .length
        .clamp(0, expectedEvidence);
    final evidence = evidenceOverrides.isNotEmpty
        ? evidenceOverrides
        : results
            .map((result) => _evidenceFromProbe(
                  result,
                  traceChain: traceChain,
                ))
            .whereType<StatusHubEvidenceRef>()
            .toList(growable: false);
    final componentTraceChain = StatusEvidenceTraceChain(
      traces: results
          .map((result) => traceChain.traceForProbe(result.probeId))
          .whereType<StatusEvidenceTrace>()
          .toList(growable: false),
    );
    return StatusHubComponentFacts(
      nodeId: nodeId,
      kind: kind,
      label: label,
      role: role,
      state: _hubState(primary?.state ?? suite?.state),
      latestObservedAt: latest,
      age: latest == null ? null : now.difference(latest),
      confidence: _confidence(suite, results),
      availableEvidence: available,
      expectedEvidence: expectedEvidence,
      evidence: evidence,
      detailRoute: '/explore/status/component?kind=${kind.queryValue}',
      detail: detail,
      traceChain: componentTraceChain,
    );
  }

  StatusProbeResult? _probe(StatusProbeEvidenceBundle bundle, String id) {
    for (final suite in bundle.suites) {
      for (final result in suite.results) {
        if (result.probeId == id) return result;
      }
    }
    return null;
  }

  StatusHubEvidenceRef? _evidenceFromProbe(
    StatusProbeResult? result, {
    String? id,
    String? label,
    StatusEvidenceTraceChain traceChain = StatusEvidenceTraceChain.empty,
  }) {
    if (result == null) return null;
    final evidence = result.evidence.isNotEmpty ? result.evidence.first : null;
    final trace = hubTraceAdapter.attachHubEvidence(
      trace:
          traceChain.traceForProbe(result.probeId) ?? StatusEvidenceTrace.empty,
      evidenceId: id ?? result.probeId,
    );
    return StatusHubEvidenceRef(
      id: id ?? result.probeId,
      label: label ?? result.definition.label,
      valueLabel: evidence?.value ?? result.summary,
      level: _levelForResult(result),
      source: StatusHubSourceRef.probeEvidence(
        probeId: result.probeId,
        path: evidence?.label,
        available: result.state.hasUsefulEvidence,
      ),
      trace: trace,
    );
  }

  DateTime? _latestObservedAt(
    StatusProbeSuiteResult? suite,
    List<StatusProbeResult> results,
  ) {
    DateTime? latest = suite?.latestUsefulEvidenceAt;
    for (final result in results) {
      for (final evidence in result.evidence) {
        final observedAt = evidence.observedAt;
        if (observedAt == null) continue;
        if (latest == null || observedAt.isAfter(latest)) latest = observedAt;
      }
      if (result.state.hasUsefulEvidence &&
          (latest == null || result.observedAt.isAfter(latest))) {
        latest = result.observedAt;
      }
    }
    return latest;
  }

  Duration? _age(DateTime now, StatusProbeResult? result) {
    if (result == null || !result.state.hasUsefulEvidence) return null;
    DateTime? latest;
    for (final evidence in result.evidence) {
      final observedAt = evidence.observedAt;
      if (observedAt == null) continue;
      if (latest == null || observedAt.isAfter(latest)) latest = observedAt;
    }
    latest ??= result.observedAt;
    return now.difference(latest);
  }

  double _confidence(
    StatusProbeSuiteResult? suite,
    List<StatusProbeResult> results,
  ) {
    if (results.isEmpty) return suite?.confidence ?? 0;
    final values = results.map((result) => result.confidence).toList();
    return (values.reduce((a, b) => a + b) / values.length).clamp(0, 1);
  }

  bool _healthyish(StatusProbeResult? result) {
    return result?.state == StatusProbeState.healthy ||
        result?.state == StatusProbeState.watch;
  }

  StatusHubState _hubState(StatusProbeState? state) {
    return switch (state) {
      StatusProbeState.healthy => StatusHubState.fresh,
      StatusProbeState.watch => StatusHubState.delayed,
      StatusProbeState.issue => StatusHubState.stale,
      StatusProbeState.notConfigured => StatusHubState.unavailable,
      StatusProbeState.waiting ||
      StatusProbeState.notObserved =>
        StatusHubState.notChecked,
      StatusProbeState.unknown || null => StatusHubState.unknown,
    };
  }

  StatusLevel _levelForResult(StatusProbeResult? result) {
    return switch (result?.state) {
      StatusProbeState.healthy => StatusLevel.healthy,
      StatusProbeState.watch => StatusLevel.watch,
      StatusProbeState.issue => StatusLevel.issue,
      _ => StatusLevel.unknown,
    };
  }

  int? _responseMs(StatusProbeResult? result) {
    if (result?.elapsed == null) return null;
    return result!.elapsed!.inMilliseconds;
  }

  String _ageLabel(Duration? age) {
    if (age == null) return 'Unknown';
    if (age.inMinutes < 1) return 'just now';
    if (age.inHours < 1) return '${age.inMinutes}m';
    if (age.inDays < 1) return '${age.inHours}h';
    return '${age.inDays}d';
  }
}
