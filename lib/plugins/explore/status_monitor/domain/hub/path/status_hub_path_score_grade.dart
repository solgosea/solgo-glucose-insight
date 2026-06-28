import '../status_hub_enums.dart';

enum StatusHubPathScoreGrade {
  good,
  watch,
  degraded,
  issue,
  unknown;

  StatusHubState get state {
    return switch (this) {
      StatusHubPathScoreGrade.good => StatusHubState.fresh,
      StatusHubPathScoreGrade.watch => StatusHubState.delayed,
      StatusHubPathScoreGrade.degraded => StatusHubState.limited,
      StatusHubPathScoreGrade.issue => StatusHubState.stale,
      StatusHubPathScoreGrade.unknown => StatusHubState.unknown,
    };
  }
}
