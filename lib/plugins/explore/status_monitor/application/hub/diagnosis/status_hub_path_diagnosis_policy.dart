import '../../../domain/hub/path/status_hub_path_models.dart';
import '../../../domain/hub/status_hub_enums.dart';
import '../../../domain/hub/status_hub_models.dart';
import '../metrics/status_hub_path_metric_builder.dart';
import '../scoring/status_hub_path_score_policy.dart';

class StatusHubPathDiagnosisPolicy {
  final StatusHubPathMetricBuilder metricBuilder;
  final StatusHubPathScorePolicy scorePolicy;

  const StatusHubPathDiagnosisPolicy({
    this.metricBuilder = const StatusHubPathMetricBuilder(),
    this.scorePolicy = const StatusHubPathScorePolicy(),
  });

  StatusHubPathDiagnosis diagnose({
    required StatusHubConnection baseConnection,
    required StatusHubPathEvidence evidence,
  }) {
    final reason = _reasonFor(baseConnection, evidence);
    final priority = _priorityFor(baseConnection, reason);
    final metrics = metricBuilder.fromFacts(
      baseConnection.id,
      baseConnection.metrics,
    );
    final score = scorePolicy.score(
      connection: baseConnection,
      evidence: evidence,
      diagnosisPriority: priority,
      diagnosisReason: reason,
    );
    return StatusHubPathDiagnosis(
      pathId: baseConnection.id,
      state: baseConnection.state,
      reason: reason,
      priority: priority,
      confidence: _confidence(baseConnection, evidence),
      headline: _headlineFor(baseConnection, reason),
      explanation: baseConnection.userSummary,
      firstCheck: baseConnection.nextCheck,
      chipLabel: baseConnection.chipLabel,
      primaryPath: baseConnection.isPrimaryPath,
      showInDetails: baseConnection.showInDetails,
      source: baseConnection.stateSource,
      evidence: evidence,
      metrics: metrics,
      score: score,
    );
  }

  StatusHubConnection toConnection(
    StatusHubConnection baseConnection,
    StatusHubPathDiagnosis diagnosis,
  ) {
    return StatusHubConnection(
      id: baseConnection.id,
      from: baseConnection.from,
      to: baseConnection.to,
      kind: baseConnection.kind,
      state: diagnosis.state,
      sourceAge: diagnosis.evidence.sourceAge,
      targetAge: diagnosis.evidence.targetAge,
      delayVsSource: diagnosis.evidence.delayVsSource,
      confidence: diagnosis.confidence,
      isPrimaryPath: diagnosis.primaryPath,
      isPriorityFocus: baseConnection.isPriorityFocus,
      diagnosisPriority: diagnosis.priority,
      diagnosisReason: diagnosis.reason,
      pathScore: diagnosis.score,
      chipLabel: diagnosis.chipLabel,
      showInDetails: diagnosis.showInDetails,
      stateSource: diagnosis.source,
      metrics: baseConnection.metrics,
      evidence: baseConnection.evidence,
      userSummary: diagnosis.explanation,
      nextCheck: diagnosis.firstCheck,
      traceChain: baseConnection.traceChain,
    );
  }

  StatusHubPathDiagnosisReason _reasonFor(
    StatusHubConnection connection,
    StatusHubPathEvidence evidence,
  ) {
    if (!evidence.sourceAvailable && !evidence.targetAvailable) {
      return StatusHubPathDiagnosisReason.insufficientEvidence;
    }
    if (connection.id == StatusHubConnectionId.cgmToXdrip) {
      if (connection.state == StatusHubState.fresh) {
        return StatusHubPathDiagnosisReason.upstreamAligned;
      }
      if (!evidence.sourceAvailable) {
        return StatusHubPathDiagnosisReason.sourceStale;
      }
      return StatusHubPathDiagnosisReason.hubDelayed;
    }
    if (connection.id == StatusHubConnectionId.jugglucoToXdrip) {
      if (connection.state == StatusHubState.fresh) {
        return StatusHubPathDiagnosisReason.handoffAligned;
      }
      if (!evidence.alignmentEvidenceAvailable) {
        return StatusHubPathDiagnosisReason.insufficientEvidence;
      }
      if (!evidence.alignmentObserved) {
        return StatusHubPathDiagnosisReason.compatiblePathMissing;
      }
      return StatusHubPathDiagnosisReason.hubDelayed;
    }
    if (connection.id == StatusHubConnectionId.xdripToNightscout) {
      if (!evidence.targetAvailable) {
        return StatusHubPathDiagnosisReason.cloudUnavailable;
      }
      if (evidence.sourceAvailable &&
          evidence.targetAvailable &&
          connection.state == StatusHubState.fresh) {
        return StatusHubPathDiagnosisReason.uploadAligned;
      }
      if (evidence.delayVsSource != null &&
          evidence.delayVsSource!.isNegative) {
        return StatusHubPathDiagnosisReason.localObservationStale;
      }
      return StatusHubPathDiagnosisReason.uploadDelayed;
    }
    if (connection.id == StatusHubConnectionId.xdripToAaps) {
      if (connection.state == StatusHubState.fresh) {
        return StatusHubPathDiagnosisReason.bgSourceObserved;
      }
      if (!evidence.alignmentEvidenceAvailable) {
        return StatusHubPathDiagnosisReason.insufficientEvidence;
      }
      if (!evidence.alignmentObserved) {
        return StatusHubPathDiagnosisReason.bgSourceMissing;
      }
      return StatusHubPathDiagnosisReason.loopContextLimited;
    }
    return StatusHubPathDiagnosisReason.displayOnly;
  }

