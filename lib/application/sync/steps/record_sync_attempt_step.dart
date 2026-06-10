import '../glucose_sync_context.dart';
import '../glucose_sync_step.dart';

class RecordSyncAttemptStep extends GlucoseSyncStep {
  const RecordSyncAttemptStep();

  @override
  Future<void> execute(GlucoseSyncContext context) {
    return context.database.recordSourceAttempt(
      context.sourceKey,
      subjectId: context.subjectId,
    );
  }
}
