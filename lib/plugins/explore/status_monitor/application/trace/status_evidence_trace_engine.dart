import '../../domain/probe/status_probe_evidence_bundle.dart';
import '../../domain/probe_scenario/status_probe_scenario_id.dart';
import '../../domain/trace/status_evidence_trace_chain.dart';
import 'adapters/status_probe_trace_adapter.dart';
import 'adapters/status_scenario_trace_adapter.dart';
import 'status_trace_chain_builder.dart';

class StatusEvidenceTraceEngine {
  final StatusProbeTraceAdapter probeAdapter;
  final StatusScenarioTraceAdapter scenarioAdapter;
  final StatusTraceChainBuilder chainBuilder;

  const StatusEvidenceTraceEngine({
    this.probeAdapter = const StatusProbeTraceAdapter(),
    this.scenarioAdapter = const StatusScenarioTraceAdapter(),
    this.chainBuilder = const StatusTraceChainBuilder(),
  });

  StatusEvidenceTraceChain fromProbeBundle(
    StatusProbeEvidenceBundle bundle, {
    StatusProbeScenarioId? scenarioId,
    int? scenarioScore,
  }) {
    final traces = bundle.suites
        .expand((suite) => suite.results)
        .map(probeAdapter.fromProbe)
        .toList(growable: false);
    final chain = chainBuilder.fromTraces(traces);
    if (scenarioId == null) return chain;
    return scenarioAdapter.attachScenario(
      chain: chain,
      scenarioId: scenarioId,
      score: scenarioScore ?? 0,
    );
  }
}
