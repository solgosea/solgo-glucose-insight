import '../../domain/hub/status_hub_models.dart';
import '../../domain/hub/facts/status_hub_fact_bundle.dart';
import 'policies/status_hub_confidence_policy.dart';
import 'status_hub_connection_evaluator.dart';
import 'status_hub_engine_input.dart';
import 'status_hub_engine_output.dart';
import 'status_hub_focus_resolver.dart';
import 'status_hub_node_evaluator.dart';
import 'status_hub_share_summary_builder.dart';
import 'status_hub_summary_builder.dart';
import 'status_hub_topology_detector.dart';

class StatusHubEngine {
  final StatusHubNodeEvaluator nodeEvaluator;
  final StatusHubConnectionEvaluator connectionEvaluator;
  final StatusHubTopologyDetector topologyDetector;
  final StatusHubFocusResolver focusResolver;
  final StatusHubSummaryBuilder summaryBuilder;
  final StatusHubShareSummaryBuilder shareSummaryBuilder;
  final StatusHubConfidencePolicy confidencePolicy;

  const StatusHubEngine({
    this.nodeEvaluator = const StatusHubNodeEvaluator(),
    this.connectionEvaluator = const StatusHubConnectionEvaluator(),
    this.topologyDetector = const StatusHubTopologyDetector(),
    this.focusResolver = const StatusHubFocusResolver(),
    this.summaryBuilder = const StatusHubSummaryBuilder(),
    this.shareSummaryBuilder = const StatusHubShareSummaryBuilder(),
    this.confidencePolicy = const StatusHubConfidencePolicy(),
  });

  StatusHubEngineOutput run(StatusHubEngineInput input) {
    final facts = input.facts;
    final nodes = nodeEvaluator.evaluate(facts);
    final rawConnections = connectionEvaluator.evaluate(facts);
    final focus = focusResolver.resolve(
      facts: facts,
      nodes: nodes,
      connections: rawConnections,
    );
    final connections = rawConnections.map((connection) {
      return connection.copyWith(
        isPriorityFocus: connection.id == focus.connectionId,
      );
    }).toList();
    final topology = topologyDetector.detect(facts, nodes, connections);
    final evidenceQuality = _quality(facts);
    final summary = summaryBuilder.build(
      topology: topology,
      focus: focus,
      connections: connections,
    );
    final draft = StatusHubReportDraft(
      topology: topology,
      connections: connections,
      focus: focus,
      evidenceQuality: evidenceQuality,
    );
    final report = StatusHubReport(
      generatedAt: facts.generatedAt,
      topology: topology,
      nodes: nodes,
      connections: connections,
      focus: focus,
      summary: summary,
      observerNote: const StatusHubObserverNote(
        title: 'Observer note',
        body:
            'Solgo Insight observes available evidence around xDrip+. It does not replace xDrip+, AAPS, Nightscout, CGM apps, or medical guidance.',
      ),
      disclaimer:
          'This view treats xDrip+ as the local ecosystem hub. It suggests the first place to check from observable evidence only.',
      evidenceQuality: evidenceQuality,
      shareSummary: shareSummaryBuilder.build(draft),
      traceChain: facts.traceChain,
    );
    return StatusHubEngineOutput(report: report);
  }

  StatusHubEvidenceQuality _quality(StatusHubFactBundle facts) {
    final available = facts.components.fold<int>(
      0,
      (sum, component) => sum + component.availableEvidence,
    );
    final expected = facts.components.fold<int>(
      0,
      (sum, component) => sum + component.expectedEvidence,
    );
    return confidencePolicy.quality(
      availableEvidence: available,
      expectedEvidence: expected == 0 ? 1 : expected,
    );
  }
}
