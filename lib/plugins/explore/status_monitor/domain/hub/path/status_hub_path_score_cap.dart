import 'status_hub_path_score_reason.dart';

class StatusHubPathScoreCap {
  final double maxScore;
  final StatusHubPathScoreReason reason;
  final String label;
  final String explanation;

  const StatusHubPathScoreCap({
    required this.maxScore,
    required this.reason,
    required this.label,
    required this.explanation,
  });
}
