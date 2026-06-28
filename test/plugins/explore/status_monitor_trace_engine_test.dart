import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/component_evidence/status_component_probe_mapping.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/trace/status_evidence_trace_engine.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_category.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_definition.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_evidence.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_evidence_bundle.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_id.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_kind.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_result.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_run_mode.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_source_ref.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_state.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_suite_definition.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe/status_probe_suite_result.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/probe_scenario/status_probe_scenario_id.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_component_kind.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/trace/status_evidence_trace_kind.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/trace/status_evidence_trace_scope.dart';

void main() {
  test('trace engine maps probe bundle and attaches scenario scope', () {
    final now = DateTime(2026, 6, 28, 9);
    final bundle = _bundle(now);

    final chain = const StatusEvidenceTraceEngine().fromProbeBundle(
      bundle,
      scenarioId: const StatusProbeScenarioId('xdrip_core'),
      scenarioScore: 88,
    );

    final trace = chain.traceForProbe('xdrip.broadcast.freshness');
    expect(trace, isNotNull);
    expect(trace!.kind, StatusEvidenceTraceKind.scenario);
    expect(trace.scope, StatusEvidenceTraceScope.scenario);
    expect(trace.scenarioId, 'xdrip_core');
    expect(trace.source.sourceId, 'com.eveningoutpost.dexdrip.BgEstimate');
    expect(trace.steps.map((step) => step.kind),
        contains(StatusEvidenceTraceKind.scenario));
  });

  test('component evidence mapping preserves probe trace lineage', () {
    final now = DateTime(2026, 6, 28, 9);
    final snapshots = const StatusComponentProbeMapping().map(_bundle(now));

    final xdrip = snapshots.firstWhere(
      (snapshot) => snapshot.kind == StatusComponentKind.xdrip,
    );
    final fact = xdrip.facts.firstWhere(
      (item) => item.id == 'xdrip.broadcast.freshness',
    );

    expect(
        xdrip.traceChain.traceForProbe('xdrip.broadcast.freshness'), isNotNull);
    expect(fact.trace.kind, StatusEvidenceTraceKind.componentEvidence);
    expect(fact.trace.componentKind, StatusComponentKind.xdrip.queryValue);
    expect(fact.trace.steps.map((step) => step.kind),
        contains(StatusEvidenceTraceKind.componentEvidence));
  });
}

StatusProbeEvidenceBundle _bundle(DateTime now) {
  final results = [
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
  ];
  return StatusProbeEvidenceBundle(
    subjectId: 'self',
    generatedAt: now,
    suites: [
      StatusProbeSuiteResult(
        definition: StatusProbeSuiteDefinition(
          id: 'xdrip',
          label: 'xDrip+',
          kind: StatusProbeKind.xdrip,
          probes: results.map((item) => item.definition).toList(),
        ),
        state: StatusProbeState.healthy,
        summary: 'xDrip+ observed',
        observedAt: now,
        latestUsefulEvidenceAt: now,
        confidence: 1,
        results: results,
      ),
    ],
  );
}

StatusProbeResult _result(
  String id,
  String suiteId,
  StatusProbeKind kind,
  DateTime now,
) {
  return StatusProbeResult(
    definition: StatusProbeDefinition(
      id: StatusProbeId(id),
      suiteId: suiteId,
      label: id,
      kind: kind,
      category: StatusProbeCategory.broadcast,
      runMode: StatusProbeRunMode.passive,
    ),
    state: StatusProbeState.healthy,
    observedAt: now,
    confidence: .94,
    runMode: StatusProbeRunMode.passive,
    summary: 'Observed',
    evidence: [
      StatusProbeEvidence(
        label: 'latest',
        value: '2m',
        observedAt: now,
      ),
    ],
    sourceRefs: const [
      StatusProbeSourceRef(
        source: 'android_broadcast',
        path: 'xdrip.latestBroadcastAt',
        detail: 'com.eveningoutpost.dexdrip.BgEstimate',
      ),
    ],
  );
}
