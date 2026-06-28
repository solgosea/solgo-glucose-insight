import '../sync/glucose_sync_coordinator.dart';
import '../sync/glucose_sync_plan.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/sync_target/glucose_sync_target.dart';
import '../sync/glucose_sync_result.dart';
import '../sync_scheduler/limiters/glucose_sync_persistence_limiter.dart';

class GlucoseSyncTargetRunner {
  final GlucoseSyncCoordinator syncCoordinator;
  final GlucoseSyncPersistenceLimiter? persistenceLimiter;

  const GlucoseSyncTargetRunner({
    required this.syncCoordinator,
    this.persistenceLimiter,
  });

  Future<GlucoseSyncResult> run({
    required GlucoseSyncTarget target,
    required AppSettings settings,
    GlucoseSyncPersistenceLimiter? persistenceLimiter,
    GlucoseSyncPlan? explicitPlan,
  }) {
    return syncCoordinator.syncOnce(
      source: target.source,
      settings: settings,
      subjectId: target.subjectId,
      persistenceLimiter: persistenceLimiter ?? this.persistenceLimiter,
      explicitPlan: explicitPlan,
    );
  }
}
