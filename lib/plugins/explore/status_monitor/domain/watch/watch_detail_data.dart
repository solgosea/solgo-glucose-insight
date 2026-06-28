import '../detail/status_component_detail_data.dart';
import '../detail/status_signal_summary.dart';
import '../status_level.dart';
import 'watch_display_evidence_fact.dart';
import 'watch_display_service_fact.dart';
import 'watch_path_check.dart';
import 'watch_setup_step.dart';

class WatchDetailData extends StatusComponentDetailData {
  final StatusLevel state;
  final int score;
  final String scoreLabel;
  final String headline;
  final String summary;
  final String latestXdripEntryLabel;
  final String xdripWebResponseLabel;
  final String latestWatchEvidenceLabel;
  final List<StatusSignalSummary> signals;
  final List<WatchPathCheck> pathChecks;
  final List<WatchDisplayServiceFact> serviceFacts;
  final WatchDisplayEvidenceFact displayEvidence;
  final List<WatchSetupStep> setupSteps;

  const WatchDetailData({
    required this.state,
    required this.score,
    required this.scoreLabel,
    required this.headline,
    required this.summary,
    required this.latestXdripEntryLabel,
    required this.xdripWebResponseLabel,
    required this.latestWatchEvidenceLabel,
    required this.signals,
    required this.pathChecks,
    required this.serviceFacts,
    required this.displayEvidence,
    required this.setupSteps,
  });

  @override
  String get type => 'watchDisplay';

  @override
  Map<String, Object?> toJson() => {
        'type': type,
        'state': state.name,
        'score': score,
        'scoreLabel': scoreLabel,
        'headline': headline,
        'summary': summary,
        'latestXdripEntryLabel': latestXdripEntryLabel,
        'xdripWebResponseLabel': xdripWebResponseLabel,
        'latestWatchEvidenceLabel': latestWatchEvidenceLabel,
        'signals': signals.map((signal) => signal.toJson()).toList(),
        'pathChecks': pathChecks.map((check) => check.toJson()).toList(),
        'serviceFacts': serviceFacts.map((fact) => fact.toJson()).toList(),
        'displayEvidence': displayEvidence.toJson(),
        'setupSteps': setupSteps.map((step) => step.toJson()).toList(),
      };
}
