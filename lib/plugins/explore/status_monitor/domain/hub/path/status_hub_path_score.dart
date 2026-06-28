import 'status_hub_path_metric_score.dart';
import 'status_hub_path_score_cap.dart';
import 'status_hub_path_score_grade.dart';
import 'status_hub_path_score_reason.dart';

class StatusHubPathScore {
  final double overallScore;
  final double rawScore;
  final String overallLabel;
  final int stars;
  final StatusHubPathScoreGrade grade;
  final StatusHubPathScoreCap cap;
  final List<StatusHubPathMetricScore> metrics;

  const StatusHubPathScore({
    required this.overallScore,
    required this.rawScore,
    required this.overallLabel,
    required this.stars,
    required this.grade,
    required this.cap,
    required this.metrics,
  });

  static const unknown = StatusHubPathScore(
    overallScore: 0,
    rawScore: 0,
    overallLabel: '--',
    stars: 0,
    grade: StatusHubPathScoreGrade.unknown,
    cap: StatusHubPathScoreCap(
      maxScore: 0,
      reason: StatusHubPathScoreReason.insufficientEvidence,
      label: 'Unknown',
      explanation: 'No score is available for this path.',
    ),
    metrics: [],
  );
}
