import '../status_hub_enums.dart';
import '../status_hub_models.dart';
import 'status_hub_path_score.dart';

enum StatusHubPathMetricType {
  freshness,
  delay,
  alignment,
  coverage,
  evidence,
  priority,
}

class StatusHubPathEvidence {
  final StatusHubConnectionId pathId;
  final StatusHubNodeId sourceNode;
  final StatusHubNodeId targetNode;
  final Duration? sourceAge;
  final Duration? targetAge;
  final Duration? delayVsSource;
  final bool sourceAvailable;
  final bool targetAvailable;
  final bool alignmentObserved;
  final bool alignmentEvidenceAvailable;
  final List<StatusHubEvidenceRef> evidenceRefs;

  const StatusHubPathEvidence({
    required this.pathId,
    required this.sourceNode,
    required this.targetNode,
    this.sourceAge,
    this.targetAge,
    this.delayVsSource,
    required this.sourceAvailable,
    required this.targetAvailable,
    required this.alignmentObserved,
    this.alignmentEvidenceAvailable = true,
    required this.evidenceRefs,
  });
}

class StatusHubPathMetric {
  final String id;
  final StatusHubPathMetricType type;
  final String label;
  final String valueLabel;
  final double? numericValue;
  final String? unit;
  final StatusHubState state;
  final StatusHubSourceRef source;
  final String meaning;

  const StatusHubPathMetric({
    required this.id,
    required this.type,
    required this.label,
    required this.valueLabel,
    this.numericValue,
    this.unit,
    required this.state,
    required this.source,
    required this.meaning,
  });
}

class StatusHubPathDiagnosis {
  final StatusHubConnectionId pathId;
  final StatusHubState state;
  final StatusHubPathDiagnosisReason reason;
  final int priority;
  final double confidence;
  final String headline;
  final String explanation;
  final String firstCheck;
  final String chipLabel;
  final bool primaryPath;
  final bool showInDetails;
  final StatusHubSourceRef source;
  final StatusHubPathEvidence evidence;
  final List<StatusHubPathMetric> metrics;
  final StatusHubPathScore score;

  const StatusHubPathDiagnosis({
    required this.pathId,
    required this.state,
    required this.reason,
    required this.priority,
    required this.confidence,
    required this.headline,
    required this.explanation,
    required this.firstCheck,
    required this.chipLabel,
    required this.primaryPath,
    this.showInDetails = true,
    required this.source,
    required this.evidence,
    required this.metrics,
    this.score = StatusHubPathScore.unknown,
  });
}