  int _priorityFor(
    StatusHubConnection connection,
    StatusHubPathDiagnosisReason reason,
  ) {
    if (!connection.showInDetails) return 0;
    if (connection.id == StatusHubConnectionId.jugglucoToXdrip &&
        reason == StatusHubPathDiagnosisReason.compatiblePathMissing) {
      return 95;
    }
    if (connection.id == StatusHubConnectionId.jugglucoToXdrip &&
        reason == StatusHubPathDiagnosisReason.hubDelayed) {
      return 92;
    }
    return switch (reason) {
      StatusHubPathDiagnosisReason.sourceStale ||
      StatusHubPathDiagnosisReason.hubDelayed =>
        90,
      StatusHubPathDiagnosisReason.uploadDelayed ||
      StatusHubPathDiagnosisReason.cloudUnavailable =>
        80,
      StatusHubPathDiagnosisReason.bgSourceMissing => 70,
      StatusHubPathDiagnosisReason.compatiblePathMissing => 65,
      StatusHubPathDiagnosisReason.localObservationStale => 60,
      StatusHubPathDiagnosisReason.loopContextLimited => 50,
      StatusHubPathDiagnosisReason.insufficientEvidence => 40,
      _ => 0,
    };
  }

  double _confidence(
    StatusHubConnection connection,
    StatusHubPathEvidence evidence,
  ) {
    var confidence = connection.confidence;
    if (evidence.delayVsSource == null) confidence *= .82;
    if (!evidence.alignmentObserved &&
        evidence.alignmentEvidenceAvailable &&
        connection.id != StatusHubConnectionId.xdripToWatch) {
      confidence *= .86;
    }
    if (!evidence.sourceAvailable || !evidence.targetAvailable) {
      confidence *= .65;
    }
    return confidence.clamp(0, 1);
  }

  String _headlineFor(
    StatusHubConnection connection,
    StatusHubPathDiagnosisReason reason,
  ) {
    return switch (reason) {
      StatusHubPathDiagnosisReason.upstreamAligned =>
        'Upstream data reaches xDrip+.',
      StatusHubPathDiagnosisReason.sourceStale =>
        'Source data is stale before xDrip+.',
      StatusHubPathDiagnosisReason.hubDelayed =>
        'xDrip+ is behind its upstream source.',
      StatusHubPathDiagnosisReason.handoffAligned =>
        'Juggluco handoff into xDrip+ is visible.',
      StatusHubPathDiagnosisReason.compatiblePathMissing =>
        'xDrip-compatible Juggluco path is not observed.',
      StatusHubPathDiagnosisReason.uploadAligned =>
        'Nightscout confirms the xDrip+ upload path.',
      StatusHubPathDiagnosisReason.uploadDelayed =>
        'Nightscout is behind xDrip+ local data.',
      StatusHubPathDiagnosisReason.cloudUnavailable =>
        'Nightscout cloud evidence is unavailable.',
      StatusHubPathDiagnosisReason.localObservationStale =>
        'Cloud data is newer than local xDrip+ evidence.',
      StatusHubPathDiagnosisReason.bgSourceObserved =>
        'AAPS sees the xDrip+ BG source path.',
      StatusHubPathDiagnosisReason.bgSourceMissing =>
        'AAPS does not show xDrip+ as BG source.',
      StatusHubPathDiagnosisReason.loopContextLimited =>
        'AAPS loop context evidence is limited.',
      StatusHubPathDiagnosisReason.displayOnly =>
        'Display path depends on xDrip+ local availability.',
      StatusHubPathDiagnosisReason.insufficientEvidence =>
        'Not enough evidence to diagnose ${connection.id.value}.',
      _ => connection.userSummary,
    };
  }
}
