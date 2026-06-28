import '../../domain/entities/app_settings.dart';
import '../../domain/sync_target/glucose_sync_target.dart';
import '../../domain/sync_target/glucose_sync_target_owner.dart';
import '../subject/active_subject_service.dart';
import '../sync_target/glucose_sync_target_registry.dart';

class ActiveSubjectSyncTargetResolver {
  final ActiveSubjectService activeSubjectService;
  final GlucoseSyncTargetRegistry targetRegistry;

  const ActiveSubjectSyncTargetResolver({
    required this.activeSubjectService,
    required this.targetRegistry,
  });

  Future<GlucoseSyncTarget?> resolve(AppSettings settings) async {
    final subjectId = activeSubjectService.current.id;
    final candidates = (await targetRegistry.targetsFor(settings))
        .where((target) => target.subjectId == subjectId)
        .toList();
    if (candidates.isEmpty) return null;
    candidates.sort(_compare);
    return candidates.first;
  }

  int _compare(GlucoseSyncTarget a, GlucoseSyncTarget b) {
    final primary = _boolScore(b.primaryHistory) - _boolScore(a.primaryHistory);
    if (primary != 0) return primary;
    final owner = _ownerScore(a.owner).compareTo(_ownerScore(b.owner));
    if (owner != 0) return owner;
    return a.targetId.compareTo(b.targetId);
  }

  int _boolScore(bool value) => value ? 1 : 0;

  int _ownerScore(GlucoseSyncTargetOwner owner) {
    return switch (owner) {
      GlucoseSyncTargetOwner.self => 0,
      GlucoseSyncTargetOwner.remote => 1,
      GlucoseSyncTargetOwner.plugin => 2,
    };
  }
}
