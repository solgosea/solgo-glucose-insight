import '../../../domain/hub/path/status_hub_path_metric_score.dart';
import '../../../domain/hub/path/status_hub_connection_metric_requirement.dart';
import '../../../domain/hub/path/status_hub_path_score.dart';
import '../../../domain/hub/path/status_hub_path_score_cap.dart';
import '../../../domain/hub/path/status_hub_path_models.dart';
import '../../../domain/hub/status_hub_enums.dart';
import '../../../domain/hub/status_hub_models.dart';
import '../../../domain/status_level.dart';
import 'status_hub_metric_star_policy.dart';
import 'status_hub_path_health_policy.dart';
import 'status_hub_path_score_cap_policy.dart';
import 'status_hub_path_score_weights.dart';
import 'status_hub_score_label_policy.dart';

class StatusHubPathScorePolicy {
  final StatusHubMetricStarPolicy starPolicy;
  final StatusHubScoreLabelPolicy labelPolicy;
  final StatusHubPathScoreWeights weights;
  final StatusHubPathScoreCapPolicy capPolicy;
  final StatusHubPathHealthPolicy healthPolicy;

  const StatusHubPathScorePolicy({
    this.starPolicy = const StatusHubMetricStarPolicy(),
    this.labelPolicy = const StatusHubScoreLabelPolicy(),
    this.weights = const StatusHubPathScoreWeights(),
    this.capPolicy = const StatusHubPathScoreCapPolicy(),
    this.healthPolicy = const StatusHubPathHealthPolicy(),
  });

  StatusHubPathScore score({
    required StatusHubConnection connection,
    required StatusHubPathEvidence evidence,
    required int diagnosisPriority,
    required StatusHubPathDiagnosisReason diagnosisReason,
  }) {
    final cap = capPolicy.capFor(
      connection: connection,
      diagnosis: diagnosisReason,
    );
    final metrics = [
      _freshness(connection, evidence),
      _delay(connection, evidence),
      _evidence(connection, evidence),
      _confidence(connection),
      _pathHealth(connection, diagnosisPriority, cap),
    ];
    final byId = {for (final item in metrics) item.id: item.normalizedScore};
    final rawScore = (byId[StatusHubPathMetricScoreId.freshness] ?? 0) *
            weights.freshness +
        (byId[StatusHubPathMetricScoreId.delay] ?? 0) * weights.delay +
        (byId[StatusHubPathMetricScoreId.evidence] ?? 0) * weights.evidence +
        (byId[StatusHubPathMetricScoreId.confidence] ?? 0) *
            weights.confidence +
        (byId[StatusHubPathMetricScoreId.pathHealth] ?? 0) * weights.pathHealth;
    final overall = rawScore.clamp(0, cap.maxScore).toDouble();
    return StatusHubPathScore(
      overallScore: overall,
      rawScore: rawScore,
      overallLabel: labelPolicy.labelFor(overall),
      stars: starPolicy.starsFor(overall),
      grade: labelPolicy.gradeFor(overall),
      cap: cap,
      metrics: metrics,
    );
  }

  StatusHubPathMetricScore _freshness(
    StatusHubConnection connection,
    StatusHubPathEvidence evidence,
  ) {
    final signal = _pathFreshnessSignal(connection);
    if (signal != null && _isUnavailableFreshnessSignal(signal)) {
      return _metric(
        id: StatusHubPathMetricScoreId.freshness,
        label: 'Freshness',
        raw: signal,
        score: 0,
        source: connection.stateSource,
      );
    }
    final age = connection.id == StatusHubConnectionId.jugglucoToXdrip
        ? evidence.sourceAge
        : evidence.targetAge;
    final score = _scoreAge(age);
    return _metric(
      id: StatusHubPathMetricScoreId.freshness,
      label: 'Freshness',
      raw: signal ?? _ageLabel(age),
      score: score,
      source: connection.stateSource,
    );
  }

  StatusHubPathMetricScore _delay(
    StatusHubConnection connection,
    StatusHubPathEvidence evidence,
  ) {
    final delay = evidence.delayVsSource;
    final minutes = delay?.inMinutes.abs();
    final score = minutes == null
        ? 0.0
        : minutes <= 3
            ? 100.0
            : minutes <= 8
                ? 82.0
                : minutes <= 15
                    ? 62.0
                    : minutes <= 30
                        ? 42.0
                        : 18.0;
    return _metric(
      id: StatusHubPathMetricScoreId.delay,
      label: 'Delay',
      raw: _delayLabel(delay),
      score: score,
      source: connection.stateSource,
    );
  }

