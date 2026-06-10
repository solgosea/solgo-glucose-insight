import '../sync/glucose_sync_coordinator.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/sync_target/glucose_sync_target.dart';
import '../sync/glucose_sync_result.dart';

class GlucoseSyncTargetRunner {
  final GlucoseSyncCoordinator syncCoordinator;

  const GlucoseSyncTargetRunner({required this.syncCoordinator});

  Future<GlucoseSyncResult> run({
    required GlucoseSyncTarget target,
    required AppSettings settings,
  }) {
    return syncCoordinator.syncOnce(
      source: target.source,
      settings: settings,
      subjectId: target.subjectId,
    );
  }
}
