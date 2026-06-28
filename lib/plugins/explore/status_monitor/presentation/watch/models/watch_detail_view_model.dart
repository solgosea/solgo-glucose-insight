import '../../../domain/status_level.dart';

class WatchDetailViewModel {
  final StatusLevel state;
  final int score;
  final String scoreLabel;
  final String headline;
  final String summary;
  final String latestXdripEntryLabel;
  final String xdripWebResponseLabel;
  final String latestWatchEvidenceLabel;
  final List<WatchPathCheckViewModel> pathChecks;
  final List<WatchMetricTileViewModel> serviceFacts;
  final WatchDisplayEvidenceViewModel displayEvidence;
  final List<WatchSetupStepViewModel> setupSteps;

  const WatchDetailViewModel({
    required this.state,
    required this.score,
    required this.scoreLabel,
    required this.headline,
    required this.summary,
    required this.latestXdripEntryLabel,
    required this.xdripWebResponseLabel,
    required this.latestWatchEvidenceLabel,
    required this.pathChecks,
    required this.serviceFacts,
    required this.displayEvidence,
    required this.setupSteps,
  });
}

class WatchPathCheckViewModel {
  final String title;
  final String body;
  final String valueLabel;
  final StatusLevel level;
  final String sourceLabel;

  const WatchPathCheckViewModel({
    required this.title,
    required this.body,
    required this.valueLabel,
    required this.level,
    required this.sourceLabel,
  });
}

class WatchMetricTileViewModel {
  final String label;
  final String value;
  final String body;
  final StatusLevel level;
  final double score;

  const WatchMetricTileViewModel({
    required this.label,
    required this.value,
    required this.body,
    required this.level,
    required this.score,
  });
}

class WatchDisplayEvidenceViewModel {
  final String title;
  final String body;
  final String latestLabel;
  final String sourceLabel;
  final StatusLevel level;

  const WatchDisplayEvidenceViewModel({
    required this.title,
    required this.body,
    required this.latestLabel,
    required this.sourceLabel,
    required this.level,
  });
}

class WatchSetupStepViewModel {
  final String index;
  final String title;
  final String body;
  final String? settingPath;

  const WatchSetupStepViewModel({
    required this.index,
    required this.title,
    required this.body,
    this.settingPath,
  });
}
