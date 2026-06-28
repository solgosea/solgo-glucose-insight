import 'package:flutter_test/flutter_test.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/application/hub/scoring/status_hub_path_score_policy.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/hub/path/status_hub_path_metric_score.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/hub/path/status_hub_path_models.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/hub/status_hub_enums.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/hub/status_hub_models.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_component_kind.dart';
import 'package:smart_xdrip/plugins/explore/status_monitor/domain/status_level.dart';

void main() {
  test('path score always emits five quantified star metrics', () {
    const policy = StatusHubPathScorePolicy();
    final connection = _connection(
      state: StatusHubState.fresh,
      confidence: .84,
    );
    final evidence = _evidence(
      targetAge: const Duration(minutes: 3),
      delay: const Duration(minutes: 2),
      refs: 4,
      availableRefs: 4,
      alignment: true,
    );

    final score = policy.score(
      connection: connection,
      evidence: evidence,
      diagnosisPriority: 0,
      diagnosisReason: StatusHubPathDiagnosisReason.upstreamAligned,
    );

    expect(score.metrics, hasLength(5));
    expect(
      score.metrics.map((metric) => metric.id),
      containsAll(StatusHubPathMetricScoreId.values),
    );
    expect(score.overallScore, greaterThan(85));
    expect(score.rawScore, score.overallScore);
    expect(score.cap.maxScore, 100);
    expect(score.stars, 5);
    expect(score.overallLabel, isNot('--'));
  });

  test('stale cloud path receives lower overall score with visible delay', () {
    const policy = StatusHubPathScorePolicy();
    final connection = _connection(
      id: StatusHubConnectionId.xdripToNightscout,
      state: StatusHubState.delayed,
      confidence: .68,
    );
    final evidence = _evidence(
      targetAge: const Duration(minutes: 28),
      delay: const Duration(minutes: 24),
      refs: 4,
      availableRefs: 2,
      alignment: false,
    );

    final score = policy.score(
      connection: connection,
      evidence: evidence,
      diagnosisPriority: 80,
      diagnosisReason: StatusHubPathDiagnosisReason.uploadDelayed,
    );

    final delay = score.metrics.firstWhere(
      (metric) => metric.id == StatusHubPathMetricScoreId.delay,
    );
    final health = score.metrics.firstWhere(
      (metric) => metric.id == StatusHubPathMetricScoreId.pathHealth,
    );

    expect(score.overallScore, lessThan(65));
    expect(score.stars, lessThanOrEqualTo(3));
    expect(delay.rawValueLabel, '+24m');
    expect(health.rawValueLabel, '20');
  });

  test('critical missing handoff caps path score even with fresh evidence', () {
    const policy = StatusHubPathScorePolicy();
    final connection = _connection(
      id: StatusHubConnectionId.jugglucoToXdrip,
      state: StatusHubState.fresh,
      confidence: .95,
    );
    final evidence = _evidence(
      targetAge: const Duration(minutes: 2),
      delay: const Duration(minutes: 1),
      refs: 4,
      availableRefs: 4,
      alignment: false,
    );

    final score = policy.score(
      connection: connection,
      evidence: evidence,
      diagnosisPriority: 95,
      diagnosisReason: StatusHubPathDiagnosisReason.compatiblePathMissing,
    );

    expect(score.cap.maxScore, 64);
    expect(score.overallScore, lessThanOrEqualTo(64));
    expect(score.rawScore, greaterThan(score.overallScore));
    expect(score.stars, lessThanOrEqualTo(3));
  });
}

StatusHubConnection _connection({
  StatusHubConnectionId id = StatusHubConnectionId.cgmToXdrip,
  StatusHubState state = StatusHubState.fresh,
  double confidence = 1,
}) {
  return StatusHubConnection(
    id: id,
    from: StatusHubNodeId.xdrip,
    to: StatusHubNodeId.nightscout,
    kind: StatusHubConnectionKind.xdripToNightscout,
    state: state,
    confidence: confidence,
    isPrimaryPath: true,
    chipLabel: 'test',
    stateSource: const StatusHubSourceRef.derivedPolicy('test'),
    metrics: const [],
    evidence: const [],
    userSummary: 'test',
    nextCheck: 'test',
  );
}

StatusHubPathEvidence _evidence({
  required Duration targetAge,
  required Duration delay,
  required int refs,
  required int availableRefs,
  required bool alignment,
}) {
  return StatusHubPathEvidence(
    pathId: StatusHubConnectionId.xdripToNightscout,
    sourceNode: StatusHubNodeId.xdrip,
    targetNode: StatusHubNodeId.nightscout,
    sourceAge: targetAge - delay,
    targetAge: targetAge,
    delayVsSource: delay,
    sourceAvailable: true,
    targetAvailable: true,
    alignmentObserved: alignment,
    alignmentEvidenceAvailable: true,
    evidenceRefs: [
      for (var i = 0; i < refs; i++)
        StatusHubEvidenceRef(
          id: 'evidence_$i',
          label: 'Evidence $i',
          valueLabel: i < availableRefs ? 'ok' : 'missing',
          level: i < availableRefs ? StatusLevel.healthy : StatusLevel.unknown,
          source: StatusHubSourceRef.componentMetric(
            component: StatusComponentKind.xdrip,
            metricId: 'metric_$i',
            available: i < availableRefs,
          ),
        ),
    ],
  );
}
