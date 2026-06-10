import '../models/episode_detail_view_model.dart';
import '../models/episode_kind.dart';

class EpisodeDetailRuntimeSnapshot {
  final String subjectId;
  final EpisodeKind kind;
  final EpisodeDetailViewModel viewModel;
  final DateTime updatedAt;
  final String reason;

  const EpisodeDetailRuntimeSnapshot({
    required this.subjectId,
    required this.kind,
    required this.viewModel,
    required this.updatedAt,
    required this.reason,
  });
}
