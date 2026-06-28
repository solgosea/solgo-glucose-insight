import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/hub/facts/status_hub_probe_fact_adapter.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/hub/status_hub_engine.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/hub/status_hub_engine_input.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/hub/status_hub_enums.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/hub/status_hub_models.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_category.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_definition.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_evidence.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_evidence_bundle.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_id.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_kind.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_result.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_run_mode.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_state.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_suite_definition.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_suite_result.dart';

void main() {
  test('Hub facts are built from probe evidence bundle', () {
    final now = DateTime(2026, 6, 18, 12);
    final facts = const StatusHubProbeFactAdapter().build(
      _bundle(now),
      now: now,
    );

    expect(facts.sourceKind, 'probe');
    expect(facts.xdrip.localBroadcastObserved, isTrue);
    expect(facts.juggluco.xdripCompatiblePathObserved, isTrue);
    expect(facts.aaps.xdripBgSourceObserved, isTrue);
    expect(facts.nightscout.medianResponseMs, 42);
    expect(
      facts.xdrip.component.evidence.first.source.kind,
      StatusHubSourceKind.probeEvidence,
    );
    expect(facts.traceChain.traces, isNotEmpty);
    expect(
      facts.xdrip.component.traceChain.traceForProbe(
        'xdrip.broadcast.freshness',
      ),
      isNotNull,
    );
    expect(
      facts.xdrip.component.evidence.first.trace.probeId,
      isNotNull,
    );
  });

  test('Hub engine consumes probe-derived facts without StatusReport', () {
    final now = DateTime(2026, 6, 18, 12);
    final facts = const StatusHubProbeFactAdapter().build(
      _bundle(now),
      now: now,
    );
    final report = const StatusHubEngine()
        .run(StatusHubEngineInput(facts: facts, now: now))
        .report;

    expect(
        report.nodes.map((node) => node.id), contains(StatusHubNodeId.xdrip));
    expect(
      report.connections.map((item) => item.id),
      contains(StatusHubConnectionId.xdripToAaps),
    );
    final aaps = report.connections.firstWhere(
      (item) => item.id == StatusHubConnectionId.xdripToAaps,
    );
    expect(aaps.diagnosisReason, StatusHubPathDiagnosisReason.bgSourceObserved);
    expect(
        aaps.evidence.any(
            (item) => item.source.kind == StatusHubSourceKind.probeEvidence),
        isTrue);
    expect(report.traceChain.traces, isNotEmpty);
    expect(aaps.traceChain.traceForProbe('aaps.bg_source.xdrip_evidence'),
        isNotNull);
  });
}

StatusProbeEvidenceBundle _bundle(DateTime now) {
  return StatusProbeEvidenceBundle(
    subjectId: 'self',
    generatedAt: now,
    suites: [
      _suite(
        id: 'xdrip',
        kind: StatusProbeKind.xdrip,
        now: now,
        results: [
          _result('xdrip.package.visible', 'xdrip', StatusProbeKind.xdrip, now),
          _result(
            'xdrip.broadcast.bg_estimate',
            'xdrip',
            StatusProbeKind.xdrip,
            now,
          ),
          _result(
            'xdrip.broadcast.freshness',
            'xdrip',
            StatusProbeKind.xdrip,
            now,
          ),
        ],
      ),
      _suite(
        id: 'juggluco',
        kind: StatusProbeKind.juggluco,
        now: now,
        results: [
          _result(
            'juggluco.package.visible',
            'juggluco',
            StatusProbeKind.juggluco,
            now,
          ),
          _result(
            'juggluco.broadcast.glucodata_minute',
            'juggluco',
            StatusProbeKind.juggluco,
            now,
          ),
          _result(
            'juggluco.broadcast.xdrip_compatible',
            'juggluco',
            StatusProbeKind.juggluco,
            now,
          ),
          _result(
            'juggluco.broadcast.freshness',
            'juggluco',
            StatusProbeKind.juggluco,
            now,
          ),
        ],
      ),
      _suite(
        id: 'nightscout',
        kind: StatusProbeKind.nightscout,
        now: now,
        results: [
          _result(
            'nightscout.status.reachable',
            'nightscout',
            StatusProbeKind.nightscout,
            now,
            elapsed: const Duration(milliseconds: 42),
          ),
          _result(
            'nightscout.entries.freshness',
            'nightscout',
            StatusProbeKind.nightscout,
            now,
          ),
          _result(
            'nightscout.devicestatus.visible',
            'nightscout',
            StatusProbeKind.nightscout,
            now,
          ),
          _result(
            'nightscout.response_time',
            'nightscout',
            StatusProbeKind.nightscout,
            now,
            elapsed: const Duration(milliseconds: 42),
          ),
        ],
      ),
      _suite(
        id: 'aaps',
        kind: StatusProbeKind.aaps,
        now: now,
        results: [
          _result('aaps.package.visible', 'aaps', StatusProbeKind.aaps, now),
          _result(
            'aaps.bg_source.xdrip_evidence',
            'aaps',
            StatusProbeKind.aaps,
            now,
          ),
          _result(
            'aaps.xdrip.output_evidence',
            'aaps',
            StatusProbeKind.aaps,
            now,
          ),
          _result(
            'aaps.devicestatus.evidence',
            'aaps',
            StatusProbeKind.aaps,
            now,
          ),
          _result(
            'aaps.loop.context_evidence',
            'aaps',
            StatusProbeKind.aaps,
            now,
          ),
        ],
      ),
    ],
  );
}

StatusProbeSuiteResult _suite({
  required String id,
  required StatusProbeKind kind,
  required DateTime now,
  required List<StatusProbeResult> results,
}) {
  return StatusProbeSuiteResult(
    definition: StatusProbeSuiteDefinition(
      id: id,
      label: id,
      kind: kind,
      probes: results.map((item) => item.definition).toList(),
    ),
    state: StatusProbeState.healthy,
    summary: '$id healthy',
    observedAt: now,
    latestUsefulEvidenceAt: now,
    confidence: 1,
    results: results,
  );
}

StatusProbeResult _result(
  String id,
  String suiteId,
  StatusProbeKind kind,
  DateTime now, {
  Duration? elapsed,
}) {
  return StatusProbeResult(
    definition: StatusProbeDefinition(
      id: StatusProbeId(id),
      suiteId: suiteId,
      label: id,
      kind: kind,
      category: StatusProbeCategory.broadcast,
      runMode: StatusProbeRunMode.active,
    ),
    state: StatusProbeState.healthy,
    observedAt: now,
    confidence: 1,
    runMode: StatusProbeRunMode.active,
    summary: 'Observed',
    elapsed: elapsed,
    evidence: [
      StatusProbeEvidence(
        label: id,
        value: 'Observed',
        observedAt: now,
      ),
    ],
  );
}