  StatusHubPathMetricScore _evidence(
    StatusHubConnection connection,
    StatusHubPathEvidence evidence,
  ) {
    final quantifiedRequired = connection.metrics.where((metric) {
      return metric.requirement ==
              StatusHubConnectionMetricRequirement.required &&
          metric.normalizedScore != null;
    }).toList(growable: false);
    if (quantifiedRequired.isNotEmpty) {
      final available = quantifiedRequired
          .where((metric) => metric.normalizedScore! >= 62)
          .length;
      final score = quantifiedRequired
              .map((metric) => metric.normalizedScore!)
              .reduce((a, b) => a + b) /
          quantifiedRequired.length;
      return _metric(
        id: StatusHubPathMetricScoreId.evidence,
        label: 'Evidence',
        raw: '$available/${quantifiedRequired.length}',
        score: score,
        source: connection.stateSource,
      );
    }
    final expected = evidence.evidenceRefs.length +
        (evidence.alignmentEvidenceAvailable ? 1 : 1);
    final availableRefs = evidence.evidenceRefs.where((item) {
      return item.source.available && item.level != StatusLevel.unknown;
    }).length;
    final alignment = evidence.alignmentObserved ? 1 : 0;
    final available = availableRefs + alignment;
    final score = expected == 0 ? 0.0 : available / expected * 100;
    return _metric(
      id: StatusHubPathMetricScoreId.evidence,
      label: 'Evidence',
      raw: '$available/$expected',
      score: score,
      source: connection.stateSource,
    );
  }

  StatusHubPathMetricScore _confidence(StatusHubConnection connection) {
    final score = connection.confidence.clamp(0, 1).toDouble() * 100;
    return _metric(
      id: StatusHubPathMetricScoreId.confidence,
      label: 'Confidence',
      raw: '${score.round()}%',
      score: score,
      source: connection.stateSource,
    );
  }

  StatusHubPathMetricScore _pathHealth(
    StatusHubConnection connection,
    int diagnosisPriority,
    StatusHubPathScoreCap cap,
  ) {
    final score = healthPolicy.healthScore(
      connection: connection,
      diagnosisPriority: diagnosisPriority,
      cap: cap,
    );
    return _metric(
      id: StatusHubPathMetricScoreId.pathHealth,
      label: 'Path health',
      raw: score.round().toString(),
      score: score,
      source: connection.stateSource,
    );
  }

  StatusHubPathMetricScore _metric({
    required StatusHubPathMetricScoreId id,
    required String label,
    required String raw,
    required double score,
    required StatusHubSourceRef source,
  }) {
    return StatusHubPathMetricScore(
      id: id,
      label: label,
      rawValueLabel: raw,
      normalizedScore: score,
      stars: starPolicy.starsFor(score),
      state: starPolicy.stateFor(score),
      source: source,
    );
  }

  double _scoreAge(Duration? age) {
    if (age == null) return 0;
    final minutes = age.inMinutes;
    if (minutes <= 6) return 100;
    if (minutes <= 10) return 82;
    if (minutes <= 15) return 62;
    if (minutes <= 30) return 42;
    return 18;
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
    if (delay.inMinutes.abs() < 1) return 'Aligned';
    if (delay.inHours.abs() < 1) return '+${delay.inMinutes.abs()}m';
    return '+${delay.inHours.abs()}h';
  }

  String? _pathFreshnessSignal(StatusHubConnection connection) {
    for (final metric in connection.metrics) {
      final label = metric.label.toLowerCase();
      if (label.contains('reading') ||
          label.contains('age') ||
          label.contains('broadcast')) {
        return metric.valueLabel;
      }
    }
    return null;
  }

  bool _isUnavailableFreshnessSignal(String value) {
    final normalized = value.trim().toLowerCase();
    return normalized.isEmpty ||
        normalized.contains('waiting') ||
        normalized.contains('not seen') ||
        normalized.contains('no broadcast') ||
        normalized.contains('unknown') ||
        normalized == '--';
  }
}
