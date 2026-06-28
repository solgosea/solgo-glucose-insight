import '../glucose_sync_context.dart';
import '../glucose_sync_result.dart';
import '../glucose_sync_step.dart';

class RecordSyncSuccessStep extends GlucoseSyncStep {
  const RecordSyncSuccessStep();

  @override
  Future<void> execute(GlucoseSyncContext context) async {
    final plan = context.plan;
    final cursor = context.readings.isEmpty
        ? plan?.previousCursor
        : context.readings.last.timestamp;
    final coverage = await _coverageFor(context, cursor);

    await context.database.recordSourceSuccess(
      context.sourceKey,
      cursor: cursor?.millisecondsSinceEpoch.toString(),
      subjectId: context.subjectId,
      fetchedCount: context.readings.length,
      storedCount: context.etlResult?.canonicalCount ?? 0,
      coveredFrom: coverage.$1,
      coveredTo: coverage.$2,
      syncWindowDays: context.settings.initialSyncDays,
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

  Future<(DateTime?, DateTime?)> _coverageFor(
    GlucoseSyncContext context,
    DateTime? cursor,
  ) async {
    final actualEarliest =
        (await context.database.earliest(subjectId: context.subjectId))
            ?.timestamp;
    final actualLatest =
        (await context.database.latest(subjectId: context.subjectId))
            ?.timestamp;
    DateTime? coveredFrom = actualEarliest;
    DateTime? coveredTo = actualLatest;
    if (actualEarliest != null || actualLatest != null) {
      coveredTo = _latest(coveredTo, cursor);
    }
    return (coveredFrom, coveredTo);
  }

  DateTime? _latest(DateTime? current, DateTime? candidate) {
    if (candidate == null) return current;
    if (current == null || candidate.isAfter(current)) return candidate;
    return current;
  }
}
