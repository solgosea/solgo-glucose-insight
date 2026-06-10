import '../glucose_sync_context.dart';
import '../glucose_sync_error_classifier.dart';
import '../glucose_sync_result.dart';

class RecordSyncFailureStep {
  final GlucoseSyncErrorClassifier errorClassifier;

  const RecordSyncFailureStep({required this.errorClassifier});

  Future<GlucoseSyncResult> execute(
    GlucoseSyncContext context,
    Object error,
  ) async {
    final reason = errorClassifier.classify(error);
    await context.database.recordSourceError(
      context.sourceKey,
      reason,
      subjectId: context.subjectId,
    );
    return GlucoseSyncResult.failure(
      source: context.source.type,
      subjectId: context.subjectId,
      error: reason,
    );
  }
}
