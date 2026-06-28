import '../../../domain/watch/watch_detail_data.dart';
import '../models/watch_detail_view_model.dart';

class WatchDetailViewModelMapper {
  const WatchDetailViewModelMapper();

  WatchDetailViewModel map(WatchDetailData data) {
    return WatchDetailViewModel(
      state: data.state,
      score: data.score,
      scoreLabel: data.scoreLabel,
      headline: data.headline,
      summary: data.summary,
      latestXdripEntryLabel: data.latestXdripEntryLabel,
      xdripWebResponseLabel: data.xdripWebResponseLabel,
      latestWatchEvidenceLabel: data.latestWatchEvidenceLabel,
      pathChecks: data.pathChecks
          .map(
            (check) => WatchPathCheckViewModel(
              title: check.title,
              body: check.body,
              valueLabel: check.valueLabel,
              level: check.level,
              sourceLabel: check.sourceLabel,
            ),
          )
          .toList(growable: false),
      serviceFacts: data.serviceFacts
          .map(
            (fact) => WatchMetricTileViewModel(
              label: fact.label,
              value: fact.value,
              body: fact.body,
              level: fact.level,
              score: fact.score,
            ),
          )
          .toList(growable: false),
      displayEvidence: WatchDisplayEvidenceViewModel(
        title: data.displayEvidence.title,
        body: data.displayEvidence.body,
        latestLabel: data.displayEvidence.latestLabel,
        sourceLabel: data.displayEvidence.sourceLabel,
        level: data.displayEvidence.level,
      ),
      setupSteps: data.setupSteps
          .map(
            (step) => WatchSetupStepViewModel(
              index: step.index,
              title: step.title,
              body: step.body,
              settingPath: step.settingPath,
            ),
          )
          .toList(growable: false),
    );
  }
}
