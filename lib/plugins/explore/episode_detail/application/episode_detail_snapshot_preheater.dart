import '../../../../application/analysis/analysis_facade.dart';
import '../mappers/episode_detail_view_model_mapper.dart';
import '../models/episode_kind.dart';
import '../runtime/episode_detail_runtime_snapshot.dart';

class EpisodeDetailSnapshotPreheater {
  final AnalysisFacade Function() facadeProvider;
  final EpisodeDetailViewModelMapper mapper;
  final DateTime Function() now;

  EpisodeDetailSnapshotPreheater({
    required this.facadeProvider,
    this.mapper = const EpisodeDetailViewModelMapper(),
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;

  EpisodeDetailRuntimeSnapshot preheat({
    required EpisodeKind kind,
    required String reason,
  }) {
    final facade = facadeProvider();
    final viewModel = mapper.map(kind: kind, facade: facade);
    return EpisodeDetailRuntimeSnapshot(
      subjectId: facade.activeSubject.id,
      kind: kind,
      viewModel: viewModel,
      updatedAt: now(),
      reason: reason,
    );
  }
}
