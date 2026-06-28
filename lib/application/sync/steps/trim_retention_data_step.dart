import '../glucose_sync_context.dart';
import '../glucose_sync_step.dart';

class TrimRetentionDataStep extends GlucoseSyncStep {
  const TrimRetentionDataStep();

  @override
  Future<void> execute(GlucoseSyncContext context) async {
    await context.runPersistence(
      () async {
        await context.database.trimOlderThan(
          context.settings.retentionDays,
          subjectId: context.subjectId,
        );
        await context.database.trimRawOlderThan(
          context.settings.retentionDays,
          subjectId: context.subjectId,
        );
      },
    );
  }
}
