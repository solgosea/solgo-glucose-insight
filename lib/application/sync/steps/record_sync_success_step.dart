import '../glucose_sync_context.dart';
import '../glucose_sync_result.dart';
import '../glucose_sync_step.dart';

class RecordSyncSuccessStep extends GlucoseSyncStep {
  const RecordSyncSuccessStep();

  @override
  Future<void> execute(GlucoseSyncContext context) async {
    final cursor =
        context.readings.isEmpty
            ? context.plan?.previousCursor
            : context.readings.last.timestamp;

    await context.database.recordSourceSuccess(
      context.sourceKey,
      cursor: cursor?.millisecondsSinceEpoch.toString(),
      subjectId: context.subjectId,
    );

    context.stopWith(
      GlucoseSyncResult(
        source: context.source.type,
        subjectId: context.subjectId,
        success: true,
        available: true,
        fetchedCount: context.readings.length,
        storedCount: context.etlResult?.canonicalCount ?? 0,
        cursor: cursor,
        error: null,
        readings: context.readings,
      ),
    );
  }
}
