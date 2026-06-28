import '../sync/glucose_sync_result.dart';

class GlucoseSyncSchedulerResult {
  final List<GlucoseSyncResult> results;
  final int skippedCount;
  final int runningCount;
  final int failedCount;
  final int completedCount;

  GlucoseSyncSchedulerResult({
    required this.results,
    this.skippedCount = 0,
    this.runningCount = 0,
    int? failedCount,
    int? completedCount,
  })  : failedCount =
            failedCount ?? results.where((result) => !result.success).length,
        completedCount = completedCount ?? results.length;

  bool get hasFailures => failedCount > 0;

  int get fetchedCount => results.fold(
        0,
        (total, result) => total + result.fetchedCount,
      );

  int get storedCount => results.fold(
        0,
        (total, result) => total + result.storedCount,
      );
}
