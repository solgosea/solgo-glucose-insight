import '../../../domain/hub/status_hub_enums.dart';
import '../../../domain/status_level.dart';

class StatusHubViewModel {
  final String title;
  final String subtitle;
  final StatusHubTopologyViewModel topology;
  final StatusHubSummaryViewModel summary;
  final StatusHubFocusViewModel focus;
  final List<StatusHubNodeViewModel> nodes;
  final List<StatusHubConnectionViewModel> connections;
  final List<StatusHubConnectionViewModel> detailConnections;
  final StatusHubEvidenceViewModel evidence;
  final StatusHubObserverNoteViewModel observerNote;
  final String disclaimer;
  final String generatedLabel;
  final String shareSummary;

  const StatusHubViewModel({
    required this.title,
    required this.subtitle,
    required this.topology,
    required this.summary,
    required this.focus,
    required this.nodes,
    required this.connections,
    required this.detailConnections,
    required this.evidence,
    required this.observerNote,
    required this.disclaimer,
    required this.generatedLabel,
    required this.shareSummary,
  });
}

class StatusHubTopologyViewModel {
  final String title;
  final String subtitle;
  final String badgeLabel;

  const StatusHubTopologyViewModel({
    required this.title,
    required this.subtitle,
    required this.badgeLabel,
  });
}

class StatusHubSummaryViewModel {
  final String headline;
  final String body;
  final String meta;
  final StatusHubState state;

  const StatusHubSummaryViewModel({
    required this.headline,
    required this.body,
    required this.meta,
    required this.state,
  });
}

class StatusHubFocusViewModel {
  final String headline;
  final String body;
  final String badgeLabel;
  final List<String> checks;
  final StatusLevel severity;
  final String sourceLabel;

  const StatusHubFocusViewModel({
    required this.headline,
    required this.body,
    required this.badgeLabel,
    required this.checks,
    required this.severity,
    required this.sourceLabel,
  });
}

class StatusHubNodeViewModel {
  final StatusHubNodeId id;
  final String label;
  final String roleLabel;
  final StatusHubState state;
  final String stateLabel;
  final String ageLabel;
  final double confidence;
  final String? route;
  final String sourceLabel;

  const StatusHubNodeViewModel({
    required this.id,
    required this.label,
    required this.roleLabel,
    required this.state,
    required this.stateLabel,
    required this.ageLabel,
    required this.confidence,
    this.route,
    required this.sourceLabel,
  });
}

class StatusHubConnectionViewModel {
  final StatusHubConnectionId id;
  final String label;
  final String fromLabel;
  final String toLabel;
  final StatusHubState state;
  final String stateLabel;
  final String sourceAgeLabel;
  final String targetAgeLabel;
  final String delayLabel;
  final String chipLabel;
  final String userSummary;
  final String nextCheck;
  final bool primary;
  final bool priority;
  final bool showInDetails;
  final int diagnosisPriority;
  final String diagnosisScoreLabel;
  final StatusHubPathScoreViewModel pathScore;
  final double confidence;
  final String confidenceLabel;
  final String sourceLabel;
  final List<StatusHubMetricFactViewModel> metrics;
  final List<StatusHubEvidenceItemViewModel> evidence;

  const StatusHubConnectionViewModel({
    required this.id,
    required this.label,
    required this.fromLabel,
    required this.toLabel,
    required this.state,
    required this.stateLabel,
    required this.sourceAgeLabel,
    required this.targetAgeLabel,
    required this.delayLabel,
    required this.chipLabel,
    required this.userSummary,
    required this.nextCheck,
    required this.primary,
    required this.priority,
    required this.showInDetails,
    required this.diagnosisPriority,
    required this.diagnosisScoreLabel,
    required this.pathScore,
    required this.confidence,
    required this.confidenceLabel,
    required this.sourceLabel,
    required this.metrics,
    required this.evidence,
  });
}

class StatusHubPathScoreViewModel {
  final String overallLabel;
  final double overallScore;
  final double rawScore;
  final int stars;
  final StatusHubState state;
  final bool isCapped;
  final String capLabel;
  final String capExplanation;
  final List<StatusHubPathMetricScoreViewModel> metrics;

  const StatusHubPathScoreViewModel({
    required this.overallLabel,
    required this.overallScore,
    required this.rawScore,
    required this.stars,
    required this.state,
    required this.isCapped,
    required this.capLabel,
    required this.capExplanation,
    required this.metrics,
  });
}

class StatusHubPathMetricScoreViewModel {
  final String label;
  final String rawValue;
  final double normalizedScore;
  final int stars;
  final StatusHubState state;
  final String sourceLabel;

  const StatusHubPathMetricScoreViewModel({
    required this.label,
    required this.rawValue,
    required this.normalizedScore,
    required this.stars,
    required this.state,
    required this.sourceLabel,
  });
}

class StatusHubMetricFactViewModel {
  final String label;
  final String value;
  final StatusLevel level;
  final String sourceLabel;
  final String targetLabel;
  final double? normalizedScore;
  final int? stars;
  final StatusHubState? state;
  final String requirementLabel;
  final String meaning;

  const StatusHubMetricFactViewModel({
    required this.label,
    required this.value,
    required this.level,
    required this.sourceLabel,
    required this.targetLabel,
    this.normalizedScore,
    this.stars,
    this.state,
    required this.requirementLabel,
    required this.meaning,
  });
}

class StatusHubEvidenceItemViewModel {
  final String label;
  final String value;
  final StatusLevel level;
  final String sourceLabel;

  const StatusHubEvidenceItemViewModel({
    required this.label,
    required this.value,
    required this.level,
    required this.sourceLabel,
  });
}

class StatusHubEvidenceViewModel {
  final String label;
  final String ratioLabel;
  final double confidence;
  final String confidenceLabel;

  const StatusHubEvidenceViewModel({
    required this.label,
    required this.ratioLabel,
    required this.confidence,
    required this.confidenceLabel,
  });
}

class StatusHubObserverNoteViewModel {
  final String title;
  final String body;

  const StatusHubObserverNoteViewModel({
    required this.title,
    required this.body,
  });
}
