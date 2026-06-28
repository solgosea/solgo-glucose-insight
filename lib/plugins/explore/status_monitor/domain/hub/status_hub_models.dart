import '../status_level.dart';
import '../status_component_kind.dart';
import '../trace/status_evidence_trace.dart';
import '../trace/status_evidence_trace_chain.dart';
import 'path/status_hub_connection_metric_requirement.dart';
import 'path/status_hub_path_score.dart';
import 'status_hub_enums.dart';

enum StatusHubSourceKind {
  componentMetric,
  probeEvidence,
  derivedPolicy,
  staticCopy,
  unavailable,
}

class StatusHubSourceRef {
  final StatusHubSourceKind kind;
  final StatusComponentKind? componentKind;
  final String? metricId;
  final String? detailPath;
  final String? policyId;
  final bool available;

  const StatusHubSourceRef({
    required this.kind,
    this.componentKind,
    this.metricId,
    this.detailPath,
    this.policyId,
    this.available = true,
  });

  const StatusHubSourceRef.unavailable()
      : kind = StatusHubSourceKind.unavailable,
        componentKind = null,
        metricId = null,
        detailPath = null,
        policyId = null,
        available = false;

  const StatusHubSourceRef.staticCopy()
      : kind = StatusHubSourceKind.staticCopy,
        componentKind = null,
        metricId = null,
        detailPath = null,
        policyId = null,
        available = true;

  const StatusHubSourceRef.derivedPolicy(String id)
      : kind = StatusHubSourceKind.derivedPolicy,
        componentKind = null,
        metricId = null,
        detailPath = null,
        policyId = id,
        available = true;

  const StatusHubSourceRef.componentMetric({
    required StatusComponentKind component,
    required this.metricId,
    this.available = true,
  })  : kind = StatusHubSourceKind.componentMetric,
        componentKind = component,
        detailPath = null,
        policyId = null;

  const StatusHubSourceRef.probeEvidence({
    required String probeId,
    String? path,
    this.available = true,
  })  : kind = StatusHubSourceKind.probeEvidence,
        componentKind = null,
        metricId = probeId,
        detailPath = path,
        policyId = null;
}

class StatusHubEvidenceRef {
  final String id;
  final String label;
  final String valueLabel;
  final StatusLevel level;
  final StatusHubSourceRef source;
  final StatusEvidenceTrace trace;

  const StatusHubEvidenceRef({
    required this.id,
    required this.label,
    required this.valueLabel,
    required this.level,
    this.source = const StatusHubSourceRef.unavailable(),
    this.trace = StatusEvidenceTrace.empty,
  });
}

class StatusHubMetricFact {
  final String id;
  final String label;
  final String valueLabel;
  final StatusLevel level;
  final StatusHubSourceRef source;
  final double? numericValue;
  final String? unit;
  final String? targetLabel;
  final double? normalizedScore;
  final int? stars;
  final StatusHubState? metricState;
  final StatusHubConnectionMetricRequirement requirement;
  final String? meaning;
  final StatusEvidenceTrace trace;

  const StatusHubMetricFact({
    this.id = '',
    required this.label,
    required this.valueLabel,
    required this.level,
    required this.source,
    this.numericValue,
    this.unit,
    this.targetLabel,
    this.normalizedScore,
    this.stars,
    this.metricState,
    this.requirement = StatusHubConnectionMetricRequirement.required,
    this.meaning,
    this.trace = StatusEvidenceTrace.empty,
  });
}

class StatusHubEvidenceQuality {
  final int availableEvidenceCount;
  final int expectedEvidenceCount;
  final double confidence;
  final String label;

  const StatusHubEvidenceQuality({
    required this.availableEvidenceCount,
    required this.expectedEvidenceCount,
    required this.confidence,
    required this.label,
  });
}

class StatusHubNode {
  final StatusHubNodeId id;
  final String label;
  final StatusHubNodeRole role;
  final StatusHubState state;
  final DateTime? latestObservedAt;
  final Duration? age;
  final double confidence;
  final List<StatusHubEvidenceRef> evidence;
  final String? detailRoute;
  final StatusHubSourceRef source;
  final StatusEvidenceTraceChain traceChain;

  const StatusHubNode({
    required this.id,
    required this.label,
    required this.role,
    required this.state,
    this.latestObservedAt,
    this.age,
    required this.confidence,
    required this.evidence,
    this.detailRoute,
    this.source = const StatusHubSourceRef.unavailable(),
    this.traceChain = StatusEvidenceTraceChain.empty,
  });
}

