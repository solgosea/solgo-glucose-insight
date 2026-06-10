import 'package:smart_xdrip/application/sync/glucose_sync_result.dart';

class GlucoseSourceSyncResult {
  final List<GlucoseSyncResult> sourceResults;

  const GlucoseSourceSyncResult({required this.sourceResults});

  bool get success => sourceResults.any((result) => result.success);

  int get fetchedCount =>
      sourceResults.fold(0, (total, result) => total + result.fetchedCount);

  int get storedCount =>
      sourceResults.fold(0, (total, result) => total + result.storedCount);

  Set<String> get updatedSubjectIds => {
    for (final result in sourceResults) ...result.updatedSubjectIds,
  };
}
