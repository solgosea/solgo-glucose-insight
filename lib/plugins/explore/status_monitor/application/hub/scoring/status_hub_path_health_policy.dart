import '../../../domain/hub/path/status_hub_path_score_cap.dart';
import '../../../domain/hub/status_hub_enums.dart';
import '../../../domain/hub/status_hub_models.dart';

class StatusHubPathHealthPolicy {
  const StatusHubPathHealthPolicy();

  double healthScore({
    required StatusHubConnection connection,
    required int diagnosisPriority,
    required StatusHubPathScoreCap cap,
  }) {
    var score = 100 - diagnosisPriority.toDouble();
    score = switch (connection.state) {
      StatusHubState.fresh => score,
      StatusHubState.delayed => score.clamp(0, 78).toDouble(),
      StatusHubState.limited => score.clamp(0, 60).toDouble(),
      StatusHubState.stale ||
      StatusHubState.unavailable =>
        score.clamp(0, 35).toDouble(),
      StatusHubState.notChecked ||
      StatusHubState.unknown =>
        score.clamp(0, 45).toDouble(),
    };
    return score.clamp(0, cap.maxScore).toDouble();
  }
}
