import 'package:intl/intl.dart';

import '../../../domain/hub/path/status_hub_connection_metric_requirement.dart';
import '../../../domain/hub/status_hub_enums.dart';
import '../../../domain/hub/status_hub_models.dart';
import '../models/status_hub_view_model.dart';

class StatusHubViewModelMapper {
  const StatusHubViewModelMapper();

  StatusHubViewModel map(StatusHubReport report) {
    final nodes = report.nodes.map(_node).toList(growable: false);
    final connections = report.connections.map((connection) {
      return _connection(connection, report.nodes);
    }).toList(growable: false);
    return StatusHubViewModel(
      title: 'xDrip+ Hub',
      subtitle: 'A topology view for the ecosystem around xDrip+.',
      topology: StatusHubTopologyViewModel(
        title: report.topology.title,
        subtitle: report.topology.subtitle,
        badgeLabel: report.topology.badgeLabel,
      ),
      summary: StatusHubSummaryViewModel(
        headline: report.summary.headline,
        body: report.summary.body,
        meta: report.summary.meta,
        state: report.summary.state,
      ),
      focus: StatusHubFocusViewModel(
        headline: report.focus.headline,
        body: report.focus.explanation,
        badgeLabel: report.focus.badgeLabel,
        checks: report.focus.suggestedChecks,
        severity: report.focus.severity,
        sourceLabel: _sourceLabel(report.focus.source),
      ),
      nodes: nodes,
      connections: connections,
      detailConnections: connections
          .where((connection) => connection.showInDetails)
          .toList(growable: false),
      evidence: StatusHubEvidenceViewModel(
        label: report.evidenceQuality.label,
        ratioLabel:
            '${report.evidenceQuality.availableEvidenceCount}/${report.evidenceQuality.expectedEvidenceCount} checks',
        confidence: report.evidenceQuality.confidence,
        confidenceLabel: _percentLabel(report.evidenceQuality.confidence),
      ),
      observerNote: StatusHubObserverNoteViewModel(
        title: report.observerNote.title,
        body: report.observerNote.body,
      ),
      disclaimer: report.disclaimer,
      generatedLabel: DateFormat('MMM d, HH:mm').format(report.generatedAt),
      shareSummary: report.shareSummary,
    );
  }

  StatusHubNodeViewModel _node(StatusHubNode node) {
    return StatusHubNodeViewModel(
      id: node.id,
      label: node.label,
      roleLabel: _roleLabel(node.role),
      state: node.state,
      stateLabel: _stateLabel(node.state),
      ageLabel: _ageLabel(node.age),
      confidence: node.confidence,
      route: node.detailRoute,
      sourceLabel: _sourceLabel(node.source),
    );
  }

  StatusHubConnectionViewModel _connection(
    StatusHubConnection connection,
    List<StatusHubNode> nodes,
  ) {
    final from = _nodeById(nodes, connection.from);
    final to = _nodeById(nodes, connection.to);
    final displayState = _displayState(
      connection.state,
      connection.pathScore.grade.state,
    );
    return StatusHubConnectionViewModel(
      id: connection.id,
      label: _connectionLabel(connection.id),
      fromLabel: from.label,
      toLabel: to.label,
      state: displayState,
      stateLabel: _stateLabel(displayState),
      sourceAgeLabel: _ageLabel(connection.sourceAge),
      targetAgeLabel: _ageLabel(connection.targetAge),
      delayLabel: _delayLabel(connection.delayVsSource),
      chipLabel: connection.chipLabel,
      userSummary: connection.userSummary,
      nextCheck: connection.nextCheck,
      primary: connection.isPrimaryPath,
      priority: connection.isPriorityFocus,
      showInDetails: connection.showInDetails,
      diagnosisPriority: connection.diagnosisPriority,
      diagnosisScoreLabel: connection.diagnosisPriority > 0
          ? '${connection.diagnosisPriority}'
          : '--',
      pathScore: StatusHubPathScoreViewModel(
        overallLabel: connection.pathScore.overallLabel,
        overallScore: connection.pathScore.overallScore,
        rawScore: connection.pathScore.rawScore,
        stars: connection.pathScore.stars,
        state: connection.pathScore.grade.state,
        isCapped: connection.pathScore.rawScore >
                connection.pathScore.overallScore + .1 ||
            connection.pathScore.cap.maxScore < 100,
        capLabel: connection.pathScore.cap.label,
        capExplanation: connection.pathScore.cap.explanation,
        metrics: connection.pathScore.metrics.map((metric) {
          return StatusHubPathMetricScoreViewModel(
            label: metric.label,
            rawValue: metric.rawValueLabel,
            normalizedScore: metric.normalizedScore,
            stars: metric.stars,
            state: metric.state,
            sourceLabel: _sourceLabel(metric.source),
          );
        }).toList(growable: false),
      ),
      confidence: connection.confidence,
      confidenceLabel: _percentLabel(connection.confidence),
      sourceLabel: _sourceLabel(connection.stateSource),
      metrics: connection.metrics.map((metric) {
        return StatusHubMetricFactViewModel(
          label: metric.label,
          value: metric.valueLabel,
          level: metric.level,
          sourceLabel: _sourceLabel(metric.source),
          targetLabel: metric.targetLabel ?? '',
          normalizedScore: metric.normalizedScore,
          stars: metric.stars,
          state: metric.metricState,
          requirementLabel: _requirementLabel(metric.requirement),
          meaning: metric.meaning ?? '',
        );
      }).toList(growable: false),
      evidence: connection.evidence.map((evidence) {
        return StatusHubEvidenceItemViewModel(
          label: evidence.label,
          value: evidence.valueLabel,
          level: evidence.level,
          sourceLabel: _sourceLabel(evidence.source),
        );
      }).toList(growable: false),
    );
  }

