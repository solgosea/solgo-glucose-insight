import '../engine/episode_detail_engine_output.dart';
import '../models/episode_kind.dart';
import '../domain/episode_detail_focus.dart';

class EpisodeDetailRuntimeSnapshot {
  final String subjectId;
  final EpisodeKind kind;
  final EpisodeDetailFocus? focus;
  final EpisodeDetailEngineOutput output;
  final DateTime updatedAt;
  final String reason;

  const EpisodeDetailRuntimeSnapshot({
    required this.subjectId,
    required this.kind,
    this.focus,
    required this.output,
    required this.updatedAt,
    required this.reason,
  });
}
