import '../glucose_sync_context.dart';
import '../glucose_sync_result.dart';
import '../glucose_sync_retry_policy.dart';
import '../glucose_sync_step.dart';

class CheckSourceAvailabilityStep extends GlucoseSyncStep {
  final GlucoseSyncRetryPolicy retryPolicy;

  const CheckSourceAvailabilityStep({required this.retryPolicy});

  @override
  Future<void> execute(GlucoseSyncContext context) async {
    final available = await retryPolicy.run(context.source.isAvailable);
    if (available) return;
    await context.database.recordSourceError(
      context.sourceKey,
      'source_unavailable',
      subjectId: context.subjectId,
    );
    context.stopWith(
      GlucoseSyncResult.unavailable(
        source: context.source.type,
        subjectId: context.subjectId,
      ),
    );
  }
}
