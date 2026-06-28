import '../../domain/component_evidence/status_component_evidence_fact.dart';
import '../../domain/component_evidence/status_component_evidence_snapshot.dart';
import '../../domain/component_evidence/status_component_evidence_source_ref.dart';
import '../../domain/component_evidence/status_component_evidence_state.dart';
import '../../domain/probe/status_probe_evidence_bundle.dart';
import '../../domain/probe/status_probe_result.dart';
import '../../domain/probe/status_probe_state.dart';
import '../../domain/trace/status_evidence_trace.dart';
import '../../domain/trace/status_evidence_trace_chain.dart';
import '../../domain/status_component_kind.dart';
import '../trace/adapters/status_component_trace_adapter.dart';
import '../trace/status_evidence_trace_engine.dart';

class StatusComponentProbeMapping {
  final StatusEvidenceTraceEngine traceEngine;
  final StatusComponentTraceAdapter componentTraceAdapter;

  const StatusComponentProbeMapping({
    this.traceEngine = const StatusEvidenceTraceEngine(),
    this.componentTraceAdapter = const StatusComponentTraceAdapter(),
  });

  List<StatusComponentEvidenceSnapshot> map(StatusProbeEvidenceBundle? bundle) {
    if (bundle == null) return const [];
    final traceChain = traceEngine.fromProbeBundle(bundle);
    return [
      _snapshot(
        kind: StatusComponentKind.xdrip,
        bundle: bundle,
        traceChain: traceChain,
        suiteId: 'xdrip',
        probeIds: const [
          'xdrip.package.visible',
          'xdrip.broadcast.bg_estimate',
          'xdrip.broadcast.freshness',
        ],
      ),
      _snapshot(
        kind: StatusComponentKind.juggluco,
        bundle: bundle,
        traceChain: traceChain,
        suiteId: 'juggluco',
        probeIds: const [
          'juggluco.package.visible',
          'juggluco.broadcast.glucodata_minute',
          'juggluco.broadcast.xdrip_compatible',
          'juggluco.broadcast.freshness',
        ],
      ),
      _snapshot(
        kind: StatusComponentKind.nightscout,
        bundle: bundle,
        traceChain: traceChain,
        suiteId: 'nightscout',
        probeIds: const [
          'nightscout.status.reachable',
          'nightscout.entries.freshness',
          'nightscout.devicestatus.visible',
          'nightscout.response_time',
        ],
      ),
      _snapshot(
        kind: StatusComponentKind.aapsLoop,
        bundle: bundle,
        traceChain: traceChain,
        suiteId: 'aaps',
        probeIds: const [
          'aaps.package.visible',
          'aaps.bg_source.xdrip_evidence',
          'aaps.xdrip.output_evidence',
          'aaps.devicestatus.evidence',
          'aaps.loop.context_evidence',
        ],
      ),
      _snapshot(
        kind: StatusComponentKind.watchDisplay,
        bundle: bundle,
        traceChain: traceChain,
        suiteId: 'watch',
        probeIds: const [
          'watch.bridge.package',
          'watch.xdrip_web_service.reachable',
          'watch.xdrip_web_service.entries',
          'watch.display.evidence',
        ],
      ),
      _snapshot(
        kind: StatusComponentKind.cgmSensor,
        bundle: bundle,
        traceChain: traceChain,
        suiteId: 'xdrip',
        probeIds: const [
          'xdrip.broadcast.bg_estimate',
          'xdrip.broadcast.freshness',
          'nightscout.entries.freshness',
        ],
      ),
    ];
  }

  StatusComponentEvidenceSnapshot _snapshot({
    required StatusComponentKind kind,
    required StatusProbeEvidenceBundle bundle,
    required StatusEvidenceTraceChain traceChain,
    required String suiteId,
    required List<String> probeIds,
  }) {
    final suite = bundle.suite(suiteId);
    final allResults = bundle.suites.expand((suite) => suite.results).toList();
    final facts = probeIds
        .map((id) =>
            allResults.where((result) => result.probeId == id).firstOrNull)
        .whereType<StatusProbeResult>()
        .map((result) => _fact(result, kind, traceChain))
        .toList(growable: false);
    final latest = facts
        .map((fact) => fact.observedAt)
        .whereType<DateTime>()
        .fold<DateTime?>(null, (latest, next) {
      if (latest == null) return next;
      return next.isAfter(latest) ? next : latest;
    });
    return StatusComponentEvidenceSnapshot(
      kind: kind,
      state: _aggregateState(facts),
      latestObservedAt: latest ?? suite?.latestUsefulEvidenceAt,
      confidence: facts.isEmpty ? (suite?.confidence ?? 0) : _average(facts),
      facts: facts,
      traceChain: StatusEvidenceTraceChain(
        traces: facts.map((fact) => fact.trace).toList(growable: false),
      ),
    );
  }

  StatusComponentEvidenceFact _fact(
    StatusProbeResult result,
    StatusComponentKind kind,
    StatusEvidenceTraceChain traceChain,
  ) {
    final probeTrace =
        traceChain.traceForProbe(result.probeId) ?? StatusEvidenceTrace.empty;
    final trace = componentTraceAdapter.attachComponent(
      trace: probeTrace,
      componentKind: kind,
      factId: result.probeId,
    );
    return StatusComponentEvidenceFact(
      id: result.probeId,
      label: result.definition.label,
      valueLabel: result.summary,
      state: _state(result.state),
      observedAt: result.observedAt,
      confidence: result.confidence,
      source: StatusComponentEvidenceSourceRef.probe(
        probeId: result.probeId,
        probeSource: result.sourceRefs.isEmpty ? null : result.sourceRefs.first,
      ),
      trace: trace,
    );
  }

  StatusComponentEvidenceState _aggregateState(
    List<StatusComponentEvidenceFact> facts,
  ) {
    if (facts.isEmpty) return StatusComponentEvidenceState.unknown;
    if (facts.any((fact) => fact.state == StatusComponentEvidenceState.issue)) {
      return StatusComponentEvidenceState.issue;
    }
    if (facts.any((fact) => fact.state == StatusComponentEvidenceState.watch)) {
      return StatusComponentEvidenceState.watch;
    }
    if (facts.any((fact) =>
        fact.state == StatusComponentEvidenceState.notObserved ||
        fact.state == StatusComponentEvidenceState.notConfigured)) {
      return StatusComponentEvidenceState.notObserved;
    }
    if (facts
        .any((fact) => fact.state == StatusComponentEvidenceState.unknown)) {
      return StatusComponentEvidenceState.unknown;
    }
    return StatusComponentEvidenceState.healthy;
  }

  StatusComponentEvidenceState _state(StatusProbeState state) {
    return switch (state) {
      StatusProbeState.healthy => StatusComponentEvidenceState.healthy,
      StatusProbeState.watch => StatusComponentEvidenceState.watch,
      StatusProbeState.issue => StatusComponentEvidenceState.issue,
      StatusProbeState.notObserved => StatusComponentEvidenceState.notObserved,
      StatusProbeState.notConfigured =>
        StatusComponentEvidenceState.notConfigured,
      StatusProbeState.waiting ||
      StatusProbeState.unknown =>
        StatusComponentEvidenceState.unknown,
    };
  }

  double _average(List<StatusComponentEvidenceFact> facts) {
    if (facts.isEmpty) return 0;
    return facts.fold<double>(0, (sum, fact) => sum + fact.confidence) /
        facts.length;
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return null;
    return iterator.current;
  }
}
