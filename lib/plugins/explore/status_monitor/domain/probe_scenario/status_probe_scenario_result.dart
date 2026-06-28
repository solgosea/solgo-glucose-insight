import '../probe/status_probe_evidence_bundle.dart';
import '../trace/status_evidence_trace_chain.dart';
import 'status_probe_scenario_definition.dart';
import 'status_probe_scenario_score_breakdown.dart';

class StatusProbeScenarioResult {
  final StatusProbeScenarioDefinition definition;
  final StatusProbeEvidenceBundle bundle;
  final int score;
  final StatusProbeScenarioScoreBreakdown breakdown;
  final StatusEvidenceTraceChain traceChain;

  const StatusProbeScenarioResult({
    required this.definition,
    required this.bundle,
    required this.score,
    required this.breakdown,
    this.traceChain = StatusEvidenceTraceChain.empty,
  });
}
