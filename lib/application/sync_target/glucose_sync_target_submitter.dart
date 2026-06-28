import '../../domain/entities/app_settings.dart';
import '../../domain/sync_target/glucose_sync_target.dart';
import '../sync_runtime/unified_glucose_sync_runtime.dart';
import '../sync_runtime/unified_sync_run_result.dart';
import '../sync_status/subject_sync_status_store.dart';
import 'glucose_sync_target_registry.dart';

class GlucoseSyncTargetSubmitter {
  final GlucoseSyncTargetRegistry registry;
  final UnifiedGlucoseSyncRuntime runtime;
  final SubjectSyncStatusStore subjectStatusStore;
  final AppSettings Function() settingsProvider;
  final DateTime Function() now;

  GlucoseSyncTargetSubmitter({
    required this.registry,
    required this.runtime,
    required this.subjectStatusStore,
    required this.settingsProvider,
    DateTime Function()? now,
  }) : now = now ?? DateTime.now;

  Future<UnifiedSyncRunResult?> submitTargetId({
    required String targetId,
    required String trigger,
    Map<String, Object?> payload = const {},
  }) async {
    final settings = settingsProvider();
    final targets = await registry.targetsFor(settings);
    return _submitTarget(
      targets: targets,
      settings: settings,
      targetId: targetId,
      trigger: trigger,
      payload: payload,
    );
  }

  Future<UnifiedSyncRunResult?> _submitTarget({
    required List<GlucoseSyncTarget> targets,
    required AppSettings settings,
    required String targetId,
    required String trigger,
    required Map<String, Object?> payload,
  }) async {
    for (final target in targets) {
      if (target.targetId != targetId) continue;
      subjectStatusStore.markStarted(subjectId: target.subjectId, at: now());
      return runtime.runTarget(
        target: target,
        settings: settings,
        trigger: trigger,
        payload: {
          ...payload,
          'targetId': target.targetId,
          'subjectId': target.subjectId,
        },
      );
    }
    return null;
  }

  Future<List<UnifiedSyncRunResult>> submitTargetIds({
    required Iterable<String> targetIds,
    required String trigger,
    Map<String, Object?> payload = const {},
  }) async {
    final settings = settingsProvider();
    final targets = await registry.targetsFor(settings);
    final seen = <String>{};
    final submissions = <Future<UnifiedSyncRunResult?>>[];
    for (final targetId in targetIds) {
      final id = targetId.trim();
      if (id.isEmpty || !seen.add(id)) continue;
      submissions.add(
        _submitTarget(
          targets: targets,
          settings: settings,
          targetId: id,
          trigger: trigger,
          payload: payload,
        ),
      );
    }
    final results = await Future.wait(submissions);
    return results.whereType<UnifiedSyncRunResult>().toList(growable: false);
  }
}