class StatusHubConnection {
  final StatusHubConnectionId id;
  final StatusHubNodeId from;
  final StatusHubNodeId to;
  final StatusHubConnectionKind kind;
  final StatusHubState state;
  final Duration? sourceAge;
  final Duration? targetAge;
  final Duration? delayVsSource;
  final double confidence;
  final bool isPrimaryPath;
  final bool isPriorityFocus;
  final int diagnosisPriority;
  final StatusHubPathDiagnosisReason? diagnosisReason;
  final StatusHubPathScore pathScore;
  final String chipLabel;
  final bool showInDetails;
  final StatusHubSourceRef stateSource;
  final List<StatusHubMetricFact> metrics;
  final List<StatusHubEvidenceRef> evidence;
  final String userSummary;
  final String nextCheck;
  final StatusEvidenceTraceChain traceChain;

  const StatusHubConnection({
    required this.id,
    required this.from,
    required this.to,
    required this.kind,
    required this.state,
    this.sourceAge,
    this.targetAge,
    this.delayVsSource,
    required this.confidence,
    required this.isPrimaryPath,
    this.isPriorityFocus = false,
    this.diagnosisPriority = 0,
    this.diagnosisReason,
    this.pathScore = StatusHubPathScore.unknown,
    required this.chipLabel,
    this.showInDetails = true,
    required this.stateSource,
    required this.metrics,
    required this.evidence,
    required this.userSummary,
    required this.nextCheck,
    this.traceChain = StatusEvidenceTraceChain.empty,
  });

  StatusHubConnection copyWith({bool? isPriorityFocus}) {
    return StatusHubConnection(
      id: id,
      from: from,
      to: to,
      kind: kind,
      state: state,
      sourceAge: sourceAge,
      targetAge: targetAge,
      delayVsSource: delayVsSource,
      confidence: confidence,
      isPrimaryPath: isPrimaryPath,
      isPriorityFocus: isPriorityFocus ?? this.isPriorityFocus,
      diagnosisPriority: diagnosisPriority,
      diagnosisReason: diagnosisReason,
      pathScore: pathScore,
      chipLabel: chipLabel,
      showInDetails: showInDetails,
      stateSource: stateSource,
      metrics: metrics,
      evidence: evidence,
      userSummary: userSummary,
      nextCheck: nextCheck,
      traceChain: traceChain,
    );
  }
}

class StatusHubTopology {
  final StatusHubTopologyKind kind;
  final String label;
  final String title;
  final String subtitle;
  final String badgeLabel;
  final List<String> observedPaths;
  final bool autoDetected;
  final StatusHubSourceRef source;

  const StatusHubTopology({
    required this.kind,
    required this.label,
    this.title = 'xDrip-centered connection map',
    this.subtitle =
        'Numbers on each connection show latest observed evidence, not a diagnosis.',
    this.badgeLabel = 'AUTO',
    required this.observedPaths,
    required this.autoDetected,
    this.source = const StatusHubSourceRef.derivedPolicy(
      'status_hub_topology_detector',
    ),
  });
}

class StatusHubFocus {
  final StatusHubConnectionId? connectionId;
  final StatusHubFocusReason reason;
  final StatusLevel severity;
  final String headline;
  final String explanation;
  final String badgeLabel;
  final List<String> suggestedChecks;
  final StatusHubSourceRef source;

  const StatusHubFocus({
    this.connectionId,
    required this.reason,
    required this.severity,
    required this.headline,
    required this.explanation,
    this.badgeLabel = 'Priority focus',
    required this.suggestedChecks,
    this.source = const StatusHubSourceRef.derivedPolicy(
      'status_hub_focus_resolver',
    ),
  });
}

class StatusHubSummary {
  final StatusHubState state;
  final String headline;
  final String body;
  final String meta;
  final StatusHubSourceRef source;

  const StatusHubSummary({
    required this.state,
    required this.headline,
    required this.body,
    required this.meta,
    this.source = const StatusHubSourceRef.derivedPolicy(
      'status_hub_summary_builder',
    ),
  });
}

class StatusHubObserverNote {
  final String title;
  final String body;
  final StatusHubSourceRef source;

  const StatusHubObserverNote({
    required this.title,
    required this.body,
    this.source = const StatusHubSourceRef.staticCopy(),
  });
}

class StatusHubReport {
  final DateTime generatedAt;
  final StatusHubTopology topology;
  final List<StatusHubNode> nodes;
  final List<StatusHubConnection> connections;
  final StatusHubFocus focus;
  final StatusHubSummary summary;
  final StatusHubObserverNote observerNote;
  final String disclaimer;
  final StatusHubEvidenceQuality evidenceQuality;
  final String shareSummary;
  final StatusEvidenceTraceChain traceChain;

  const StatusHubReport({
    required this.generatedAt,
    required this.topology,
    required this.nodes,
    required this.connections,
    required this.focus,
    required this.summary,
    required this.observerNote,
    required this.disclaimer,
    required this.evidenceQuality,
    required this.shareSummary,
    this.traceChain = StatusEvidenceTraceChain.empty,
  });
}
