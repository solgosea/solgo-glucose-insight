import '../status_hub_enums.dart';
import '../status_hub_models.dart';

enum StatusHubPathMetricScoreId {
  freshness,
  delay,
  evidence,
  confidence,
  pathHealth,
}

class StatusHubPathMetricScore {
  final StatusHubPathMetricScoreId id;
  final String label;
  final String rawValueLabel;
  final double normalizedScore;
  final int stars;
  final StatusHubState state;
  final StatusHubSourceRef source;

  const StatusHubPathMetricScore({
    required this.id,
    required this.label,
    required this.rawValueLabel,
    required this.normalizedScore,
    required this.stars,
    required this.state,
    required this.source,
  });
}
