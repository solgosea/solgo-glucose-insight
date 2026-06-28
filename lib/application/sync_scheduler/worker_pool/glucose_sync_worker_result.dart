import '../../sync/glucose_sync_result.dart';
import 'glucose_sync_worker_error.dart';

class GlucoseSyncWorkerResult {
  final String targetId;
  final GlucoseSyncResult? result;
  final GlucoseSyncWorkerError? error;
  final bool skipped;

  const GlucoseSyncWorkerResult.completed({
    required this.targetId,
    required GlucoseSyncResult this.result,
  })  : error = null,
        skipped = false;

  const GlucoseSyncWorkerResult.failed({
    required this.targetId,
    required GlucoseSyncWorkerError this.error,
  })  : result = null,
        skipped = false;

  const GlucoseSyncWorkerResult.skipped({
    required this.targetId,
  })  : result = null,
        error = null,
        skipped = true;
}
