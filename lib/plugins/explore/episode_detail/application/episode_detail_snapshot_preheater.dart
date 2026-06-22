import '../../../../application/analysis/analysis_facade.dart';
import '../domain/episode_detail_entry_intent.dart';
import 'episode_detail_service.dart';
import '../models/episode_kind.dart';
import '../runtime/episode_detail_runtime_snapshot.dart';

class EpisodeDetailSnapshotPreheater {
  final AnalysisFacade Function() facadeProvider;
  final EpisodeDetailService? service;
  final DateTime Function() now;

  EpisodeDetailSnapshotPreheater({
    required this.facadeProvider,
    this.service,
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;

  EpisodeDetailRuntimeSnapshot preheat({
    required EpisodeKind kind,
    required String reason,
  }) {
    final facade = facadeProvider();
    final intent = EpisodeDetailEntryIntent.latest(kind: kind);
    final output = (service ??
            EpisodeDetailService(
              facadeProvider: facadeProvider,
              now: now,
            ))
        .load(intent: intent);
    return EpisodeDetailRuntimeSnapshot(
      subjectId: facade.activeSubject.id,
      kind: kind,
      focus: intent.focus,
      output: output,
      updatedAt: now(),
      reason: reason,
    );
  }
}