  StatusHubNode _nodeById(List<StatusHubNode> nodes, StatusHubNodeId id) {
    return nodes.firstWhere((node) => node.id == id);
  }

  String _roleLabel(StatusHubNodeRole role) {
    return switch (role) {
      StatusHubNodeRole.source => 'Source',
      StatusHubNodeRole.collector => 'Collector',
      StatusHubNodeRole.hub => 'Hub',
      StatusHubNodeRole.cloud => 'Cloud',
      StatusHubNodeRole.loop => 'Loop',
      StatusHubNodeRole.display => 'Display',
      StatusHubNodeRole.observer => 'Observer',
    };
  }

  String _stateLabel(StatusHubState state) {
    return switch (state) {
      StatusHubState.fresh => 'Fresh',
      StatusHubState.delayed => 'Delayed',
      StatusHubState.stale => 'Stale',
      StatusHubState.unavailable => 'Unavailable',
      StatusHubState.limited => 'Limited',
      StatusHubState.notChecked => 'Not checked',
      StatusHubState.unknown => 'Unknown',
    };
  }

  StatusHubState _displayState(
      StatusHubState state, StatusHubState scoreState) {
    return _severityRank(scoreState) > _severityRank(state)
        ? scoreState
        : state;
  }

  int _severityRank(StatusHubState state) {
    return switch (state) {
      StatusHubState.fresh => 0,
      StatusHubState.delayed => 1,
      StatusHubState.limited => 2,
      StatusHubState.stale => 3,
      StatusHubState.unavailable => 4,
      StatusHubState.notChecked => 2,
      StatusHubState.unknown => 2,
    };
  }

  String _connectionLabel(StatusHubConnectionId id) {
    return switch (id) {
      StatusHubConnectionId.cgmToXdrip => 'CGM -> xDrip+',
      StatusHubConnectionId.jugglucoToXdrip => 'Juggluco -> xDrip+',
      StatusHubConnectionId.xdripToNightscout => 'xDrip+ -> Nightscout',
      StatusHubConnectionId.xdripToAaps => 'xDrip+ -> AAPS',
      StatusHubConnectionId.xdripToWatch => 'xDrip+ -> Watch',
    };
  }

  String _ageLabel(Duration? age) {
    if (age == null) return 'Unknown';
    if (age.inMinutes < 1) return 'just now';
    if (age.inHours < 1) return '${age.inMinutes}m';
    if (age.inDays < 1) return '${age.inHours}h';
    return '${age.inDays}d';
  }

  String _delayLabel(Duration? delay) {
    if (delay == null) return 'Unknown';
    if (delay.isNegative) return 'Target newer';
    if (delay.inMinutes < 1) return 'Aligned';
    if (delay.inHours < 1) return '+${delay.inMinutes}m';
    return '+${delay.inHours}h';
  }

  String _percentLabel(double value) {
    return '${(value.clamp(0, 1) * 100).round()}%';
  }

  String _sourceLabel(StatusHubSourceRef source) {
    return switch (source.kind) {
      StatusHubSourceKind.componentMetric =>
        '${source.componentKind?.name ?? 'component'}.${source.metricId ?? 'metric'}',
      StatusHubSourceKind.probeEvidence =>
        'probe.${source.metricId ?? source.detailPath ?? 'evidence'}',
      StatusHubSourceKind.derivedPolicy => source.policyId ?? 'policy',
      StatusHubSourceKind.staticCopy => 'static copy',
      StatusHubSourceKind.unavailable => 'unavailable',
    };
  }

  String _requirementLabel(StatusHubConnectionMetricRequirement requirement) {
    return switch (requirement) {
      StatusHubConnectionMetricRequirement.required => 'Required',
      StatusHubConnectionMetricRequirement.optional => 'Optional',
      StatusHubConnectionMetricRequirement.unavailable => 'Unavailable',
    };
  }
}
